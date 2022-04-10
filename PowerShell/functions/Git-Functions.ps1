Function Get-Current-Git-Branch() {
	git rev-parse --abbrev-ref HEAD
}

function Get-Main-Git-Branch() {
	git show-ref -q --verify refs/heads/main

	if ($LastExitCode -eq 0) {
		Write-Output 'main'
	}
	else {
		Write-Output 'master'
	}
}

Function gst {
	git status @Args
}

Function gba {
	git branch -a 
}

Function gbl {
	git branch -l
}

Function gpp {
	git push @Args
}

Function gpl {
	git pull @Args
}

Function gfa {
	git fetch --all --prune @Args
}

Function gco {
	git checkout @Args
}

Function gcom {
	git checkout origin/$(Get-Main-Git-Branch) @Args
}

Function gcbb {
	git checkout -b @Args
}

Function gpf {
	git push --force
}

Function gpsup {
	$currentBranch = Get-Current-Git-Branch
	git push --set-upstream origin $currentBranch
}

Function grset {
	git remote set-url @Args
}

Function gpum {
	git pull upstream $(Get-Main-Git-Branch)
}

Function grau {
	git remote add upstream @Args
}

Function grad {
	git remote add downstream @Args
}

Function gcl {
	git clone @Args
}

Function grlm {
	$currentBranch = Get-Current-Git-Branch
	git rev-list --count $(Get-Main-Git-Branch)..$currentBranch
}

Function grlmo {
	$currentBranch = Get-Current-Git-Branch
	git rev-list --count origin/$(Get-Main-Git-Branch)..$currentBranch
}

Function grba {
	git rebase --abort
}

Function grbm {
	git rebase origin/$(Get-Main-Git-Branch)
}

Function grbc {
	git rebase --continue
}

Function gom {
	git merge origin/$(Get-Main-Git-Branch)
}

Function gy {
	git yolo
}

Function gcy {
	git ciyolo
}

Function gsd {
	git squashdiff
}

Function ga {
	git add @Args
}

Function bdr {
	git br-delete-regex
}

Function bdu {
	git br-delete-useless-force
}

Function bduf {
	git br-delete-useless-force
}

Function Get-All-Repos {
	Get-ChildItem -Directory -Hidden -Filter '.git' -Recurse -Depth 2 -Exclude node_modules | ForEach-Object {
		$dirname = $_
		Push-Location $dirname\..\

		Write-Host "Processing git status in ${dirname}" -ForegroundColor Green
		Clear-Branches -q

		$STATUS = $(git status | grep -v 'nothing to commit' | grep -v 'up-to-date' | grep -v '^On branch (?:master|main)$')

		if (Get-Variable 'STATUS' -ErrorAction 'Ignore') {
			Write-Host $STATUS | grep --color -E '^|behind|ahead|On branch .*'
		}

		if ($STATUS -like '*can be fast-forwarded*') {
			git pull
		}

		Write-Host '-------------' -ForegroundColor Gray
		Pop-Location
	}
}

Function Clear-Branches {
	Write-Host 'Fetching and pruning remotes' -ForegroundColor Green

	git fetch --all --prune @Args

	Write-Host 'Pruning local branches' -ForegroundColor Magenta

	foreach ($branch in $(git br-delete-useless-force)) {
		Write-Host $branch -ForegroundColor Red
	}

	Write-Host '-------------' -ForegroundColor Gray
}
