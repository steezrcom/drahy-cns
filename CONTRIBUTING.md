# Contributing

This is a small preservation project: a wrapper that keeps 30 Czech neuroanatomy Flash animations playable after Adobe Flash deprecation. Everything in `public/swf/` is © Anatomický ústav 1. LF UK and lives upstream. The rest is the wrapper, MIT-licensed, and that's where contributions land.

## In scope

PRs welcome on:

- **The wrapper UI** (`index.html`, `player.html`, `style.css`, `data.js`). Accessibility, mobile UX, browser-compat fixes, copy improvements.
- **Build and deploy** (`Dockerfile`, `nginx.conf`, `Makefile`, `stage-swfs.sh`). Faster builds, smaller images, better caching, CI configs.
- **Content metadata**: titles, slugs, ordering in `data.js`. If you spot a Czech-language fix or a clearer transliteration, send a PR.
- **Bugs**: anything that prevents a SWF from playing on a supported browser, breaks navigation, or makes the page unreadable.

## Out of scope

The SWF animations themselves are upstream content. Wrong label inside an animation, missing slide, clinical correction: those go to the Institute of Anatomy at <https://anat.lf1.cuni.cz/>, not here. We update `public/swf/` only when upstream `drahyCNS.zip` is updated; `make stage` re-fetches.

## Workflow

1. Fork, branch off `main`.
2. `make dev` rebuilds the image and runs it on `http://localhost:5557`. `make test` smoke-tests the routes.
3. Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`). Lowercase, imperative mood, ≤ 72 chars on the subject line.
4. Open a PR against `main`. Briefly explain the why, not just the what.

## Style

- Match the existing tone: terse, direct, no marketing copy.
- Czech UI strings use proper Czech typography (non-breaking spaces in abbreviations like `dr.`, en-dash for year ranges).
- Don't add comments that describe what the code does. Comments are for the *why* when it's non-obvious.
- Don't add dependencies without a clear use. The site is intentionally simple: HTML + CSS + a little vanilla JS + nginx + Ruffle, no build step beyond the Dockerfile.

## License

By submitting a PR you agree your contribution is licensed under the [MIT License](LICENSE).
