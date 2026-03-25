$ErrorActionPreference = 'SilentlyContinue'

Get-Process node -ErrorAction SilentlyContinue | ForEach-Object {
  Stop-Process -Id $_.Id -Force
}

Write-Host 'Stopped backend and frontend node processes.'
