Write-Host "Welcome, Troy!"

# Sublime text
$myGit = $env:USERPROFILE + "\git"
if (Test-Path "$myGit\posh-git\profile.example.ps1")
{
    . $myGit\posh-git\profile.example.ps1
}

# Add SSH to path
$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"

# Program files
$sublimeTextExec = $env:ProgramFiles + "\Sublime Text 2\sublime_text.exe"
set-alias subl $sublimeTextExec
