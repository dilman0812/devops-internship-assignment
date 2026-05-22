# EC2 Infrastructure

## api-vm

Purpose:
Hosts:

- iii engine
- iii-http
- caller-worker

Subnet:
public-subnet

Security Group:
api-vm-sg

Public Access:
Enabled

---

## inference-vm

Purpose:

- inference-worker
- Gemma SLM inference

Subnet:
private-subnet

Security Group:
inference-vm-sg

Public Access:
Disabled
