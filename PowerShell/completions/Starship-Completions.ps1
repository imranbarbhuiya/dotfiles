
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'starship' -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)

	$commandElements = $commandAst.CommandElements
	$command = @(
		'starship'
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
		'starship' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('init', 'init', [CompletionResultType]::ParameterValue, 'Prints the shell function used to execute starship')
			[CompletionResult]::new('prompt', 'prompt', [CompletionResultType]::ParameterValue, 'Prints the full starship prompt')
			[CompletionResult]::new('module', 'module', [CompletionResultType]::ParameterValue, 'Prints a specific prompt module')
			[CompletionResult]::new('config', 'config', [CompletionResultType]::ParameterValue, 'Edit the starship configuration')
			[CompletionResult]::new('print-config', 'print-config', [CompletionResultType]::ParameterValue, 'Prints the computed starship configuration')
			[CompletionResult]::new('toggle', 'toggle', [CompletionResultType]::ParameterValue, 'Toggle a given starship module')
			[CompletionResult]::new('bug-report', 'bug-report', [CompletionResultType]::ParameterValue, 'Create a pre-populated GitHub issue with information about your configuration')
			[CompletionResult]::new('time', 'time', [CompletionResultType]::ParameterValue, 'Prints time in milliseconds')
			[CompletionResult]::new('explain', 'explain', [CompletionResultType]::ParameterValue, 'Explains the currently showing modules')
			[CompletionResult]::new('timings', 'timings', [CompletionResultType]::ParameterValue, 'Prints timings of all active modules')
			[CompletionResult]::new('completions', 'completions', [CompletionResultType]::ParameterValue, 'Generate starship shell completions for your shell to stdout')
			[CompletionResult]::new('session', 'session', [CompletionResultType]::ParameterValue, 'Generate random session key')
			[CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Prints this message or the help of the given subcommand(s)')
			break
		}
		'starship;init' {
			[CompletionResult]::new('--print-full-init', 'print-full-init', [CompletionResultType]::ParameterName, 'Print the main initialization script (as opposed to the init stub)')
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;prompt' {
			[CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'The status code of the previously run command')
			[CompletionResult]::new('--status', 'status', [CompletionResultType]::ParameterName, 'The status code of the previously run command')
			[CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'The path that the prompt should render for.')
			[CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'The path that the prompt should render for.')
			[CompletionResult]::new('-P', 'P', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument.')
			[CompletionResult]::new('--logical-path', 'logical-path', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument.')
			[CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
			[CompletionResult]::new('--cmd-duration', 'cmd-duration', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
			[CompletionResult]::new('-k', 'k', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh')
			[CompletionResult]::new('--keymap', 'keymap', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh')
			[CompletionResult]::new('-j', 'j', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
			[CompletionResult]::new('--jobs', 'jobs', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;module' {
			[CompletionResult]::new('-s', 's', [CompletionResultType]::ParameterName, 'The status code of the previously run command')
			[CompletionResult]::new('--status', 'status', [CompletionResultType]::ParameterName, 'The status code of the previously run command')
			[CompletionResult]::new('-p', 'p', [CompletionResultType]::ParameterName, 'The path that the prompt should render for.')
			[CompletionResult]::new('--path', 'path', [CompletionResultType]::ParameterName, 'The path that the prompt should render for.')
			[CompletionResult]::new('-P', 'P', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument.')
			[CompletionResult]::new('--logical-path', 'logical-path', [CompletionResultType]::ParameterName, 'The logical path that the prompt should render for. This path should be a virtual/logical representation of the PATH argument.')
			[CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
			[CompletionResult]::new('--cmd-duration', 'cmd-duration', [CompletionResultType]::ParameterName, 'The execution duration of the last command, in milliseconds')
			[CompletionResult]::new('-k', 'k', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh')
			[CompletionResult]::new('--keymap', 'keymap', [CompletionResultType]::ParameterName, 'The keymap of fish/zsh')
			[CompletionResult]::new('-j', 'j', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
			[CompletionResult]::new('--jobs', 'jobs', [CompletionResultType]::ParameterName, 'The number of currently running jobs')
			[CompletionResult]::new('-l', 'l', [CompletionResultType]::ParameterName, 'List out all supported modules')
			[CompletionResult]::new('--list', 'list', [CompletionResultType]::ParameterName, 'List out all supported modules')
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;config' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;print-config' {
			[CompletionResult]::new('-d', 'd', [CompletionResultType]::ParameterName, 'Print the default instead of the computed config')
			[CompletionResult]::new('--default', 'default', [CompletionResultType]::ParameterName, 'Print the default instead of the computed config')
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;toggle' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;bug-report' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;time' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;explain' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;timings' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;completions' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;session' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
		'starship;help' {
			[CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Prints help information')
			[CompletionResult]::new('-V', 'V', [CompletionResultType]::ParameterName, 'Prints version information')
			[CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Prints version information')
			break
		}
	})

	$completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
		Sort-Object -Property ListItemText
}
