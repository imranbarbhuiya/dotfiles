
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'volta' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'volta'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-')) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'volta' {
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            [CompletionResult]::new('-v', 'v', [CompletionResultType]::ParameterName, 'Prints the current version of Volta')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints the current version of Volta')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('fetch', 'fetch', [CompletionResultType]::ParameterValue, 'Fetches a tool to the local machine')
            [CompletionResult]::new('install', 'install', [CompletionResultType]::ParameterValue, 'Installs a tool in your toolchain')
            [CompletionResult]::new('uninstall', 'uninstall', [CompletionResultType]::ParameterValue, 'Uninstalls a tool from your toolchain')
            [CompletionResult]::new('pin', 'pin', [CompletionResultType]::ParameterValue, 'Pins your project''s runtime or package manager')
            [CompletionResult]::new('list', 'list', [CompletionResultType]::ParameterValue, 'Displays the current toolchain')
            [CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generates Volta completions')
            [CompletionResult]::new('which', 'which', [CompletionResultType]::ParameterValue, 'Locates the actual binary that will be called by Volta')
            [CompletionResult]::new('use', 'use', [CompletionResultType]::ParameterValue, 'use')
            [CompletionResult]::new('setup', 'setup', [CompletionResultType]::ParameterValue, 'Enables Volta for the current user / shell')
            [CompletionResult]::new('run', 'run', [CompletionResultType]::ParameterValue, 'Run a command with custom Node, npm, and/or Yarn versions')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
            break
        }
        'volta;fetch' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;install' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;uninstall' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;pin' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;list' {
            [CompletionResult]::new('--format', 'format', [CompletionResultType]::ParameterName, 'Specify the output format')
            [CompletionResult]::new('-c', 'c', [CompletionResultType]::ParameterName, 'Show the currently-active tool(s)')
            [CompletionResult]::new('--current', 'current', [CompletionResultType]::ParameterName, 'Show the currently-active tool(s)')
            [CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Show your default tool(s).')
            [CompletionResult]::new('--default', 'default', [CompletionResultType]::ParameterName, 'Show your default tool(s).')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;completions' {
            [CompletionResult]::new('-o', 'o', [CompletionResultType]::ParameterName, 'File to write generated completions to')
            [CompletionResult]::new('--output', 'output', [CompletionResultType]::ParameterName, 'File to write generated completions to')
            [CompletionResult]::new('-f', 'f', [CompletionResultType]::ParameterName, 'Write over an existing file, if any.')
            [CompletionResult]::new('--force', 'force', [CompletionResultType]::ParameterName, 'Write over an existing file, if any.')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;which' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;use' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;setup' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;run' {
            [CompletionResult]::new('--node', 'node', [CompletionResultType]::ParameterName, 'Set the custom Node version')
            [CompletionResult]::new('--npm', 'npm', [CompletionResultType]::ParameterName, 'Set the custom npm version')
            [CompletionResult]::new('--yarn', 'yarn', [CompletionResultType]::ParameterName, 'Set the custom Yarn version')
            [CompletionResult]::new('--env', 'env', [CompletionResultType]::ParameterName, 'Set an environment variable (can be used multiple times)')
            [CompletionResult]::new('--bundled-npm', 'bundled-npm', [CompletionResultType]::ParameterName, 'Forces npm to be the version bundled with Node')
            [CompletionResult]::new('--no-yarn', 'no-yarn', [CompletionResultType]::ParameterName, 'Disables Yarn')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
        'volta;help' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
            [CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
            [CompletionResult]::new('--verbose', 'verbose', [CompletionResultType]::ParameterName, 'Enables verbose diagnostics')
            [CompletionResult]::new('--quiet', 'quiet', [CompletionResultType]::ParameterName, 'Prevents unnecessary output')
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
