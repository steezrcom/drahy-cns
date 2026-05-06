# drahy

Web archive of an old neuroanatomy teaching project: 30 interactive SWF animations and quizzes covering the main sensory and motor pathways and cerebellar circuits. Plays in 2026 browsers via [Ruffle](https://ruffle.rs), the open-source Flash emulator (Rust + WebAssembly).

Source code: <https://github.com/steezrcom/drahy-cns>. Live mirror: <https://drahy.steezr.cloud>.

## Attribution

The original animations were authored 2007-2012 at the **Institute of Anatomy, 1st Faculty of Medicine, Charles University in Prague** (Anatomický ústav 1. LF UK) by:

- dr. Brabec
- doc. Naňka
- dr. Němcová
- prof. Petrovický

The work was funded under FRVŠ projects (Fond rozvoje vysokých škol).

Original page (still online, but the SWFs no longer play in modern browsers): <https://anat.lf1.cuni.cz/materialy/drahyCZ.php>

Source archive: <https://anat.lf1.cuni.cz/materialy/drahyCNS.zip>

This deployment is an unofficial mirror hosted at **drahy.steezr.cloud** to keep the materials usable after Adobe Flash deprecation. Hosting is provided pro bono by **steezr s. r. o.** for the benefit of medical students, with no claim to compensation. All copyright remains with the Institute of Anatomy, 1st Faculty of Medicine, Charles University. If you are from the institute and want this taken down, moved, or hosted under your own domain, contact johnny@steezr.com.

## What's in here

```
public/                static site
  index.html           landing page, lists all 30 items
  player.html          generic player page (?id=<slug>)
  data.js              slug → title → file mapping
  style.css
  swf/drahy/           12 SWFs (sensory/motor pathways + 3 quizzes)
  swf/propriocepce/    18 SWFs (proprioception, cerebellar circuits + 7 quizzes)

Dockerfile             multi-stage: npm-installs ruffle + geist, copies into nginx:alpine
nginx.conf             listens on :5000, /healthz, cache headers
stage-swfs.sh          fetches drahyCNS.zip from anat.lf1.cuni.cz and refreshes public/swf/
```

`public/swf/` is the source of truth for what the site serves. The original archive is not committed; if you need to re-stage from upstream, run `./stage-swfs.sh`.

## Develop locally

```bash
docker build -t drahy .
docker run --rm -p 5557:5000 drahy
open http://localhost:5557
```

If you change `data.js`, `nginx.conf`, or HTML/CSS, just rebuild. SWFs are cached aggressively in the browser (immutable, 1 year), so if you replace a SWF in place during dev, hard-reload (Cmd+Shift+R).

## Refresh from upstream

If `drahyCNS.zip` on `anat.lf1.cuni.cz` is updated, re-stage:

```bash
./stage-swfs.sh
```

The script downloads the zip into a tempdir, copies the SWFs into `public/swf/` under their slugs, and cleans up. Edit the `MAP` array if the upstream archive adds, removes, or renames a file. Update `public/data.js` to match, then rebuild.

## Deploy to Dokku

One-time on the Dokku host:

```bash
dokku apps:create drahy
dokku domains:set drahy drahy.steezr.cloud
dokku letsencrypt:set drahy email johnny@steezr.com
dokku letsencrypt:enable drahy
```

From this machine:

```bash
git init
git add .
git commit -m "feat: initial flash archive"
git remote add dokku dokku@<host>:drahy
git push dokku main
```

Then point a CNAME from `drahy.steezr.cloud` to the Dokku host.

Dokku detects the Dockerfile, builds, and routes public 80/443 to the container's internal :5000. Health check hits `/healthz`.

Image is ~60 MB: nginx:alpine + 53 MB SWFs + ~2 MB Ruffle.

## Pin the Ruffle version

The Dockerfile installs `@ruffle-rs/ruffle@latest` at build time, so each rebuild may pull a newer Ruffle. To pin, replace `@latest` with a specific version (see [npm](https://www.npmjs.com/package/@ruffle-rs/ruffle)).

## Notes

- All SWFs are self-contained (verified with `strings` for `loadMovie` / external URLs). No companion files or runtime fetches.
- HTML/CSS/JS are served `Cache-Control: no-cache, must-revalidate` so updates roll out immediately. SWFs and WebAssembly are immutable for a year.
- Stage size of every SWF is 800×600. The player container caps at 1024×768 (4:3) and Ruffle scales up cleanly.
- Some content has bilingual CZ/EN toggles inside the SWF itself ("English version" button).
