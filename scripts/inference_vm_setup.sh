#!/bin/bash

curl -fsSL https://install.iii.dev/iii/main/install.sh | sh

curl -LsSf https://astral.sh/uv/install.sh | sh

uv python install 3.11

uv venv --python 3.11

source .venv/bin/activate

uv pip install torch \
--index-url https://download.pytorch.org/whl/cpu

uv pip install \
iii-sdk \
watchfiles \
transformers \
gguf \
accelerate
