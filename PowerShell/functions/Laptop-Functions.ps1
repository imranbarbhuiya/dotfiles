Function Run-Script {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True)]
        [ValidateNotNull()]
        [string]
        $Script,

        [Parameter(Position = 1, Mandatory = $False, ValueFromRemainingArguments = $True)]
        [string[]]
        $Flags
    )

    Process {
        $scriptDirectory = 'C:\Users\j.claassens\Documents\workspace\scripts'

        switch -regex ($Script) {
            build {
                & $scriptDirectory\Build-Frontend.ps1 $Flags
            }
            package {
                & $scriptDirectory\Build-Backend.ps1 $Flags
            }
            wars {
                & $scriptDirectory\Deploy-Wars.ps1 $Flags
            }
            jboss {
                & $scriptDirectory\Start-Jboss.ps1 $Flags
            }
            '^(?:logs|clearlogs|clear-logs)' {
                & $scriptDirectory\Clear-Logs.ps1 $Flags
            }
            console {
                & $scriptDirectory\Start-Jboss-Console.ps1 $Flags
            }
            test {
                & $scriptDirectory\Test.ps1 $Flags
            }
            Default {
                Write-Host 'Unknown script parameter detected' -ForegroundColor Red
            }
        }
    }
}

Function Build-Trigger {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True, ValueFromRemainingArguments = $True)]
        [string[]]
        $Flags
    )

    Process {
        $BaseMessage = 'Trigger Build'

        $Flags | ForEach-Object {
            switch ($_) {
                'all-tests' { $BaseMessage += ' #RUN_ALL_TESTS' }
                'all' { $BaseMessage += ' #RUN_ALL' }
                'docu' { $BaseMessage += ' #DOCU' }
                'it' { $BaseMessage += ' #RUN_IT' }
                'order' { $BaseMessage += ' #RUN_GMS_ORMAS' }
                'ormas' { $BaseMessage += ' #RUN_ORMAS' }
                'plan' { $BaseMessage += ' #RUN_PLAN' }
                'spoor' { $BaseMessage += ' #RUN_SPOOR' }
                'testcafe' { $BaseMessage += ' #RUN_TESTCAFE' }
                'vs' { $BaseMessage += ' #RUN_VS' }
            }
        }

        git cie -m "$BaseMessage"
    }
}


Function Set-Sharing-Resolution {
    $ChangeDisplay1Result = Set-ScreenResolutionEx 1920 1080 1

    if ($ChangeDisplay1Result -eq 'Failed To Change The Resolution.') {
        Set-ScreenResolutionEx 1920 1080 0
    }
}

Function Set-Working-Resolution {
    $ChangeDisplay1Result = Set-ScreenResolutionEx 3440 1440 1

    if ($ChangeDisplay1Result -eq 'Failed To Change The Resolution.') {
        Set-ScreenResolutionEx 3440 1440 0
    }
}
