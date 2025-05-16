# Python Code Execution API with Flask & nsjail

This service lets you safely execute arbitrary Python scripts via an API. It uses Flask for the API and nsjail for sandboxing. Suitable for Google Cloud Run.

## Features
- POST /execute endpoint: Send a Python script, get the result of main() and stdout.
- Only the return value of main() is returned as `result` (must be JSON serializable).
- Stdout is captured separately.
- Safe execution using nsjail.
- Supports basic libraries: os, pandas, numpy.

## Usage

### Build Docker Image
```
docker build -t python-exec-api .
```

### Run Locally
```
docker run --rm -p 8080:8080 --privileged python-exec-api
```

### Example cURL Request (Cloud Run)
```
curl -X POST https://YOUR_CLOUD_RUN_URL/execute \
  -H "Content-Type: application/json" \
  -d '{"script": "def main():\n    import pandas as pd\n    return {\\"hello\\": \\\"world\\"}"}'
```

### Example cURL Request (Local)
```
curl -X POST http://localhost:8080/execute \
  -H "Content-Type: application/json" \
  -d '{"script": "def main():\n    return {\\"hello\\": \\\"world\\"}"}'
```

## Input Validation
- The script must contain a `main()` function.
- `main()` must return a JSON-serializable object.

## Security
- All code is executed in a locked-down nsjail sandbox.
- Resource limits are enforced.

## Notes
- The Docker image is slim and suitable for Cloud Run.
- You must use `--privileged` for nsjail to work locally.

## Time Estimate
- Estimated time to complete: 1-2 hours.

---

Replace `YOUR_CLOUD_RUN_URL` with your deployed Cloud Run endpoint.