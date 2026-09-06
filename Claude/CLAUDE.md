Do not add random comments to each and every functions, jsk block and random lines of codes unless its very important or asked to do so or explaining a workaround.

If the workaround needs multiple lines of comments to explain, then the workaround might not be a good workaround and you should try to find a better approach.

Do not stage/unstage/stash codes as i run multiple agents parallelly and their changes might get lost

While you are doing changes, I might review and stage the files so if you need to check for changed files, make sure to account for --cached files too

## Verifying UI in a browser

Any time the work is judged by how something looks or behaves in a browser — I share a Figma design,
point at a deployed reference or handoff URL, ask you to verify/compare a screen, or ask whether a
change actually works — drive a real browser. Use whatever browser tooling is available; otherwise
Playwright, which I already have.

The browser binaries live in a shared user-level cache and are already downloaded — never reinstall
them, and don't conclude they're missing without checking the right path for the OS
(`~/Library/Caches/ms-playwright` on macOS, `~/.cache/ms-playwright` on Linux).

Only the `playwright` npm package has to be resolvable. If `require('playwright')` already works, just
use it. If it doesn't, install it into the scratchpad — never into the project's package.json:

```sh
cd "$SCRATCHPAD" && npm i playwright
```

That is a couple of seconds and downloads no browser. Run `npx playwright install chromium` only if
launching actually fails on a missing binary.

Then script it: navigate, click into the state you need, read the DOM, screenshot if I need to see it.

Do not substitute fetching a page's HTML and summarising it. Modern apps render client-side and hold
state that no URL exposes — tabs, wizard steps, accordions, modals — so a fetch returns the shell and
an LLM reading that markup **will confidently invent elements that aren't there**. This has already
produced fake mismatches that led to real code being changed for no reason.

If no browser is available and you cannot install one, say the UI is unverified. Never present
fetched-HTML guesses as verification.
