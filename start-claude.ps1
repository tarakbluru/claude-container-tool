# PowerShell script to start Claude container with current folder as project name
# Place this script in F:\BackUP\Dropbox\Projects\tarak\claude_container
# Run from any project directory

# Get the current directory (will be used as workspace)
$currentPath = Get-Location
$projectName = Split-Path $currentPath -Leaf

# Get the script directory (where docker-compose.yml is located)
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$dockerComposePath = Join-Path $scriptDir "docker-compose.yml"

# Set environment variable for current directory to override the volume mapping
$env:WORKSPACE_DIR = $currentPath

Write-Host "🚀 Starting Claude for project: $projectName" -ForegroundColor Green
Write-Host "📁 Workspace: $currentPath" -ForegroundColor Cyan
Write-Host "🐳 Using compose file: $dockerComposePath" -ForegroundColor Yellow

# Check if docker-compose.yml exists
if (-not (Test-Path $dockerComposePath)) {
    Write-Host "❌ Error: docker-compose.yml not found at $dockerComposePath" -ForegroundColor Red
    exit 1
}

# Check if container is already running
$runningContainers = podman ps --format "{{.Names}}" | Where-Object { $_ -like "*$projectName-claude-mcp*" }

if ($runningContainers) {
    Write-Host "✅ Container already running: $runningContainers" -ForegroundColor Green
    Write-Host "🔗 Connecting to existing container..." -ForegroundColor Cyan
} else {
    Write-Host "🔄 Starting new container..." -ForegroundColor Yellow
    
    # Start the container
    podman compose -p $projectName -f $dockerComposePath up -d
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to start container" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "✅ Container started successfully!" -ForegroundColor Green
}

# Execute bash in the container
Write-Host "🖥️  Opening bash prompt..." -ForegroundColor Cyan
Write-Host "📝 To exit, type 'exit' in the container" -ForegroundColor Gray
Write-Host "───────────────────────────────────────────" -ForegroundColor Gray

podman compose -p $projectName -f $dockerComposePath exec claude-mcp bash

# After exiting bash
Write-Host "───────────────────────────────────────────" -ForegroundColor Gray
Write-Host "👋 Exited Claude container" -ForegroundColor Yellow
Write-Host "💡 Container is still running in background" -ForegroundColor Gray
Write-Host "💡 To stop container, run:" -ForegroundColor Gray
Write-Host "   $scriptDir\stop-claude.ps1" -ForegroundColor Cyan