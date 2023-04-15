Function copilot_check-response {
    if ( $Args[0] -eq $true ) {
        $FIXED_CMD = Get-Content $TMPFILE
        Remove-Item $TMPFILE -ErrorAction SilentlyContinue
        Invoke-Expression $FIXED_CMD
    }
    else {
        Write-Host 'User cancelled the command.'
        Remove-Item $TMPFILE -ErrorAction SilentlyContinue
    }
}

Function copilot_what-the-shell {
    $TMPFILE = New-TemporaryFile
    trap { Remove-Item $TMPFILE -ErrorAction SilentlyContinue }
    github-copilot-cli what-the-shell "$args in pwsh" --shellout $TMPFILE
    copilot_check-response $?
}

Function copilot_git-assist {
    $TMPFILE = New-TemporaryFile
    trap { Remove-Item $TMPFILE -ErrorAction SilentlyContinue }
    github-copilot-cli git-assist "$args" --shellout $TMPFILE
    copilot_check-response $?
}

Function copilot_gh-assist {
    $TMPFILE = New-TemporaryFile
    trap { Remove-Item $TMPFILE -ErrorAction SilentlyContinue }
    github-copilot-cli gh-assist "$args" --shellout $TMPFILE
    copilot_check-response $?
}

Set-Alias ?? copilot_what-the-shell
Set-Alias git? copilot_git-assist
Set-Alias gh? copilot_gh-assist