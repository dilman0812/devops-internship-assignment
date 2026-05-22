# Architecture

Internet
↓

API VM
Public Subnet

Responsibilities:

- HTTP API
- iii Engine
- caller-worker

↓

RPC over VPC

↓

Inference VM
Private Subnet

Responsibilities:

- Model inference
- Torch runtime
- Gemma model

Private communication enforced using security groups.

Inference VM has no public IP.
