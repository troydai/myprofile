Write-Host "Welcome, Troy!"

$dp0 = Split-Path $MyInvocation.MyCommand.Path

# Sublime
$sublimeTextExec = $env:ProgramFiles + "\Sublime Text 3\sublime_text.exe"
if (-not (Test-Path $sublimeTextExec))
{
    $sublimeTextExec = $env:ProgramFiles + "\Sublime Text 2\sublime_text.exe"
}

set-alias subl $sublimeTextExec

# Add SSH to path
$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"

# Posh-Git

# Load posh-git module from current directory
Import-Module $dp0\posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus

    if (Get-Command dnvm -ErrorAction SilentlyContinue) {
        $activeDnx = dnvm list -passthru | where { $_.Active }
        if ($activeDnx) {
            Write-Host " (" -nonewline -foregroundColor ([ConsoleColor]::Yellow)
            Write-Host "dnx-$($activeDnx.Runtime)-win-$($activeDnx.Architecture).$($activeDnx.Version)" -nonewline -foregroundColor ([ConsoleColor]::Cyan)
            Write-Host ")" -nonewline -ForegroundColor ([ConsoleColor]::Yellow)
        }
    }

    $global:LASTEXITCODE = $realLASTEXITCODE

    Write-Host ""
    return "$ "
}

Enable-GitColors

Start-SshAgent -Quiet
