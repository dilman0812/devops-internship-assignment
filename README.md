# DevOps Internship Assignment

## Overview

This project implements a distributed inferencing system using AWS infrastructure and the provided quickstart architecture.

The deployment separates API and inference workloads across multiple virtual machines connected through private networking and Remote Procedure Calls (RPC).

The system contains:

- API VM (Public Subnet)
- Inference VM (Private Subnet)
- RPC communication layer
- JSON HTTP API endpoint
- Infrastructure-as-Code using Terraform

Only the API VM is publicly accessible.

Inference workloads remain isolated inside the private subnet.

---

## Architecture

```text
Internet
   |
   v

+--------------------------------+
| Public Subnet (10.0.1.0/24)   |
|                                |
| API VM                         |
|                                |
| Components:                    |
| - iii Engine                   |
| - caller-worker (TypeScript)  |
| - HTTP API (:3111)            |
+--------------------------------+

               |
               | RPC over Private Network
               v

+--------------------------------+
| Private Subnet (10.0.2.0/24)  |
|                                |
| Inference VM                   |
|                                |
| Components:                    |
| - inference-worker (Python)   |
| - Gemma-3-270M GGUF Model     |
| - Torch + Transformers        |
+--------------------------------+

VPC CIDR:

10.0.0.0/16
```

---

## Worker Responsibilities

### caller-worker (TypeScript)

Functions:

- `inference::get_response`
- `http::run_inference_over_http`

Responsibilities:

- Accept incoming HTTP requests
- Forward payloads through RPC
- Return JSON responses

---

### inference-worker (Python)

Function:

- `inference::run_inference`

Responsibilities:

- Load Gemma-3-270M model
- Process inference requests
- Return decoded model output

---

## RPC Flow

```text
POST /v1/chat/completions

        |

        v

http::run_inference_over_http

        |

        v

inference::get_response

        |

        v

RPC Communication

        |

        v

inference::run_inference

        |

        v

Gemma Model

        |

        v

JSON Response
```

---

## Network Design

VPC:

```
10.0.0.0/16
```

Public Subnet:

```
10.0.1.0/24
```

Private Subnet:

```
10.0.2.0/24
```

Security Design:

- API VM accessible publicly
- Inference VM not exposed publicly
- RPC communication restricted to VPC network
- Security Groups restrict external access

---

## Infrastructure Components

AWS Resources Provisioned:

- VPC
- Public Subnet
- Private Subnet
- Internet Gateway
- Route Tables
- Security Groups
- API VM
- Inference VM

---

## API Example

Request:

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

Example Response:

```json
{
  "result": "DevOps combines software development and operations practices to automate software delivery and improve deployment reliability."
}
```

---

## Deployment Steps

### 1. Provision Infrastructure

```bash
terraform init

terraform apply
```

---

### 2. Configure API VM

```bash
./scripts/api_vm_setup.sh
```

---

### 3. Configure Inference VM

```bash
./scripts/inference_vm_setup.sh
```

---

### 4. Start iii Engine

API VM:

```bash
iii
```

---

### 5. Start Workers

API VM:

```bash
npm run dev
```

Inference VM:

```bash
python inference_worker.py
```

---

### 6. Validate Endpoint

```bash
curl -X POST http://API_VM_IP:3111/v1/chat/completions
```

---

## Production Hardening

Improvements before production deployment:

- TLS / HTTPS
- IAM Least Privilege Access
- CloudWatch Monitoring
- Health Checks
- Auto Scaling
- Secrets Manager
- Rate Limiting
- Centralized Logging
- CI/CD Deployment Pipeline

---

## Scaling Strategy (100x Larger Model)

For significantly larger models:

- GPU inference nodes
- Kubernetes orchestration
- Model sharding
- Horizontal autoscaling
- Load balancing
- Distributed caching
- Dedicated inference clusters

---

## Screenshots

Screenshots demonstrating infrastructure deployment are available under:

```
docs/screenshots/
```

Included evidence:

- VPC creation
- Subnet configuration
- Route tables
- Internet Gateway
- API VM deployment
- Inference VM deployment
- Security Groups
- Network isolation proof

---

## Repository Structure

```text
terraform/
    Infrastructure as Code

scripts/
    Deployment automation scripts

docs/
    Documentation and screenshots

quickstart/
    Quickstart integration notes
```

---

## Notes

The architecture follows the assignment requirement of:

- Multiple VM deployment
- RPC-based worker communication
- Network isolation
- JSON HTTP inference endpoint
- Infrastructure reproducibility
- Independent scaling of API and inference tiers
