## My email

My email is always imranbarbhuiya.fsd@gmail.com, whatever account, tool or project. Don't take it from anywhere else unless I ask.

## Git in shared checkouts

I mostly work through one orchestrator thread that delegates to subagents, and each thread or
delegated task usually gets its own worktree. Inside a worktree that is yours, stage, commit,
amend, rebase and stash as the task needs.

In a checkout that someone else also uses (the main checkout, or a delegated task sharing its
caller's checkout):
- Stage and commit only your own paths (`git add <paths>`, never `-A` or `.`).
- Never stash, reset, checkout or restore changes you didn't make.
- I may have staged things myself, so include staged changes when checking what changed.

## Git worktrees

Only create a worktree when it's actually needed. Prefer symlinking installed or generated dirs
(node_modules, .venv, Rust target) from the main checkout to save disk. Skip the symlink and run a
normal install when it would point the worktree back at the main checkout or break tooling:
- monorepo workspace packages, whose links resolve to the main checkout's packages
- tools that reject symlinks
- a worktree that needs different dependencies
- Bun projects, where `bun install` clones files instead of copying them and costs almost no disk

Before removing a worktree, check `git -C <path> status --porcelain`. If anything there is work, commit it or ask me first.

## Shipping

When I ask you to push, merge or deploy, do it without asking me to confirm again, in every repo the task touches, including linked repos we're working on together. Still ask before force-pushing a shared branch or touching prod beyond what I asked for.

Don't pass `--no-verify` on your own. If a hook fails, fix what it reports. When I ask for or allow `--no-verify`, prefix the git command with `ALLOW_NO_VERIFY=1` so the guard hook lets it through.

## Shell

The Bash tool runs zsh, which breaks bash habits quietly:
- unquoted `$VAR` is not word-split, so `for x in $LIST` runs once with the whole string
- an unmatched glob is an error, not a literal
- a word starting with `=` expands to a command path, so `echo ==x` fails

Run anything with loops, arrays or variable expansion as `bash -c '...'` or a bash script.

In helper scripts, use `set -euo pipefail`. Before trusting a check (a grep for a secret, a UI selector, a status probe), run it once against the real output and confirm it matches.

## Dependencies and lockfiles

Only re-resolve a lockfile when the task is a dependency change. Otherwise install with the frozen flag (`bun install --frozen-lockfile`, `npm ci`, `pnpm install --frozen-lockfile`, `uv sync --locked`). If a lockfile changes unexpectedly, revert it before committing.

## Targets and environment

- Before branch operations or kubectl, name the repo and kube context you are acting on.
- CI or deploy failures with DNS, TLS handshake, timeout or connection-reset errors are usually the network. Rerun once before changing code.
- Before long device or simulator testing, check free memory and swap, that Metro and dev servers are alive, and that the backend is reachable. Say up front which platforms can realistically be verified.

## Reporting verification

When a task involved device, CI, deploy or live-backend verification, end with three groups: verified for real, verified only against mocks or tests, and not verified. Give the exact command or step to finish each unverified item.

## Verifying UI in a browser

When the work is judged by how something looks or behaves in a browser (a Figma design, a reference URL, comparing a screen, checking a change works), drive a real browser: navigate, click into the state you need, read the DOM, screenshot if I need to see it.

Use the browser tools this session already has. Only if none are available, use the Playwright copy at `~/.local/share/playwright` (browsers in `~/Library/Caches/ms-playwright`), loaded by absolute path with `require(process.env.HOME + '/.local/share/playwright/node_modules/playwright')` and `chromiumSandbox: true`. Its Chromium is security-patched: never run `playwright install` or install Playwright. If it's missing or won't launch, ask me.

Never fetch a page's HTML and summarise it as verification. Client-rendered apps return a shell, and reading that markup invents elements that aren't there. If no browser is available, say the UI is unverified.

## AWS CLI

Never use the AWS CLI for anything that isn't read-only, and even read-only commands only after I approve them. No creating, changing or deleting resources (IAM users, keys, SES identities, S3, DNS, anything), even if credentials are on the machine and a task seems to need it. Tell me what's needed and let me do it or decide.

## Local dev servers

For local web apps and APIs, use the Portless CLI: `portless` for a package `dev` script, `portless run <command>` otherwise and in linked worktrees, and a distinct name per service (`web.project`, `api.project`). Skip it for Metro/Expo/React Native and Vite; run those on the project's own port and say so. Use the Portless URL in browser checks and cross-service config (`portless get <name>`). Don't assume port 3000 or pick ports yourself. If a script ignores the assigned `PORT`, make it honor it and report that.

Report each service's URL, folder and how to stop it, and stop what you started when it's no longer needed. Use `portless list` and `portless prune` for stale routes. Never stop another project's service or `--force` its name.

## Screenshots in PRs

Put screenshots and videos in a PR with gh's `--attach` flag (`gh pr create`, `gh pr edit`, `gh pr comment`; up to 50
files per command). Write the body to a file that references the local images, such as `![Calendar, before](./before/calendar.png)`,
then pass `--body-file body.md --attach './before/calendar.png#Calendar, before'`. gh uploads each file and rewrites the
reference; paths are relative to the body file's directory. Never push a separate assets branch or commit screenshots to
the repo for this. If gh exits non-zero, re-run `gh pr edit --attach` for the uploads that failed.
