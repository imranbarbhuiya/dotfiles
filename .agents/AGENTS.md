## My email

My email is always imranbarbhuiya.fsd@gmail.com, whatever account, tool or project. Don't take it from anywhere else unless I ask.

## Agents and memory

- Which account or provider a subagent or delegate runs on is my call in the chat. Use what I said last in the current thread; if I haven't said, don't ask, use your own native subagents. Never save it to memory, docs or briefs as a standing rule.
- A SessionStart hook links every T3 scratch folder's memory to one shared scratch memory, so notes saved there carry over to later scratch threads. Save only facts that outlive the thread there (servers, hosts, access paths); facts about a project go in that project's memory.

## Git

I mostly work through one orchestrator thread that delegates to subagents, and each thread or delegated task usually gets its own worktree. Inside a worktree that is yours, stage, commit, amend, rebase and stash as the task needs. Before branch operations, name the repo you are acting on.

In a checkout that someone else also uses (the main checkout, or a delegated task sharing its caller's checkout):
- Stage and commit only your own paths (`git add <paths>`, never `-A` or `.`).
- Never stash, reset, checkout or restore changes you didn't make.
- I may have staged things myself, so include staged changes when checking what changed.

Worktrees:
- Only create one when it's actually needed.
- Prefer symlinking installed or generated dirs (node_modules, .venv, Rust target) from the main checkout to save disk. Run a normal install instead when the symlink would point the worktree back at the main checkout or break tooling: monorepo workspace packages (their links resolve to the main checkout's packages), tools that reject symlinks, a worktree that needs different dependencies, and Bun projects (`bun install` clones files instead of copying them and costs almost no disk).
- Before removing one, check `git -C <path> status --porcelain`. If anything there is work, commit it or ask me first.

## Shipping and CI

- When I ask you to push, merge or deploy, do it without asking me to confirm again, in every repo the task touches, including linked repos we're working on together. Still ask before force-pushing a shared branch or touching prod beyond what I asked for.
- Don't pass `--no-verify` on your own. If a hook fails, fix what it reports. When I ask for or allow `--no-verify`, prefix the git command with `ALLOW_NO_VERIFY=1` so the guard hook lets it through.
- CI or deploy failures with DNS, TLS handshake, timeout or connection-reset errors are usually the network. Rerun once before changing code.

## Commits, PRs and docs

Never name my other repos, clients or reference apps, or their local paths, in commit messages, code comments, docs, plans or PR text, and don't say where an approach was borrowed from. Describe the behaviour neutrally ("the reference app"). Reading those repos is fine.

Screenshots and videos in a PR:
- Upload them with gh's `--attach` flag (`gh pr create`, `gh pr edit`, `gh pr comment`; up to 50 files per command). Never push a separate assets branch or commit screenshots to the repo for this.
- Write the body to a file that references the local images, then pass `--body-file body.md --attach './before/calendar.png#Calendar, before'`. gh uploads each file and rewrites the reference; paths are relative to the body file's directory. If gh exits non-zero, re-run `gh pr edit --attach` for the uploads that failed.
- Put each group of before/after shots or videos in a collapsed `<details>` block with a `<summary>` naming the screen, and leave a blank line after `</summary>` so the markdown inside renders:

  ```markdown
  <details>
  <summary>Calendar: before and after</summary>

  | Before | After |
  | --- | --- |
  | ![Calendar, before](./before/calendar.png) | ![Calendar, after](./after/calendar.png) |

  </details>
  ```

## Shell

The Bash tool runs zsh, which breaks bash habits quietly:
- unquoted `$VAR` is not word-split, so `for x in $LIST` runs once with the whole string
- an unmatched glob is an error, not a literal
- a word starting with `=` expands to a command path, so `echo ==x` fails

Run anything with loops, arrays or variable expansion as `bash -c '...'` or a bash script. In helper scripts, use `set -euo pipefail`.

Search code with `rg` (`rg --files` to list files) rather than `grep -r` or `find | xargs grep`. It skips gitignored paths like `node_modules` and is much faster.

Before trusting a check (a grep for a secret, a UI selector, a status probe), run it once against the real output and confirm it matches.

## Editing files

- Don't leave backup copies (`*.bak`, `*.orig`, `*.backup-<date>`) when editing config files. Note the old value in your reply, and use git where the file is tracked. If you made a temporary copy, delete it before you finish.
- Only re-resolve a lockfile when the task is a dependency change. Otherwise install with the frozen flag (`bun install --frozen-lockfile`, `npm ci`, `pnpm install --frozen-lockfile`, `uv sync --locked`). If a lockfile changes unexpectedly, revert it before committing.

## Servers, clusters and AWS

- Before running kubectl, name the kube context you are acting on.
- Never use the AWS CLI for anything that isn't read-only, and even read-only commands only after I approve them. No creating, changing or deleting resources (IAM users, keys, SES identities, S3, DNS, anything), even if credentials are on the machine and a task seems to need it. Tell me what's needed and let me do it or decide.

## Local dev servers

For local web apps and APIs, use the Portless CLI: `portless` for a package `dev` script, `portless run <command>` otherwise and in linked worktrees, and a distinct name per service (`web.project`, `api.project`). Skip it for Metro/Expo/React Native and Vite; run those on the project's own port and say so. Use the Portless URL in browser checks and cross-service config (`portless get <name>`). Don't assume port 3000 or pick ports yourself. If a script ignores the assigned `PORT`, make it honor it and report that.

Report each service's URL, folder and how to stop it, and stop what you started when it's no longer needed. Use `portless list` and `portless prune` for stale routes. Never stop another project's service or `--force` its name.

## Shared resources: RAM, CPU and backing services

This Mac has 24 GB of RAM and 8 cores, shared by OrbStack, simulators, emulators and several agents at once. Keep containers, devices and test runs to what the task needs.

- Use the shared stack in `~/docker/local-dev` (`docker compose up -d` there; endpoints in its README) instead of starting Postgres, Redis, MongoDB, RabbitMQ, MinIO or a mail catcher per project or worktree. Redis is on 6380. Send local email to Mailpit (SMTP `localhost:1025`, UI `localhost:8025`) with an `X-Tags: <project>` header.
- Give each project its own Postgres database and role, MongoDB database, Redis DB index or key prefix, RabbitMQ vhost and MinIO bucket. Only clear your own index (`FLUSHDB`, never `FLUSHALL`), and never drop another project's database.
- Keep each project's connection pool small (about 5–10 locally) so all projects together stay under the shared Postgres's `max_connections`. On "too many connections" errors, shrink pools or end idle sessions instead of starting another container.
- Give a project its own container only when it needs a different major version, an extension the shared one lacks (pgvector, PostGIS), Redis Cluster, or isolation the task requires. Say why when you do.
- Cap test workers (Jest and Vitest `--maxWorkers=2`; `bun test` without raising `--max-concurrency`) and run the files or project you changed rather than the whole suite, unless the task needs the full suite.
- When a task finishes, `docker compose stop` the stacks you started (not `down -v`, which deletes data). Leave running anything you didn't start.

## Simulators and emulators

My Mac must stay quiet and usable while agents test:
- Before long device testing, check free memory and swap, that Metro and dev servers are alive, and that the backend is reachable. Say up front which platforms can realistically be verified.
- Use at most one simulator or emulator and one Metro per agent. Boot simulators headless.
- Drive apps only with the device tools' taps and text entry into a focused field. No host keystrokes or shortcuts, `osascript` keystrokes or `cliclick`.
- Turn test users' sounds off first. Never start real calls, ringtones or media with audio; run web participants in Playwright with `--mute-audio`, and verify call audio with tests and logs.
- When done, shut down the devices you booted (`adb -s <serial> emu kill` for emulators) and leave the rest running. If one dies unexpectedly, stop and report; I may have stopped it, so don't relaunch in a loop.

## Verification

When the work is judged by how something looks or behaves in a browser (a Figma design, a reference URL, comparing a screen, checking a change works), drive a real browser: navigate, click into the state you need, read the DOM, screenshot if I need to see it.
- Use the browser tools this session already has. Only if none are available, use the Playwright copy at `~/.local/share/playwright` (browsers in `~/Library/Caches/ms-playwright`), loaded by absolute path with `require(process.env.HOME + '/.local/share/playwright/node_modules/playwright')` and `chromiumSandbox: true`. Its Chromium is security-patched: never run `playwright install` or install Playwright. If it's missing or won't launch, ask me.
- Never fetch a page's HTML and summarise it as verification. Client-rendered apps return a shell, and reading that markup invents elements that aren't there. If no browser is available, say the UI is unverified.

When a task involved device, CI, deploy or live-backend verification, end with three groups: verified for real, verified only against mocks or tests, and not verified. Give the exact command or step to finish each unverified item.
