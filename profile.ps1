Write-Host "Welcome, Troy!"

$dp0 = Split-Path $MyInvocation.MyCommand.Path
$modules = "$dp0\modules"

# Sublime
$sublimeTextExec = $env:ProgramFiles + "\Sublime Text 3\sublime_text.exe"
if (-not (Test-Path $sublimeTextExec))
{
    $sublimeTextExec = $env:ProgramFiles + "\Sublime Text 2\sublime_text.exe"
}

set-alias subl $sublimeTextExec

# Add SSH to path
$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"

# Add Python to Path
if (Test-Path "C:\Python34")
{
    $env:PATH += ";C:\Python34"
}

# Location assistents
function home {
    cd $dp0
    cd ..\
}

function go-profile {
    cd $dp0
}

# DNX Tools
function dnx-clean-packages {
    python $modules\k.toolkit\clean-packages.py
}

function dnx-clean-runtimes {
    python $modules\k.toolkit\clean-runtimes.py
}

function dnx-feed ([string] $feedname) {
    if ($feedname -eq "dev") {
        $env:DNX_FEED = "https://www.myget.org/F/aspnetvolatiln/api/v2"
    }
    elseif ($feedname -eq "volatile") {
        $env:DNX_FEED = "https://www.myget.org/F/aspnetvolatiln/api/v2"
    }
    elseif ($feedname -eq "release") {
        $env:DNX_FEED = "https://www.myget.org/F/aspnetrelease/api/v2"
    }
    elseif ($feedname -eq "vnext") {
        $env:DNX_FEED = "https://www.myget.org/F/aspnetvnext/api/v2"
    }
    elseif ($feedname -eq "nuget") {
        $env:DNX_FEED = "https://www.nuget.org/api/v2"
    }
    elseif ($feedname -eq "beta5") {
        $env:DNX_FEED = "https://www.myget.org/F/aspnetbeta5/api/v2"
    }
    else {
        Write-Host "Unknown option $feedname"
        Write-Host "Available options: dev, volatiln, relese, vnext and nuget"
    }
    Write-Host "Current DNX_FEED is $env:DNX_FEED"
}

# Posh-Git
# ===============================================
# Load posh-git module from current directory
Import-Module $modules\posh-git

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

Start-SshAgent -Quiet

# Conventient functions
function DNX-Trace {
    if (Test-Path env:DNX_TRACE)
    {
        if ($env:DNX_TRACE -eq '1')
        {
            $env:DNX_TRACE='0'
            Write-Host "DNX trace is turned off."
        }
        else
        {
            $env:DNX_TRACE='1'
            Write-Host "DNX trace is turned on."
        }
    }
    else
    {
        $env:DNX_TRACE='1'
        Write-Host "DNX trace is turned on."
    }
}
