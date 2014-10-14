Write-Host "Welcome, Troy!"

# Add SSH to path
$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"

# Posh-Git
$myGit = $env:USERPROFILE + "\git"
if (Test-Path "$myGit\posh-git\profile.example.ps1")
{
    . $myGit\posh-git\profile.example.ps1
}

# Sublime Text 2
$sublimeTextExec = $env:ProgramFiles + "\Sublime Text 2\sublime_text.exe"
set-alias subl $sublimeTextExec
