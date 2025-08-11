# Local Kubernetes Learning Environment

This project sets up a local Kubernetes environment to help you understand the basics of Kubernetes, Docker, and container orchestration before working with your company's Azure Kubernetes Service (AKS).

## What You'll Learn

- **Kubernetes Basics**: Pods, Services, Deployments, ConfigMaps, Secrets
- **Container Management**: Building and running Docker containers
- **Service Discovery**: How services communicate within the cluster
- **Configuration Management**: Using ConfigMaps and Secrets
- **Queue Processing**: RabbitMQ for async jobs (publisher in backend, consumer in worker)
- **Scaling**: Horizontal Pod Autoscaling and manual scaling
- **Monitoring**: Basic cluster monitoring and logging

## Prerequisites

1. **Docker Desktop** (includes Kubernetes)
   - Download from: https://www.docker.com/products/docker-desktop
   - Enable Kubernetes in Docker Desktop settings

2. **kubectl** (Kubernetes command-line tool)
   - Usually comes with Docker Desktop
   - Verify with: `kubectl version --client`

3. **Flux CLI** (optional, for GitOps bootstrap)
   - Install: https://fluxcd.io/flux/installation/

4. (Later) **SOPS + age** for encrypted GitOps secrets
   - https://fluxcd.io/flux/guides/mozilla-sops/

## Quick Start

1. **Start Kubernetes**:
   ```bash
   kubectl cluster-info
   ```

2. **Deploy via Kustomize (GitOps-ready)**:
   ```bash
   .\scripts\build-images.ps1
   kubectl apply -k k8s/overlays/dev
   ```

3. **Access Applications**:
   ```bash
   kubectl port-forward service/dev-backend-service 8000:8000 -n kubetest
   curl http://localhost:8000/health
   ```

## Components

- **Backend (FastAPI)**: Publishes jobs to RabbitMQ and exposes APIs
- **Worker (Python)**: Consumes jobs from RabbitMQ and runs ETL, stores results in Supabase
- **RabbitMQ**: Message broker for decoupled async processing
- **ETL**: Example job and cronjob
- **Supabase**: External managed Postgres + APIs (provide credentials via Secret)

## Secrets

- Dev overlay contains plain Secrets for local testing (`k8s/overlays/dev/secrets/`).
- For GitOps/prod, use SOPS to encrypt secrets and commit safely.

## Project Structure

```
kubetest/
├── k8s/                    # Kubernetes manifests
│   ├── frontend/          # Frontend application
│   ├── backend/           # Backend API
│   ├── database/          # Database (PostgreSQL)
│   └── monitoring/        # Basic monitoring stack
├── apps/                  # Application source code
│   ├── frontend/          # Simple web frontend
│   ├── backend/           # Python backend API
│   └── etl/              # ETL process example
├── docker/                # Dockerfiles
└── scripts/               # Helper scripts
```

## Learning Path

1. **Start Simple**: Deploy a single pod
2. **Add Services**: Make pods accessible
3. **Use Deployments**: Manage pod lifecycles
4. **Add Configuration**: ConfigMaps and Secrets
5. **Scale Applications**: Manual and automatic scaling
6. **Monitor & Debug**: Logs, metrics, and troubleshooting

## Common Commands

```bash
# View cluster status
kubectl cluster-info

# List all resources
kubectl get all

# View pod logs
kubectl logs <pod-name>

# Execute commands in pods
kubectl exec -it <pod-name> -- /bin/bash

# View resource details
kubectl describe <resource-type> <resource-name>

# Port forwarding
kubectl port-forward service/<service-name> <local-port>:<service-port>
```

## Next Steps

After mastering the basics here, you'll be ready to:
- Understand your company's Azure Kubernetes setup
- Contribute to Kubernetes manifests and deployments
- Troubleshoot common K8s issues
- Work with your DevOps team more effectively

## Troubleshooting

- **Kubernetes not starting**: Check Docker Desktop settings
- **Pods stuck in Pending**: Check resource availability
- **Services not accessible**: Verify service configuration and port forwarding 