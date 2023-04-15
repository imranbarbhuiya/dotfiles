$functionsDirectory = "$PSScriptRoot\functions";
$completionsDirectory = "$PSScriptRoot\completions";
$aliasesDirectory = "$PSScriptRoot\aliases";

Import-Module -Name posh-git
Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine

$PSReadLineOptions = @{
    PredictionSource = 'History'
    Colors           = @{ 
        'Command' = '#8181f7'
        'Comment' = 'DarkGray'
    }
}

Set-PSReadLineOption @PSReadLineOptions
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Load all custom functions
. $functionsDirectory\Git-Functions.ps1
. $functionsDirectory\GitHub-Cli-Functions.ps1
. $functionsDirectory\NodeJS-Functions.ps1
. $functionsDirectory\Terminal-Functions.ps1
. $functionsDirectory\Video-Functions.ps1
. $functionsDirectory\ScreenResolution.ps1

# Load all custom completions
& "$completionsDirectory\Starship-Completions.ps1"
& "$completionsDirectory\Gh-Completions.ps1"
& "$completionsDirectory\Custom-Completions.ps1"
& "$completionsDirectory\Volta-Completions.ps1"


# Load all custom aliases
. $aliasesDirectory\Custom-Aliases.ps1

$Env:STARSHIP_CONFIG = "$PSScriptRoot\starship.toml"
Invoke-Expression (&starship init powershell)

# github copilot cli
Function copilot_check-response {
  if ( $Args[0] -eq $true ) {
    $FIXED_CMD = Get-Content $TMPFILE
    Remove-Item $TMPFILE -ErrorAction SilentlyContinue
    Invoke-Expression $FIXED_CMD
  }
  else {
    Write-Host "User cancelled the command."
    Remove-Item $TMPFILE -ErrorAction SilentlyContinue
  }
}

Function copilot_what-the-shell {
  $TMPFILE = New-TemporaryFile
  trap {Remove-Item $TMPFILE -ErrorAction SilentlyContinue}
  github-copilot-cli what-the-shell "$args" --shellout $TMPFILE
  copilot_check-response $?
}
Set-Alias ?? copilot_what-the-shell

Function copilot_git-assist {
  $TMPFILE = New-TemporaryFile
  trap {Remove-Item $TMPFILE -ErrorAction SilentlyContinue}
  github-copilot-cli git-assist "$args" --shellout $TMPFILE
  copilot_check-response $?
}
Set-Alias git? copilot_git-assist

Function copilot_gh-assist {
  $TMPFILE = New-TemporaryFile
  trap {Remove-Item $TMPFILE -ErrorAction SilentlyContinue}
  github-copilot-cli gh-assist "$args" --shellout $TMPFILE
  copilot_check-response $?
}
Set-Alias gh? copilot_gh-assist