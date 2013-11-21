$root = $env:USERPROFILE + "\SkyDrive"

if (Test-Path $root) {
    # Set up prompt
    . "$root\Development\posh-git\profile.example.ps1"

    # Sublime Text 
    set-alias -name subl -value "$root\Software\Sublime_Text\sublime_text.exe"
}

