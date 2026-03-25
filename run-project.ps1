$ErrorActionPreference = 'Stop'

$root = 'd:\College'
$node = Join-Path $root 'tools\node\node-v18.10.0-win-x64\node.exe'
$backendDir = Join-Path $root 'backend'
$frontendDir = Join-Path $root 'frontend'

if (!(Test-Path $node)) {
  throw "Node runtime not found: $node"
}

$backendOut = Join-Path $backendDir 'backend-out.log'
$backendErr = Join-Path $backendDir 'backend-err.log'
$frontendOut = Join-Path $frontendDir 'frontend-out.log'
$frontendErr = Join-Path $frontendDir 'frontend-err.log'

Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
  Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

foreach ($f in @($backendOut, $backendErr, $frontendOut, $frontendErr)) {
  if (Test-Path $f) { Remove-Item $f -Force }
}

Start-Process -FilePath $node -ArgumentList 'server.js' -WorkingDirectory $backendDir -RedirectStandardOutput $backendOut -RedirectStandardError $backendErr -WindowStyle Hidden | Out-Null
Start-Process -FilePath $node -ArgumentList '.\node_modules\vite\bin\vite.js --host 127.0.0.1 --port 5173' -WorkingDirectory $frontendDir -RedirectStandardOutput $frontendOut -RedirectStandardError $frontendErr -WindowStyle Hidden | Out-Null

Start-Sleep -Seconds 4

Write-Host 'Backend:  http://127.0.0.1:5000'
Write-Host 'Frontend: http://127.0.0.1:5173'
Write-Host ''
Write-Host 'Backend logs:'
if (Test-Path $backendOut) { Get-Content $backendOut -Tail 20 }
if (Test-Path $backendErr) { Get-Content $backendErr -Tail 20 }
