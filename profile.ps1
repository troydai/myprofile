$dp0 = Split-Path $MyInvocation.MyCommand.Path
$modules = "$dp0\modules"

# Add SSH to path
$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"

# DOTNET_HOME
$env:DOTNET_HOME="$env:LocalAppData\Microsoft\dotnet\cli"
if (Test-Path $env:DOTNET_HOME)
{
    $env:PATH += ";$env:DOTNET_HOME\bin"
}

# 1. Set up text editor
if (Test-Path "$env:ProgramFiles\Sublime Text 3\subl.exe")
{
    set-alias subl "$env:ProgramFiles\Sublime Text 3\subl.exe"
}

# 2. Set up Python

# Location assistents
function home {
    cd $dp0
    cd ..\
}

function go-profile {
    cd $dp0
}

function edit-profile {
    vim $dp0\profile.ps1
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
        $env:DNX_FEED = "https://www.myget.org/F/aspnetcidev/api/v2"
    }
    elseif ($feedname -eq "volatile") {
        $env:DNX_FEED = "https://www.myget.org/F/aspnetvolatiledev/api/v2"
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
    else {
        Write-Host "Customize $feedname"
        $env:DNX_FEED = "https://www.myget.org/F/$feedname/api/v2"
    }

    Write-Host "Current DNX_FEED is $env:DNX_FEED"
}

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

# Posh-Git
# ===============================================
# Load posh-git module from current directory
Import-Module $modules\posh-git

function IsProjectFolder ([string] $path) {
    if (Test-Path "$path\project.json") {
        return $True
    }
    
    if (Test-Path "$path\global.json") {
        return $True
    }
    
    return $False
}

function Write-DnxStatue {
    $currentPath = $pwd
    while (-not (IsProjectFolder($currentPath))) {
        $parent = [System.IO.Path]::GetDirectoryName($currentPath)
        if ($parent -eq $Null) {
            return
        }
        
        $currentPath = $parent
    }
    
    if (Test-Path "$env:DOTNET_HOME\.version")
    {
        $dotnet_version = gc "$env:DOTNET_HOME\.version" | select -skip 1
        Write-Host " [" -nonewline -foregroundColor ([ConsoleColor]::Yellow)
        Write-Host "$dotnet_version" -nonewline -foregroundColor ([ConsoleColor]::Cyan)
        Write-Host "]" -nonewline -ForegroundColor ([ConsoleColor]::Yellow)
    }
}

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $start = [System.DateTime]::Now
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus
	Write-DnxStatue

    $global:LASTEXITCODE = $realLASTEXITCODE

	$end = [System.DateTime]::Now
	$time = ($end-$start).TotalMilliseconds

	if ($time -gt 200)
	{
		Write-Host " [" -nonewline -foregroundColor ([ConsoleColor]::Yellow)
		Write-Host "latency $time ms" -NoNewline -foregroundColor([ConsoleColor]::Cyan)
		Write-Host "]" -NoNewline -ForegroundColor ([ConsoleColor]::Yellow)
	}

	Write-Host ""
    return "$ "
}

# Start-SshAgent -Quiet
