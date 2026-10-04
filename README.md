# INF 345 Project

A simple HTTP service written in Python for the INF 345 DevOps course.

## Run

Start the service:

bash scripts/run.sh

The service uses the PORT environment variable and defaults to port 8080.

Example:

PORT=9999 bash scripts/run.sh

## Health Check

GET /healthz

Returns HTTP 200 with:

OK

## Tests

Run the automated tests:

bash scripts/test.sh

Expected result:

TESTS: 3/3