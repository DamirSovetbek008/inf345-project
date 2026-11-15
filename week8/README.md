# Week 8 lab

Completed manifests are in `playground/`.

```bash
kubectl config use-context kind-inf345
kubectl apply -f playground/web-deployment.yaml
kubectl apply -f playground/web-service.yaml
kubectl get deploy,rs,pods,svc
kubectl scale deployment/web --replicas=5
kubectl scale deployment/web --replicas=3
kubectl rollout status deployment/web
kubectl rollout history deployment/web
kubectl rollout undo deployment/web
kubectl apply -f playground/mine.yaml
kubectl rollout status deployment/mine --timeout=120s
kubectl port-forward service/mine 8080:80
```

In another terminal, verify the M3 service with `curl -i localhost:8080/healthz`.
The image is pinned to the full SHA of the application commit that adds the M4 settings.
