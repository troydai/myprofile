$root = $env:USERPROFILE + "\SkyDrive"

if (Test-Path $root) {
    # Sublime Text 
    set-alias -name subl -value "$root\Software\Sublime_Text\sublime_text.exe"

    # GIT
    # set-alias -name git -value "$root\Software\Git\Cmd\git.exe"

    # Add SSH to path
    $env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"

    # Set up prompt
    . "$root\Development\posh-git\profile.example.ps1"

    # Set up TF
    if (Test-Path $env:VS120COMNTOOLS) {
        set-alias -name tf -value "$env:VS120COMNTOOLS..\IDE\tf.exe"
    }
    elseif (Test-Path $env:VS110COMNTOOLS) {
        set-alias -name tf -value "$env:VS110COMNTOOLS..\IDE\tf.exe"
    }

    # Set up TFPT
    if (($env:TFSPowerToolDir -ne $null) -and (Test-Path $env:TFSPowerToolDir)) {
        set-alias -name tfpt -value "${env:TFSPowerToolDir}TFPT.EXE"
    }
}