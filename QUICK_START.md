# 🚀 Quick Start Guide

Get up and running with your local Kubernetes learning environment in minutes!

## ⚡ Prerequisites (5 minutes)

1. **Install Docker Desktop**
   - Download from: https://www.docker.com/products/docker-desktop
   - Install and restart your computer
   - Open Docker Desktop → Settings → Kubernetes → Enable Kubernetes
   - Wait for Kubernetes to start (green light in bottom left)

2. **Verify Installation**
   ```powershell
   # Run this to check everything is working
   .\scripts\verify-setup.ps1
   ```

## 🎯 Deploy Everything (2 minutes)

```powershell
# Deploy the complete learning environment (Kustomize overlay)
.\scripts\deploy.ps1
```

## 🧪 Start Learning (Immediate!)

### 1. **See What's Running**
```bash
# View all resources in your cluster
kubectl get all -n kubetest

# Watch resources in real-time
kubectl get all -n kubetest -w
```

### 2. **Access Your Applications**
```bash
# Access the frontend (opens in browser)
kubectl port-forward service/frontend-service 8080:80 -n kubetest

# Access the backend API
kubectl port-forward service/backend-service 8000:8000 -n kubetest
```

### 3. **Run Your First ETL Job**
```bash
# Create a manual ETL job
kubectl create job --from=cronjob/etl-daily-job my-first-etl -n kubetest

# Watch it run
kubectl logs job/my-first-etl -n kubetest -f
```

## 📚 What You'll Learn

- ✅ **Pods & Containers** - The building blocks
- ✅ **Deployments** - Managing application lifecycles  
- ✅ **Services** - Making apps accessible
- ✅ **ConfigMaps & Secrets** - Configuration management
- ✅ **Jobs & CronJobs** - Batch processing (like your ETL!)
- ✅ **Persistent Storage** - Database persistence
- ✅ **Scaling** - Growing your applications
- ✅ **Monitoring** - Watching what's happening

## 🔍 Explore Your Cluster

```bash
# See all namespaces
kubectl get namespaces

# Check pod status
kubectl get pods -n kubetest

# View service endpoints
kubectl get endpoints -n kubetest

# Check resource usage
kubectl top pods -n kubetest
```

## 🎮 Hands-On Exercises

### Exercise 1: Scale Up
```bash
# Scale frontend to 5 replicas
kubectl scale deployment frontend-deployment --replicas=5 -n kubetest

# Watch the scaling happen
kubectl get pods -n kubetest -w
```

### Exercise 2: Update Application
```bash
# Update the backend image
kubectl set image deployment/backend-deployment backend=python:3.10-alpine -n kubetest

# Watch the rolling update
kubectl rollout status deployment/backend-deployment -n kubetest
```

### Exercise 3: Configuration Changes
```bash
# Update logging level
kubectl patch configmap app-config -n kubetest --patch '{"data":{"logging.level":"DEBUG"}}'

# Restart to pick up changes
kubectl rollout restart deployment/backend-deployment -n kubetest
```

## 🧹 Clean Up When Done

```powershell
# Remove everything
.\scripts\cleanup.ps1
```

## 📖 Deep Dive

- **Full Learning Guide**: `LEARNING_GUIDE.md`
- **Kubernetes Concepts**: https://kubernetes.io/docs/concepts/
- **kubectl Cheat Sheet**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

## 🆘 Need Help?

- **Verify Setup**: `.\scripts\verify-setup.ps1`
- **Check Logs**: `kubectl logs <pod-name> -n kubetest`
- **Describe Resources**: `kubectl describe <resource> <name> -n kubetest`
- **Kubernetes Docs**: https://kubernetes.io/docs/

---

**🎯 Goal**: By the end of this, you'll understand how your company's Azure Kubernetes setup works and won't need to stress your colleague for basic K8s help!

**⏱️ Time Investment**: 30 minutes to deploy, 2-3 hours to experiment and learn the basics. 