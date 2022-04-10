Function yf {
	$YarnVersion = $(yarn --version)

	if ($YarnVersion.StartsWith('1')) {
		yarn --frozen-lockfile @Args
	}
	else {
		yarn --immutable @Args
	}
}

Function ylx {
	yarn3 dlx @Args
}

Function yarnclean {
	Remove-Item ((yarn cache dir) + '\*') -Force -Recurse -ErrorAction ignore;
	regenlockfile;
}

Function regenlockfile {
	Remove-Item -Recurse -Force .\node_modules -ErrorAction ignore;
	Remove-Item -Force .\yarn.lock -ErrorAction ignore;
	yarn install
}

Function Start-Yarn3 {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $False, ValueFromRemainingArguments = $True)]
		$Arguments
	)

	Process {
		node $Env:USERPROFILE\.bin\yarn-3.1.0.cjs $Arguments
	}
}

Function Yarn-All-Repos {
	Get-ChildItem -Filter 'yarn.lock' -Recurse -Depth 2 -Exclude node_modules | ForEach-Object {
		$dirname = $_
		Push-Location $dirname\..\

		Write-Host "Running yarn install for ${dirname}" -ForegroundColor Green
		yf

		Write-Host '-------------' -ForegroundColor Gray
		Pop-Location
	}
}

Function Npm-All-Repos {
	Get-ChildItem -Filter 'package-lock.json' -Recurse -Depth 2 -Exclude node_modules | ForEach-Object {
		$dirname = $_
		Push-Location $dirname\..\

		Write-Host "Running npm ci for ${dirname}" -ForegroundColor Green
		npm ci

		Write-Host '-------------' -ForegroundColor Gray
		Pop-Location
	}
}

Function Start-Npm-Upgrade {
	npm-upgrade
}

Function Get-Coverage {
	http-server .\coverage\lcov-report\ -gbso -p 8081 -c-1
}

Function Get-Docs {
	http-server .\docs -gbso -p 8081 -c-1
}

Function Open-Redis {
	Param (
		[string]$Database = 2
	)

	Process {
		redis-commander --redis-port 8287 --redis-host localhost --redis-password redis --redis-db $Database --open
	}
}

Function Generate-Gource {
	gource -f -1920x1080 --camera-mode overview -e 0.5 --background 0D1117 --date-format '%A, %d %B, %Y' -s 0.5 --user-image-dir .\.git\avatar\ --logo .\skyra.png --title 'Skyra Development History'
}

Function Disable-Node-Tls {
	$env:NODE_TLS_REJECT_UNAUTHORIZED = 0
}

Function Enable-Node-Tls {
	$env:NODE_TLS_REJECT_UNAUTHORIZED = 1
}

Function Flaky-TestCafe {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $True)]
		$Path,
	
		[Parameter(Mandatory = $False)]
		$Runs
	)

	Process {
		$FinalTestResult = 'Success'
		$FailedTests = ''

		if ($null -eq $Runs) {
			$Runs = 5
		}

		Write-Host "Running $Runs times" -ForegroundColor Blue

		for ($i = 1; $i -le $Runs; $i++) {
			Write-Host -ForegroundColor Yellow "run $i"

			npx testcafe $Path

			$TestResult = $($?)

			if ($TestResult -eq $False) {
				$FinalTestResult = 'Failed'
				$FailedTests += "$i, "
			}
		}

		if ($FinalTestResult -eq 'Success') {
			Write-Host -ForegroundColor Green 'All runs passed'
		}
		else {
			Write-Host -ForegroundColor Red 'At least 1 test failed'
			Write-Host -ForegroundColor Red 'Failed test are: $FailedTests'
		}
	}
}
