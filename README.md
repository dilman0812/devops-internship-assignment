# DevOps Internship Assignment

## Architecture

Internet
↓
API VM (Public Subnet)
10.0.1.0/24

Components:
- iii Engine
- caller-worker
- HTTP API (:3111)

↓

Private RPC Communication

↓

Inference VM (Private Subnet)
10.0.2.0/24

Components:
- inference-worker
- Gemma-3-270m model
- Torch + Transformers

Network:

VPC: 10.0.0.0/16

Public Subnet:
10.0.1.0/24

Private Subnet:
10.0.2.0/24

Only API VM exposed publicly.

Inference VM reachable only through VPC private networking.

---

## API Example

Request

```bash
curl -X POST http://API_VM_IP:3111/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{
"messages":[
{
"role":"user",
"content":"Explain DevOps simply"
}
]
}'
```

Response

```json
{
"result":"DevOps combines development and operations practices to automate software delivery."
}
```

---

## Deployment

1. Terraform apply
2. Create VPC
3. Launch API VM
4. Launch Inference VM
5. Install iii
6. Deploy workers
7. Start RPC communication

---

## Production Hardening

- Add IAM least privilege
- HTTPS + TLS
- CloudWatch monitoring
- Auto Scaling
- Secrets Manager
- CI/CD pipeline

---

## Scaling 100x Larger Model

- GPU inference nodes
- Model sharding
- Load balancer
- ECS / Kubernetes
- Autoscaling inference workers# DevOps Internship Assignment

## Architecture

Internet
↓
API VM (Public Subnet)
10.0.1.0/24

Components:
- iii Engine
- caller-worker
- HTTP API (:3111)

↓

Private RPC Communication

↓

Inference VM (Private Subnet)
10.0.2.0/24

Components:
- inference-worker
- Gemma-3-270m model
- Torch + Transformers

Network:

VPC: 10.0.0.0/16

Public Subnet:
10.0.1.0/24

Private Subnet:
10.0.2.0/24

Only API VM exposed publicly.

Inference VM reachable only through VPC private networking.

---

## API Example

Request

```bash
curl -X POST http://API_VM_IP:3111/v1/chat/completions \
-H "Content-Type: application/json" \
-d '{
"messages":[
{
"role":"user",
"content":"Explain DevOps simply"
}
]
}'
```

Response

```json
{
"result":"DevOps combines development and operations practices to automate software delivery."
}
```

---

## Deployment

1. Terraform apply
2. Create VPC
3. Launch API VM
4. Launch Inference VM
5. Install iii
6. Deploy workers
7. Start RPC communication

---

## Production Hardening

- Add IAM least privilege
- HTTPS + TLS
- CloudWatch monitoring
- Auto Scaling
- Secrets Manager
- CI/CD pipeline

---

## Scaling 100x Larger Model

- GPU inference nodes
- Model sharding
- Load balancer
- ECS / Kubernetes
- Autoscaling inference workers
