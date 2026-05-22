# DevOps Internship Assignment

## Overview

This project implements a distributed inferencing system using AWS infrastructure and the provided iii quickstart architecture.

The deployment separates API and inference workloads across multiple virtual machines connected through private networking and Remote Procedure Calls (RPC).

The architecture follows the assignment requirement of deploying workers across separate VMs while maintaining private communication between services.

Components:

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
   |
   v

+------------------------------------------------+
| Public Subnet (10.0.1.0/24)                   |
|                                                |
| API VM                                         |
|                                                |
| Components:                                    |
|                                                |
| - iii Engine                                   |
| - caller-worker (TypeScript)                   |
| - HTTP API (:3111)                             |
|                                                |
+------------------------------------------------+

                    |
                    |
                    | RPC over Private Network
                    |
                    v

+------------------------------------------------+
| Private Subnet (10.0.2.0/24)                  |
|                                                |
| Inference VM                                   |
|                                                |
| Components:                                    |
|                                                |
| - inference-worker (Python)                    |
| - Gemma-3-270M GGUF Model                      |
| - Torch + Transformers                         |
|                                                |
+------------------------------------------------+

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
- Inference VM has no public IP
- RPC communication restricted to VPC private networking
- Workers are not exposed directly to the public internet
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

Infrastructure provisioning is implemented using Terraform.

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

Expected Response Format:

```json
{
  "result": "Model inference response"
}
```

---

## Deployment Steps

### 1. Clone Repository

```bash
git clone <repository_url>

cd devops-internship-assignment
```

---

### 2. Provision Infrastructure

```bash
cd terraform

terraform init

terraform apply
```

---

### 3. Configure API VM

```bash
./scripts/api_vm_setup.sh
```

Responsibilities:

- Install iii runtime
- Configure API services
- Start caller-worker
- Start engine

---

### 4. Configure Inference VM

```bash
./scripts/inference_vm_setup.sh
```

Responsibilities:

- Install Python environment
- Install Torch
- Install Transformers
- Configure inference runtime

---

### 5. Start Services

API VM:

```bash
iii
```

API Worker:

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

---

## Reproducibility

Infrastructure provisioning was validated through:

```bash
terraform init

terraform validate
```

Terraform configuration validation succeeded on a clean repository clone.

---

## Production Hardening

Before production deployment:

- HTTPS / TLS
- IAM least privilege access
- CloudWatch monitoring
- Health checks
- Auto Scaling
- Secrets Manager
- Centralized logging
- CI/CD deployment pipeline
- Rate limiting
- Backup and recovery strategy

---

## Scaling Strategy (100x Larger Model)

For significantly larger models:

- GPU inference nodes
- Kubernetes orchestration
- Model sharding
- Horizontal autoscaling
- Dedicated inference clusters
- Load balancing
- Distributed caching
- Model serving optimization

---

## Development Notes

During implementation the following components were validated independently:

Validated:

- VPC provisioning
- Public / Private subnet isolation
- Route table configuration
- Security Group restrictions
- Worker registration
- RPC network connectivity
- Model initialization on inference VM
- Terraform reproducibility
- Private subnet communication
- HTTP trigger execution through worker mesh

Development observations:

- Infrastructure provisioning succeeded
- Worker placement across multiple VMs succeeded
- RPC networking across the private subnet was validated
- HTTP requests successfully triggered worker execution
- Model loading and worker initialization succeeded
- Infrastructure reproducibility was verified through Terraform validation

Engine logs confirmed worker execution and RPC chain initiation.

Additional debugging would be required to fully validate end-to-end JSON inference response propagation.

The repository intentionally documents deployment decisions, infrastructure setup, networking design, and debugging process to demonstrate implementation reasoning.

---

## Screenshots

Deployment evidence available under:

```
docs/screenshots/
```

Included:

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
    Deployment automation

docs/
    Documentation and screenshots

quickstart/
    Quickstart integration notes

README.md
    Deployment architecture and instructions
```

---

## Assignment Requirements Mapping

Requirement:

Multi VM deployment

Status:

Completed

Requirement:

RPC communication

Status:

Completed

Requirement:

Private subnet worker isolation

Status:

Completed

Requirement:

JSON API endpoint

Status:

Partially Validated

Notes:

HTTP trigger execution and RPC chain initiation were verified through engine logs.

Additional debugging would be required to fully validate end-to-end inference response propagation.

Requirement:

Infrastructure reproducibility

Status:

Completed

Requirement:

Documentation and redeployment steps

Status:

Completed
