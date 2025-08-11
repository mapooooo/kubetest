param(
  [string]$Tag = "dev"
)
Write-Host "🐳 Building backend image..." -ForegroundColor Yellow
docker build -t kubetest-backend:$Tag -f docker/backend/Dockerfile apps/backend
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "✅ Backend build complete." -ForegroundColor Green

Write-Host "🐳 Building worker image..." -ForegroundColor Yellow
docker build -t kubetest-worker:$Tag -f docker/worker/Dockerfile apps/worker
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "✅ Worker build complete." -ForegroundColor Green