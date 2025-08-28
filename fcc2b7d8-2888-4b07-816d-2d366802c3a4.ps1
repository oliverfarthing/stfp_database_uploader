# Define directories and files
$directory      = "E:\ImportData\UnitySentinel-Update"
$logFolder      = Join-Path $directory "log"
$downloadFolder = Join-Path $directory "download"
$extractFolder  = Join-Path $directory "extract"
$winscpPath     = Join-Path $directory "winscp\WinSCP.com"
$scriptFile     = Join-Path $directory "get_file.txt"
$sqb2mtfExe     = Join-Path $directory "sqb2mtf.exe"
$sqlRestorePath = Join-Path $directory "restore_database.sql"
$sqlSecurityPath = Join-Path $directory "security_database.sql"
$sevenZipPath   = Join-Path $directory "7-zip\7z.exe"

# Create log folder if missing
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory | Out-Null
}

# Clear and recreate download & extract folders
@("download", "extract") | ForEach-Object {
    $folderPath = Join-Path $directory $_

    if (Test-Path $folderPath) {
        Remove-Item -Path $folderPath -Recurse -Force
    }

    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# Timestamp for logs
$timestamp       = Get-Date -Format "yyyyMMdd_HHmmss"
$winScpLogPath   = Join-Path $logFolder "winscplog_$timestamp.txt"
$scriptLogPath   = Join-Path $logFolder "scriptlog_$timestamp.txt"

# Function to write to script log and console
function Write-ScriptLog {
    param ([string]$Message)
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMsg = "[$time] $Message"
    Add-Content -Path $scriptLogPath -Value $logMsg
    Write-Host $logMsg
}

Write-ScriptLog "Script started."

try {
    # Check sqb2mtf.exe existence
    if (-not (Test-Path $sqb2mtfExe)) {
        Write-ScriptLog "ERROR: sqb2mtf.exe not found at $sqb2mtfExe"
        throw "sqb2mtf.exe missing"
    }

    # Encode PPK path
    $ppkPath = Join-Path $directory "UnityPrivateKey3.ppk"
    if (-not (Test-Path $ppkPath)) {
        Write-ScriptLog "ERROR: PPK file not found at $ppkPath"
        throw "PPK file missing"
    }
    $encodedPpkPath = [uri]::EscapeDataString($ppkPath)

    # Create WinSCP script content (no leading spaces!)
    $scriptContent = @"
open sftp://unity:Hee5Boh7apae3esee8ah;x-publickeyfile=$encodedPpkPath@fileshare.anchor.co.uk/ -hostkey=acceptnew
option transfer binary
option confirm off
get -latest *.7z "$downloadFolder\*.7z"
close
exit
"@

    Write-ScriptLog "Writing WinSCP script to $scriptFile"
    Set-Content -Path $scriptFile -Value $scriptContent -Encoding ASCII

    Write-ScriptLog "Starting WinSCP with command: $winscpPath /script=$scriptFile /log=$winScpLogPath"
    $proc = Start-Process -FilePath $winscpPath `
        -ArgumentList "/script=$scriptFile", "/log=$winScpLogPath" `
        -Wait -NoNewWindow -PassThru

    if ($proc.ExitCode -ne 0) {
        throw "WinSCP exited with code $($proc.ExitCode)"
    }

    # Identify downloaded zip file
    $archive = Get-ChildItem -Path $downloadFolder -Filter *.7z | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $archive) {
        throw "No .7z archive found in $downloadFolder"
    }
    $archivePath = $archive.FullName

    # Extract files preserving folder structure
    Write-ScriptLog "Extracting FULL_* files from $archivePath to $extractFolder"
    & $sevenZipPath x $archivePath "backup\FULL_*" "-o$extractFolder" -y

    if ($LASTEXITCODE -ne 0) {
        throw "7-Zip extraction failed with code $LASTEXITCODE"
    }
    Write-ScriptLog "7z extraction of FULL_* files completed successfully."

    # Move extracted FULL_* files from backup\ to $downloadFolder root
    $backupSubfolder = Join-Path $extractFolder "backup"
    if (Test-Path $backupSubfolder) {
        Get-ChildItem -Path $backupSubfolder -Filter "FULL_*" -File | ForEach-Object {
            $dest = Join-Path $downloadFolder $_.Name
            Move-Item -Path $_.FullName -Destination $dest -Force
        }
        # Remove the now-empty backup folder
        Remove-Item -Path $backupSubfolder -Recurse -Force
    }

    # Run sqb2mtf.exe on all *.sqb files in download folder
    Get-ChildItem -Path $downloadFolder -Recurse -Filter *.sqb | ForEach-Object {
        $filePath = $_.FullName
        $fileName = $_.Name
        $outputPath = Join-Path $extractFolder $fileName

        Write-ScriptLog "Processing $fileName with sqb2mtf.exe to $outputPath"
        & $sqb2mtfExe $filePath $outputPath "Hee5Boh7apae3esee8ah"
    }

    # Remove timestamps from file names in extract folder (excluding .exe files)
    Get-ChildItem -Path $extractFolder -Recurse -Exclude *.exe | ForEach-Object {
        $originalName = $_.Name
        $newName = $originalName -replace "([0-9]{8}[_])([0-9]{6})", ""
        if ($newName -ne $originalName) {
            Write-ScriptLog "Renaming $originalName to $newName"
            Rename-Item -Path $_.FullName -NewName $newName
        }
    }

    # Rename all *.sqb to *.bak in extract folder
    Get-ChildItem -Path $extractFolder -Recurse -Filter *.sqb | ForEach-Object {
        $originalName = $_.Name
        $newName = $originalName -replace "\.sqb$", ".bak"
        Write-ScriptLog "Renaming $originalName to $newName"
        Rename-Item -Path $_.FullName -NewName $newName
    }

    # SQL Server info
    $server = "localhost"
    $database = "master"

    # Run first SQL script with variable
    try {
        Write-ScriptLog "Running restore_database.sql"
        Invoke-Sqlcmd -ServerInstance $server `
                      -Database $database `
                      -InputFile $sqlRestorePath `
                      -Variable @{ BackupPath = $extractFolder } `
                      -TrustServerCertificate
        Write-ScriptLog "restore_database.sql completed successfully."
    } catch {
        Write-ScriptLog "ERROR executing restore_database.sql: $($_.Exception.Message)"
    }

    # Run second SQL script without variables
    try {
        Write-ScriptLog "Running security_database.sql"
        Invoke-Sqlcmd -ServerInstance $server `
                      -Database $database `
                      -InputFile $sqlSecurityPath `
                      -TrustServerCertificate
        Write-ScriptLog "security_database.sql completed successfully."
    } catch {
        Write-ScriptLog "ERROR executing security_database.sql: $($_.Exception.Message)"
    }

} catch {
    Write-ScriptLog "ERROR: $($_.Exception.Message)"
    Write-ScriptLog "StackTrace: $($_.Exception.StackTrace)"
} finally {
    Write-ScriptLog "Script finished."
}
