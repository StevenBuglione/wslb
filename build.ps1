# Logging functions
function Write-Log {
    param(
        [string]$Level,
        [string]$Message
    )

    switch ($Level) {
        "info"    { Write-Host $Message -ForegroundColor Blue }
        "step"    { Write-Host ">> $Message" -ForegroundColor Yellow }
        "success" { Write-Host $Message -ForegroundColor Green }
        "error"   { Write-Host $Message -ForegroundColor Red }
        "result"  { Write-Host $Message -ForegroundColor Cyan }
        default   { Write-Host $Message }
    }
}

# Check if parameter is provided
if (-not $args[0]) {
    Write-Log "error" "Please provide a distro name as parameter"
    exit 1
}

$distro = $args[0]

# Check if dos2unix is installed
if (-not (Get-Command "dos2unix" -ErrorAction SilentlyContinue)) {
    Write-Log "error" "dos2unix is not installed. Please install it first."
    exit 1
}

Write-Log "info" "===== Starting build for ${distro} WSL distro ====="

# Convert line endings for text files
Write-Log "step" "Converting line endings in distro/${distro}..."
Get-ChildItem -Path "distro/${distro}" -File | Where-Object {
    $_.Extension -in @(".sh", ".txt", "", ".conf", ".yml", ".yaml", ".json", ".Dockerfile")
} | ForEach-Object {
    Write-Log "info" "Converting: $($_.FullName)"
    & dos2unix $_.FullName
}

Write-Log "step" "Building Docker image..."
Set-Location -Path "distro/${distro}"
docker build -t "${distro}-wsl" .

Write-Log "step" "Creating output directory..."
New-Item -Path "../../bin/${distro}" -ItemType Directory -Force | Out-Null

Write-Log "step" "Running container to prepare filesystem..."
docker run -t --name "${distro}-wsl" "${distro}-wsl"

Write-Log "step" "Exporting container to tarball..."
docker export "${distro}-wsl" | tar --delete --wildcards "etc/resolv.conf" > "../../bin/${distro}/${distro}-wsl.tar"

Write-Log "step" "Cleaning up container..."
docker rm "${distro}-wsl"

Write-Log "step" "Finalizing WSL image..."
Move-Item -Path "../../bin/${distro}/${distro}-wsl.tar" -Destination "../../bin/${distro}/${distro}.wsl" -Force

Set-Location -Path "../.."

Write-Log "success" "===== ${distro} WSL distro build completed successfully ====="
Write-Log "result" "Output file: bin/${distro}/${distro}.wsl"