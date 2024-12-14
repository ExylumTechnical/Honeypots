# Define variables
$HoneyPort = 8080  # Port to monitor (change as needed)
$LogFile = "C:\Logs\HoneyPortLog.txt"  # Path to log file
$StopKey = 'q'  # Key to press to stop the script

# Check if the script is running with elevated privileges
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.SecurityIdentifier]::new("S-1-5-32-544"))) {
    Write-Warning "This script requires administrator privileges. Please run as administrator."
    exit # Terminate the script
}

# Ensure log file directory exists
if (!(Test-Path -Path (Split-Path $LogFile))) {
    New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force
}

# Function to log IP addresses
function Log-Connection {
    param (
        [string]$IPAddress
    )
    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $LogEntry = "$Timestamp - Unauthorized connection from IP: $IPAddress"
    Add-Content -Path $LogFile -Value $LogEntry
    Write-Host $LogEntry
}

# Create a listener for the honeyport
Write-Host "Starting Honeyport on port $HoneyPort. Press ctrl+c to stop the script."
$Listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $HoneyPort)
$Listener.Start()

# Start a background task to monitor for keypress
$StopSignal = $false
$KeyPressListener = Start-Job -ScriptBlock {
    param ($StopKey)
    while ($true) {
        $Key = [console]::ReadKey($true).KeyChar
        if ($Key -eq $StopKey) {
            return $true
        }
    }
} -ArgumentList $StopKey

# Monitor connections until stop signal is received
try {
    while (-not $StopSignal) {
        if ($KeyPressListener.HasExited) {
            $StopSignal = $KeyPressListener | Receive-Job
            break
        }
        if ($Listener.Pending()) {
            $Client = $Listener.AcceptTcpClient()
            $IPAddress = $Client.Client.RemoteEndPoint.Address.ToString()
            Write-Host "Unauthorized connection detected from $IPAddress BLOCKED"
			New-NetFirewallRule -Name "Honeyport Blocked IP" -DisplayName "Honeyport Blocked IP" -Direction Inbound -Action Block -RemoteAddress $IPAddress
            Log-Connection -IPAddress $IPAddress
            $Client.Close()
        }
        Start-Sleep -Milliseconds 100
    }
} catch {
    Write-Error "An error occurred: $_"
} finally {
    # Clean up
    $Listener.Stop()
    Remove-Job -Job $KeyPressListener -Force
    Write-Host "Honeyport stopped."
}
