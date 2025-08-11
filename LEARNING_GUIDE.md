# Kubernetes Learning Guide

This guide will walk you through the key Kubernetes concepts using your local environment.

## 🚀 Getting Started

### 1. Prerequisites Check
First, ensure you have the required tools installed:

```powershell
# Check if kubectl is available
kubectl version --client

# Check if Kubernetes cluster is running
kubectl cluster-info
```

### 2. Deploy the Learning Environment
```powershell
# Deploy all resources
.\scripts\deploy.ps1

# Or deploy with watch mode to see real-time updates
.\scripts\deploy.ps1 -Watch
```

## 📚 Core Kubernetes Concepts

### 1. **Namespaces**
Namespaces provide a way to organize and isolate resources within a cluster.

```bash
# View all namespaces
kubectl get namespaces

# View resources in our namespace
kubectl get all -n kubetest
```

### 2. **Pods**
Pods are the smallest deployable units in Kubernetes. They contain one or more containers.

```bash
# List all pods
kubectl get pods -n kubetest

# Get detailed information about a pod
kubectl describe pod <pod-name> -n kubetest

# View pod logs
kubectl logs <pod-name> -n kubetest

# Execute commands in a pod
kubectl exec -it <pod-name> -n kubetest -- /bin/bash
```

### 3. **Deployments**
Deployments manage the lifecycle of pods, providing updates, rollbacks, and scaling.

```bash
# List deployments
kubectl get deployments -n kubetest

# Scale a deployment
kubectl scale deployment frontend-deployment --replicas=3 -n kubetest

# Update deployment (rolling update)
kubectl set image deployment/frontend-deployment frontend=nginx:latest -n kubetest

# Rollback to previous version
kubectl rollout undo deployment/frontend-deployment -n kubetest
```

### 4. **Services**
Services provide stable endpoints for pods, enabling communication between components.

```bash
# List services
kubectl get services -n kubetest

# Port forward to access services locally
kubectl port-forward service/frontend-service 8080:80 -n kubetest

# View service details
kubectl describe service frontend-service -n kubetest
```

### 5. **ConfigMaps and Secrets**
ConfigMaps and Secrets store configuration data and sensitive information.

```bash
# List configmaps
kubectl get configmaps -n kubetest

# View configmap data
kubectl get configmap app-config -n kubetest -o yaml

# List secrets
kubectl get secrets -n kubetest
```

### 6. **Persistent Volumes**
Persistent Volumes provide persistent storage for applications.

```bash
# List persistent volume claims
kubectl get pvc -n kubetest

# View PVC details
kubectl describe pvc postgres-pvc -n kubetest
```

### 7. **Jobs and CronJobs**
Jobs run to completion, while CronJobs run on a schedule.

```bash
# List jobs
kubectl get jobs -n kubetest

# List cronjobs
kubectl get cronjobs -n kubetest

# Manually trigger a cronjob
kubectl create job --from=cronjob/etl-daily-job manual-etl-job -n kubetest
```

## 🔍 Monitoring and Debugging

### 1. **Resource Monitoring**
```bash
# View resource usage
kubectl top pods -n kubetest

# View node resource usage
kubectl top nodes

# Get resource details
kubectl describe node <node-name>
```

### 2. **Logs and Events**
```bash
# View pod logs
kubectl logs <pod-name> -n kubetest

# Follow logs in real-time
kubectl logs -f <pod-name> -n kubetest

# View events
kubectl get events -n kubetest --sort-by='.lastTimestamp'
```

### 3. **Troubleshooting**
```bash
# Check pod status
kubectl get pods -n kubetest -o wide

# Describe pod for detailed information
kubectl describe pod <pod-name> -n kubetest

# Check service endpoints
kubectl get endpoints -n kubetest
```

## 🧪 Hands-On Exercises

### Exercise 1: Scale Applications
```bash
# Scale the frontend to 5 replicas
kubectl scale deployment frontend-deployment --replicas=5 -n kubetest

# Watch the scaling process
kubectl get pods -n kubetest -w
```

### Exercise 2: Update Applications
```bash
# Update the backend image
kubectl set image deployment/backend-deployment backend=python:3.10-alpine -n kubetest

# Watch the rolling update
kubectl rollout status deployment/backend-deployment -n kubetest
```

### Exercise 3: Run ETL Jobs
```bash
# Create a manual ETL job
kubectl create job --from=cronjob/etl-daily-job test-etl-job -n kubetest

# Monitor job progress
kubectl get jobs -n kubetest
kubectl logs job/test-etl-job -n kubetest
```

### Exercise 4: Configuration Management
```bash
# Update a configmap
kubectl patch configmap app-config -n kubetest --patch '{"data":{"logging.level":"DEBUG"}}'

# Restart pods to pick up new configuration
kubectl rollout restart deployment/backend-deployment -n kubetest
```

## 🗑️ Cleanup

When you're done learning:

```powershell
# Clean up all resources
.\scripts\cleanup.ps1

# Or force cleanup without confirmation
.\scripts\cleanup.ps1 -Force
```

## 🔗 Useful Commands Reference

### Basic Commands
```bash
kubectl get all                    # List all resources
kubectl get pods                   # List pods
kubectl get services              # List services
kubectl get deployments           # List deployments
kubectl get nodes                 # List nodes
```

### Resource Management
```bash
kubectl apply -f <file>           # Apply configuration
kubectl delete -f <file>          # Delete resources
kubectl create -f <file>          # Create resources
kubectl replace -f <file>         # Replace resources
```

### Debugging
```bash
kubectl describe <resource>       # Describe resource details
kubectl logs <pod>                # View pod logs
kubectl exec -it <pod> -- bash   # Execute command in pod
kubectl port-forward <service>    # Port forward service
```

## 📖 Next Steps

After mastering these basics:

1. **Learn about Ingress** for external access
2. **Explore Helm** for package management
3. **Study RBAC** for security and permissions
4. **Understand StatefulSets** for stateful applications
5. **Learn about Operators** for complex applications

## 🆘 Getting Help

- **Kubernetes Documentation**: https://kubernetes.io/docs/
- **kubectl Cheat Sheet**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- **Kubernetes Examples**: https://github.com/kubernetes/examples 