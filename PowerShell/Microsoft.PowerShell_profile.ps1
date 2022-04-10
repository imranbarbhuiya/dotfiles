# $functionsDirectory = "$PSScriptRoot\functions";
# $completionsDirectory = "$PSScriptRoot\completions";

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

# # Load all custom functions
# . $functionsDirectory\Git-Functions.ps1
# . $functionsDirectory\GitHub-Cli-Functions.ps1
# . $functionsDirectory\NodeJS-Functions.ps1
# . $functionsDirectory\Terminal-Functions.ps1
# . $functionsDirectory\Video-Functions.ps1
# . $functionsDirectory\ScreenResolution.ps1

# # Load all custom completions
# & "$completionsDirectory\Gh-Completions.ps1"
