# Kubernetes Setup Verification Script
# This script verifies that your local Kubernetes environment is ready

Write-Host "🔍 Verifying Kubernetes Setup..." -ForegroundColor Blue

$allGood = $true

# Check 1: kubectl availability
Write-Host "`n1️⃣ Checking kubectl availability..." -ForegroundColor Yellow
try {
    $kubectlVersion = kubectl version --client
    Write-Host "   ✅ kubectl is available" -ForegroundColor Green
} catch {
    Write-Host "   ❌ kubectl not found" -ForegroundColor Red
    Write-Host "   💡 Install kubectl from: https://kubernetes.io/docs/tasks/tools/" -ForegroundColor Cyan
    $allGood = $false
}

# Check 2: Kubernetes cluster accessibility
Write-Host "`n2️⃣ Checking Kubernetes cluster..." -ForegroundColor Yellow
try {
    $clusterInfo = kubectl cluster-info
    Write-Host "   ✅ Kubernetes cluster is accessible" -ForegroundColor Green
    Write-Host "   📍 $clusterInfo" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ Kubernetes cluster not accessible" -ForegroundColor Red
    Write-Host "   💡 Start Docker Desktop and enable Kubernetes" -ForegroundColor Cyan
    $allGood = $false
}

# Check 3: Node availability
Write-Host "`n3️⃣ Checking cluster nodes..." -ForegroundColor Yellow
try {
    $nodes = kubectl get nodes
    if ($nodes) {
        Write-Host "   ✅ Cluster has nodes available" -ForegroundColor Green
        Write-Host "   📊 Node count: $($nodes.Count - 1)" -ForegroundColor Gray
    } else {
        Write-Host "   ❌ No nodes found" -ForegroundColor Red
        $allGood = $false
    }
} catch {
    Write-Host "   ❌ Cannot retrieve node information" -ForegroundColor Red
    $allGood = $false
}

# Check 4: Namespace creation capability
Write-Host "`n4️⃣ Checking namespace creation capability..." -ForegroundColor Yellow
try {
    $testNamespace = "kubetest-verify-$(Get-Random)"
    kubectl create namespace $testNamespace
    kubectl delete namespace $testNamespace
    Write-Host "   ✅ Can create and delete namespaces" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Cannot create/delete namespaces" -ForegroundColor Red
    $allGood = $false
}

# Check 5: Resource deployment capability
Write-Host "`n5️⃣ Checking resource deployment capability..." -ForegroundColor Yellow
try {
    $testPod = @"
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: test
    image: busybox
    command: ['sh', '-c', 'echo "Hello from test pod" && sleep 10']
"@
    
    $testPod | kubectl apply -f -
    Start-Sleep -Seconds 2
    
    $podStatus = kubectl get pod test-pod -o jsonpath='{.status.phase}'
    if ($podStatus -eq "Running" -or $podStatus -eq "Succeeded") {
        Write-Host "   ✅ Can deploy and run pods" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Pod deployment test inconclusive" -ForegroundColor Yellow
    }
    
    kubectl delete pod test-pod
} catch {
    Write-Host "   ❌ Cannot deploy test resources" -ForegroundColor Red
    $allGood = $false
}

# Summary
Write-Host "`n📋 Setup Verification Summary:" -ForegroundColor Blue
if ($allGood) {
    Write-Host "🎉 Your Kubernetes environment is ready!" -ForegroundColor Green
    Write-Host "`n🚀 Next steps:" -ForegroundColor Cyan
    Write-Host "1. Deploy the learning environment: .\scripts\deploy.ps1" -ForegroundColor White
    Write-Host "2. Follow the learning guide: LEARNING_GUIDE.md" -ForegroundColor White
    Write-Host "3. Start experimenting with kubectl commands" -ForegroundColor White
} else {
    Write-Host "⚠️  Some issues were found. Please resolve them before proceeding." -ForegroundColor Yellow
    Write-Host "`n💡 Common solutions:" -ForegroundColor Cyan
    Write-Host "1. Install Docker Desktop and enable Kubernetes" -ForegroundColor White
    Write-Host "2. Install kubectl command-line tool" -ForegroundColor White
    Write-Host "3. Ensure Docker Desktop is running" -ForegroundColor White
    Write-Host "4. Check Windows Defender/firewall settings" -ForegroundColor White
}

Write-Host "`n🔗 Useful resources:" -ForegroundColor Cyan
Write-Host "- Docker Desktop: https://www.docker.com/products/docker-desktop" -ForegroundColor White
Write-Host "- kubectl installation: https://kubernetes.io/docs/tasks/tools/" -ForegroundColor White
Write-Host "- Kubernetes concepts: https://kubernetes.io/docs/concepts/" -ForegroundColor White 