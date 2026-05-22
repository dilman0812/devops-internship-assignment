#!/bin/bash

echo "Initializing Terraform..."

terraform init

echo "Provisioning Infrastructure..."

terraform apply -auto-approve

echo "Infrastructure deployed"

echo "Configure API VM"

echo "Configure Inference VM"

echo "Start iii engine"

echo "Start caller-worker"

echo "Start inference-worker"

echo "Deployment complete"
