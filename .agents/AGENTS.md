Do not add random comments to each and every functions, jsk block and random lines of codes unless its very important or asked to do so or explaining a workaround.

If the workaround needs multiple lines of comments to explain, then the workaround might not be a good workaround and you should try to find a better approach.

## Git in shared checkouts

I mostly work through one orchestrator thread that delegates to subagents, and each thread or
delegated task usually gets its own worktree. Inside a worktree that is yours, stage, commit,
amend, rebase and stash as the task needs.

In a checkout that someone else also uses (the main checkout, or a delegated task sharing its
caller's checkout):
- Stage and commit only your own paths (`git add <paths>`, never `-A` or `.`).
- Never stash, reset, checkout or restore changes you didn't make.
- I may have staged things myself, so include staged changes when checking what changed.

## Verifying UI in a browser

Any time the work is judged by how something looks or behaves in a browser — I share a Figma design,
point at a deployed reference or handoff URL, ask you to verify/compare a screen, or ask whether a
change actually works — drive a real browser.

Use the browser tools this session already has. Only if none are available, use Playwright without
installing anything: a working copy is at `~/.local/share/playwright`, with browsers in
`~/Library/Caches/ms-playwright`. Load it by absolute path
(`require(process.env.HOME + '/.local/share/playwright/node_modules/playwright')`). Its Chromium cache is
security-patched; do not overwrite it with `playwright install`. Enable `chromiumSandbox: true` when
launching Chromium. If that copy is missing or won't launch, ask me; never install Playwright or its browsers.

Then script it: navigate, click into the state you need, read the DOM, screenshot if I need to see it.

Do not substitute fetching a page's HTML and summarising it. Modern apps render client-side and hold
state that no URL exposes — tabs, wizard steps, accordions, modals — so a fetch returns the shell and
an LLM reading that markup **will confidently invent elements that aren't there**. This has already
produced fake mismatches that led to real code being changed for no reason.

If no browser is available, say the UI is unverified. Never present
fetched-HTML guesses as verification.

## My Email
my email is always imranbarbhuiya.fsd@gmail.com doesnt matter which account or tool im using or which project im working on. Dont take from anywhere else unless I specifically ask for it.

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

- Don't pass `--no-verify` on your own. If a hook fails, fix what it reports. When I ask for or allow `--no-verify`, prefix the git command with `ALLOW_NO_VERIFY=1` so the guard hook lets it through.
- Keep commit subjects to 72 characters or fewer and put details in the body.
- When a change depends on a change in a linked repo, confirm that change is live on the target environment before shipping the dependent build or release.

## Shell

The Bash tool runs zsh, which breaks bash habits quietly:
- unquoted `$VAR` is not word-split, so `for x in $LIST` runs once with the whole string
- an unmatched glob is an error, not a literal
- a word starting with `=` expands to a command path, so `echo ==x` fails

Run anything with loops, arrays or variable expansion as `bash -c '...'` or a bash script.

In helper scripts, use `set -euo pipefail`. Before trusting a check (a grep for a secret, a UI selector, a status probe), run it once against the real output and confirm it matches. A check that can't fail proves nothing.

## Dependencies and lockfiles

Only re-resolve a lockfile when the task is a dependency change. Otherwise install with the frozen flag (`bun install --frozen-lockfile`, `npm ci`, `pnpm install --frozen-lockfile`, `uv sync --locked`). If a lockfile changes unexpectedly, revert it before committing.

## Targets and environment

- Before branch operations or kubectl, confirm the repo and kube context you are acting on and name them in your message.
- CI or deploy failures with DNS, TLS handshake, timeout or connection-reset errors are usually the network. Rerun once before changing code.
- Before long device or simulator testing, check free memory and swap, that Metro and dev servers are alive, and that the backend is reachable. Say up front which platforms can realistically be verified.
- Don't run evals or other paid model calls in parallel without a cap. Ask before large runs.

## Reporting verification

When a task involved device, CI, deploy or live-backend verification, end with three groups: verified for real, verified only against mocks or tests, and not verified. Give the exact command or step to finish each unverified item.

## AWS CLI

Never use the AWS CLI for anything that isn't read-only, and even read-only commands only after I approve them. No creating, changing or deleting resources (IAM users, keys, SES identities, S3, DNS, anything), even if credentials are on the machine and a task seems to need it — tell me what's needed and let me do it or decide.

## Local development servers and ports

For local web apps and APIs, prefer the installed Portless CLI. Skip it where it doesn't work, such as Metro/Expo/React Native and Vite projects; run those on the project's own port and say so. Otherwise run `portless` for a normal package `dev` script, or `portless run <command>` for an explicit command. Use `portless run` in linked Git worktrees so each worktree gets its own URL. For multiple services in one project, give each service a distinct name such as `web.project` and `api.project`.

Use the Portless URL in browser checks and cross-service configuration. Get another service's URL with `portless get <name>` when needed. Do not assume port 3000, manually pick a random port, or silently move to the next port. If a script ignores Portless's assigned `PORT` or injected flags, configure that script to honor its assigned port and report the exception.

Run dev servers in a managed terminal or session when possible. Report each service's URL, project folder, and stop command or session. Stop processes you started when they are no longer needed unless the user asked to keep them running. Check `portless list` for routes and use `portless prune` for orphaned sessions. Do not stop another project's service or use `--force` just to claim its name.

For databases, Redis, and other non-HTTP listeners, follow the project's port configuration and report the actual endpoint. Portless hostnames are for HTTP traffic.

## Screenshots in PRs

Put screenshots and videos in a PR with gh's `--attach` flag (`gh pr create`, `gh pr edit`, `gh pr comment`; up to 50
files per command). Write the body to a file that references the local images, such as `![Calendar, before](./before/calendar.png)`,
then pass `--body-file body.md --attach './before/calendar.png#Calendar, before'`. gh uploads each file and rewrites the
reference; paths are relative to the body file's directory. Never push a separate assets branch or commit screenshots to
the repo for this. If gh exits non-zero, re-run `gh pr edit --attach` for the uploads that failed.
