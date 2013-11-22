$root = $env:USERPROFILE + "\SkyDrive"

if (Test-Path $root) {
    # Sublime Text 
    set-alias -name subl -value "$root\Software\Sublime_Text\sublime_text.exe"

    # GIT
    set-alias -name git -value "$root\Software\Git\Cmd\git.exe"

    # Set up prompt
    . "$root\Development\posh-git\profile.example.ps1"
}
