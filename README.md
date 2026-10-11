# INF 345 Project

## Overview

A simple HTTP service written in Python 3 for the INF 345 DevOps course. It uses only the Python standard library; no third-party dependencies are required.

- `GET /` returns HTTP 200 with `INF 345 Project`.
- `GET /healthz` returns HTTP 200 with `OK` for health checks.
- Other paths return HTTP 404.

## Run

From the repository root, start the service:

```bash
bash scripts/run.sh
```

The service uses the `PORT` environment variable and defaults to port `8080`. Open `http://localhost:8080/`.

To use a different port:

```bash
PORT=9999 bash scripts/run.sh
```

Stop the service with Ctrl+C.

## Health Check

```bash
curl http://localhost:8080/healthz
```

Expected response: `OK` with HTTP 200.

## Testing

Run the three automated HTTP tests from the repository root:

```bash
bash scripts/test.sh
```

The tests start their own server on a free local port, check the health status, health response body, and home response, then stop the server.

A successful run exits with code 0 and prints:

```text
TESTS: 3/3
```

A failed assertion exits with a nonzero code.

## Continuous Integration

`.github/workflows/main.yml` runs `bash scripts/test.sh` on every `push` and `pull_request`, using Python 3.12 on Ubuntu and Bash with pipefail. The workflow grants only `contents: read`.

For M2, one health response assertion was temporarily changed to an incorrect expected value. GitHub Actions recorded a failed run, and the correct `OK` expectation was restored. The failed run remains in the history; the final tests pass.
