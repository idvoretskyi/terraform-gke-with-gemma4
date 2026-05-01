# GEMINI.md

## Project Overview

This project provides Terraform configuration for deploying a cost-optimized GKE cluster that serves Google's [Gemma 4](https://ollama.com/library/gemma4) model via [Ollama](https://ollama.com).

Highlights:

- ARM-based `t2a-standard-2` Spot VMs for cost efficiency.
- Auto-detection of `project_id`, `region`, `zone`, and billing/quota project from the local `gcloud` config.
- Workload Identity, Gateway API, and Managed Prometheus enabled by default.
- Dedicated tainted node pool ensures only Gemma 4 pods run there.
- `gemma4:e2b` is pulled into Ollama on container startup; switching to `e4b`, `26b`, `31b` is a single variable.

The configuration is split into three reusable local modules and a thin example consumer:

```
modules/network/   VPC + subnet + secondary ranges
modules/gke/       Cluster + node pool (Workload Identity, optional GPU)
modules/gemma4/    Namespace + Deployment + Service (Ollama serving Gemma 4)
examples/basic/    Wires the modules together; gcloud auto-detect lives here
```

## Building and Running

Requires Terraform >= 1.13, `gcloud`, and `jq`.

1. **Authenticate and set project**
   ```bash
   gcloud auth login
   gcloud auth application-default login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **Apply**
   ```bash
   cd examples/basic
   terraform init
   terraform apply
   ```

3. **Configure kubectl**
   ```bash
   $(terraform output -raw kubectl_configure_command)
   ```

4. **Talk to Gemma 4**
   ```bash
   $(terraform output -raw gemma4_check_status_command)
   EXTERNAL_IP=$(kubectl -n gemma4 get svc gemma4 -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   curl http://$EXTERNAL_IP/api/generate -d '{"model":"gemma4:e2b","prompt":"Hello"}'
   ```

## Provider Stack

- `hashicorp/google ~> 7.30`
- `hashicorp/kubernetes ~> 3.1` (uses `_v1` versioned resources throughout)
- `hashicorp/external ~> 2.3` (used to ingest gcloud config)
- Terraform CLI `>= 1.13.0`

## Development Conventions

- **Modules are pure**: they take explicit `project_id` / `location` inputs. The gcloud-derived defaults live only in `examples/basic/gcloud_defaults.tf` so the modules stay reusable.
- **Variable defaults** are tuned for `gemma4:e2b` on `t2a-standard-2`. Bumping the model size or moving to GPU is documented in `README.md`.
- **State files** are not stored in the repo. Use a remote backend for production (`README.md` shows a GCS backend snippet).
- **Format and validate** before committing:
  ```bash
  terraform fmt -recursive
  terraform -chdir=examples/basic init -backend=false
  terraform -chdir=examples/basic validate
  ```
