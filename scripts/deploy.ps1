# Kubernetes Deployment Script for KubeTest Learning Environment
# This script deploys all resources to your local Kubernetes cluster

param(
    [string]$Namespace = "kubetest",
    [switch]$Clean,
    [switch]$Watch
)

Write-Host "🚀 Deploying KubeTest Learning Environment to Kubernetes..." -ForegroundColor Green

# Check if kubectl is available
try {
    $kubectlVersion = kubectl version --client
    Write-Host "✅ kubectl found: $kubectlVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl not found. Please install kubectl first." -ForegroundColor Red
    exit 1
}

# Check if Kubernetes cluster is running
try {
    kubectl cluster-info | Out-Null
    Write-Host "✅ Kubernetes cluster is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Kubernetes cluster not accessible. Please start Docker Desktop with Kubernetes enabled." -ForegroundColor Red
    exit 1
}

# Ensure namespace exists
Write-Host "📦 Ensuring namespace exists" -ForegroundColor Yellow
kubectl apply -f k8s/namespace.yaml

# Optional: build local images
if (Test-Path .\scripts\build-images.ps1) {
    Write-Host "🐳 Building local images..." -ForegroundColor Yellow
    .\scripts\build-images.ps1 -Tag dev
}

# Apply Kustomize overlay (dev)
Write-Host "🚀 Applying Kustomize overlay (dev)..." -ForegroundColor Yellow
kubectl apply -k k8s/overlays/dev

# Wait for all deployments to be ready
Write-Host "⏳ Waiting for all deployments to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=available deployment --all -n $Namespace --timeout=300s

# Show deployment status
Write-Host "📊 Deployment Status:" -ForegroundColor Green
kubectl get all -n $Namespace

Write-Host "`n🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host "`n📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Check pod status: kubectl get pods -n $Namespace" -ForegroundColor White
Write-Host "2. View logs: kubectl logs <pod-name> -n $Namespace" -ForegroundColor White
Write-Host "3. Port forward services: kubectl port-forward service/frontend-service 8080:80 -n $Namespace" -ForegroundColor White
Write-Host "4. Access dashboard: kubectl proxy" -ForegroundColor White

if ($Watch) {
    Write-Host "`n👀 Watching resources (Ctrl+C to stop)..." -ForegroundColor Yellow
    kubectl get all -n $Namespace -w
} 