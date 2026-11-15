#!/usr/bin/env bash
set -euo pipefail

kubectl config use-context "${CLUSTER_CONTEXT:-kind-inf345}"
kubectl get nodes
kubectl wait node --all --for=condition=Ready --timeout=120s
namespace=week8-lab
kubectl create namespace "$namespace"
trap 'kubectl delete namespace "$namespace" --wait=false' EXIT
k() { kubectl -n "$namespace" "$@"; }
cd "$(dirname "$0")"

k run web --image=nginx:1.30.5-alpine --restart=Never
k wait pod/web --for=condition=Ready --timeout=120s
k delete pod web
test -z "$(k get pods -o name)"

sed 's/nginx:1.31.6-alpine/nginx:1.30.5-alpine/' playground/web-deployment.yaml | k apply -f -
k rollout status deployment/web --timeout=120s
pod="$(k get pods -l app=web -o jsonpath='{.items[0].metadata.name}')"
k delete pod "$pod"
k rollout status deployment/web --timeout=120s
test "$(k get deployment web -o jsonpath='{.status.readyReplicas}')" = 3
k get pods

k scale deployment/web --replicas=5
k rollout status deployment/web --timeout=120s
k scale deployment/web --replicas=2
k rollout status deployment/web --timeout=120s
sed 's/nginx:1.31.6-alpine/nginx:1.30.5-alpine/' playground/web-deployment.yaml | k apply -f -
k rollout status deployment/web --timeout=120s
test "$(k get deployment web -o jsonpath='{.status.readyReplicas}')" = 3

k apply -f playground/web-service.yaml
k get endpointslices -l kubernetes.io/service-name=web
k get service web
web_headers() {
  k run "curl-$1" --rm -i --restart=Never --image=curlimages/curl:8.22.0 -- \
    curl -fsSI --max-time 10 --retry 5 --retry-all-errors http://web
}
web_headers original | tee /dev/stderr | grep -i 'Server: nginx/1.30.5'
k patch service web --type=merge -p '{"spec":{"selector":{"app":"wev"}}}'
k get endpointslices -l kubernetes.io/service-name=web
k apply -f playground/web-service.yaml

k apply -f playground/web-deployment.yaml
k rollout status deployment/web --timeout=120s
web_headers upgraded | tee /dev/stderr | grep -i 'Server: nginx/1.31.6'
k set image deployment/web web=nginx:1.31.66-alpine
if k rollout status deployment/web --timeout=25s; then
  echo 'Expected the invalid image rollout to fail'
  exit 1
fi
k get pods
k get events --sort-by=.lastTimestamp
web_headers during-failure | tee /dev/stderr | grep -i 'Server: nginx/1.31.6'
k rollout undo deployment/web
k rollout status deployment/web --timeout=120s
k rollout history deployment/web

k apply -f playground/mine.yaml
k rollout status deployment/mine --timeout=180s
health_path="/api/v1/namespaces/$namespace/services/mine:80/proxy/healthz"
health_response=""
for attempt in {1..10}; do
  if health_response="$(k get --raw "$health_path" 2>/dev/null)" && [[ "$health_response" == "OK" ]]; then
    printf '%s\\n' "$health_response" | tee /dev/stderr
    break
  fi
  sleep 2
done
test "$health_response" = "OK"
