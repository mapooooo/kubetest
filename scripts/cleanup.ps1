# Kubernetes Cleanup Script for KubeTest Learning Environment
# This script removes all resources from your local Kubernetes cluster

param(
    [string]$Namespace = "kubetest",
    [switch]$Force
)

Write-Host "🧹 Cleaning up KubeTest Learning Environment..." -ForegroundColor Yellow

if (-not $Force) {
    $confirmation = Read-Host "Are you sure you want to delete all resources in namespace '$Namespace'? (y/N)"
    if ($confirmation -ne "y" -and $confirmation -ne "Y") {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Delete all resources in the namespace
Write-Host "🗑️  Deleting all resources in namespace: $Namespace" -ForegroundColor Red

# Delete deployments
Write-Host "  - Deleting deployments..." -ForegroundColor Yellow
kubectl delete deployment --all -n $Namespace --ignore-not-found=true

# Delete services
Write-Host "  - Deleting services..." -ForegroundColor Yellow
kubectl delete service --all -n $Namespace --ignore-not-found=true

# Delete jobs and cronjobs
Write-Host "  - Deleting jobs and cronjobs..." -ForegroundColor Yellow
kubectl delete job --all -n $Namespace --ignore-not-found=true
kubectl delete cronjob --all -n $Namespace --ignore-not-found=true

# Delete configmaps and secrets
Write-Host "  - Deleting configmaps and secrets..." -ForegroundColor Yellow
kubectl delete configmap --all -n $Namespace --ignore-not-found=true
kubectl delete secret --all -n $Namespace --ignore-not-found=true

# Delete persistent volume claims
Write-Host "  - Deleting persistent volume claims..." -ForegroundColor Yellow
kubectl delete pvc --all -n $Namespace --ignore-not-found=true

# Delete pods (in case any are left)
Write-Host "  - Deleting remaining pods..." -ForegroundColor Yellow
kubectl delete pod --all -n $Namespace --ignore-not-found=true

# Wait a moment for resources to be cleaned up
Start-Sleep -Seconds 5

# Delete the namespace itself
Write-Host "  - Deleting namespace..." -ForegroundColor Yellow
kubectl delete namespace $Namespace --ignore-not-found=true

Write-Host "✅ Cleanup completed successfully!" -ForegroundColor Green
Write-Host "All resources in namespace '$Namespace' have been removed." -ForegroundColor White 