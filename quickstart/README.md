# Quickstart Worker Layout

This project uses the provided distributed inferencing prototype.

Workers:

## inference-worker

Language:

Python

RPC Function:

inference::run_inference

Responsibilities:

- Loads gemma-3-270m GGUF model
- Applies chat template
- Executes inference
- Returns decoded model output

VM Placement:

Private subnet inference VM

---

## caller-worker

Language:

TypeScript

RPC Function:

inference::get_response

Responsibilities:

- Receives request payload
- Calls inference::run_inference
- Returns inference result

VM Placement:

API VM

---

## HTTP Trigger

Function:

http::run_inference_over_http

Endpoint:

POST /v1/chat/completions

Responsibilities:

- Accept HTTP request
- Dispatch RPC request
- Return JSON response
