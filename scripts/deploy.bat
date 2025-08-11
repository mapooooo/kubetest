@echo off
REM Kubernetes Deployment Script for KubeTest Learning Environment
REM This script deploys all resources to your local Kubernetes cluster

echo 🚀 Deploying KubeTest Learning Environment to Kubernetes...

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ kubectl not found. Please install kubectl first.
    pause
    exit /b 1
)

REM Check if Kubernetes cluster is running
kubectl cluster-info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Kubernetes cluster not accessible. Please start Docker Desktop with Kubernetes enabled.
    pause
    exit /b 1
)

echo ✅ Kubernetes cluster is running

REM Create namespace
echo 📦 Creating namespace: kubetest
kubectl apply -f k8s/namespace.yaml

REM Wait for namespace to be ready
timeout /t 2 /nobreak >nul

REM Build local images (optional)
IF EXIST scripts\build-images.ps1 (
  echo 🐳 Building local images...
  powershell -ExecutionPolicy Bypass -File scripts\build-images.ps1 -Tag dev
)

REM Apply Kustomize overlay (dev)
echo 🚀 Applying Kustomize overlay (dev)...
kubectl apply -k k8s/overlays/dev

REM Wait for all deployments to be ready
echo ⏳ Waiting for all deployments to be ready...
kubectl wait --for=condition=available deployment --all -n kubetest --timeout=300s

REM Show deployment status
echo 📊 Deployment Status:
kubectl get all -n kubetest

echo.
echo 🎉 Deployment completed successfully!
echo.
echo 📋 Next steps:
echo 1. Check pod status: kubectl get pods -n kubetest
echo 2. View logs: kubectl logs ^<pod-name^> -n kubetest
echo 3. Port forward services: kubectl port-forward service/frontend-service 8080:80 -n kubetest
echo 4. Access dashboard: kubectl proxy
echo.
pause 