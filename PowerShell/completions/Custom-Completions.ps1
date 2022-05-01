Register-ArgumentCompleter -CommandName Set-SkyraProject-Location -ParameterName Repo -ScriptBlock {
	Get-ChildItem F:\dev\skyraproject -Name -Directory
}

Register-ArgumentCompleter -CommandName Set-SapphireDev-Location -ParameterName Repo -ScriptBlock {
	Get-ChildItem F:\dev\sapphiredev -Name -Directory
}

Register-ArgumentCompleter -CommandName Set-Favware-Location -ParameterName Repo -ScriptBlock {
	Get-ChildItem F:\dev\favware -Name -Directory
}

Register-ArgumentCompleter -CommandName Set-Wlis-Location -ParameterName Repo -ScriptBlock {
	Write-Output @('main', 'wlis', 'secondary', 'tertiary', 'quaterniary')
}

Register-ArgumentCompleter -CommandName Run-Script -ParameterName Script -ScriptBlock {
	Write-Output @('build', 'package', 'wars', 'jboss', 'logs', 'clearlogs', 'console')
}

Register-ArgumentCompleter -CommandName Build-Trigger -ParameterName Flags -ScriptBlock {
	Write-Output @('all-tests', 'all', 'docu', 'it', 'order', 'ormas', 'plan', 'spoor', 'testcafe', 'vs')
}

