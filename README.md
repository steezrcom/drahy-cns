# drahy-cns

Web archive of an old neuroanatomy teaching project: 30 interactive SWF animations and quizzes covering the main sensory and motor pathways and cerebellar circuits. Plays in modern browsers via [Ruffle](https://ruffle.rs), the open-source Flash emulator (Rust + WebAssembly).

**Live:** <https://drahy.steezr.cloud>

## Attribution

The original animations were authored 2007-2012 at the **Institute of Anatomy, 1st Faculty of Medicine, Charles University in Prague** (Anatomický ústav 1. LF UK) by:

- dr. Brabec
- doc. Naňka
- dr. Němcová
- prof. Petrovický

The work was funded under FRVŠ projects (Fond rozvoje vysokých škol).

Original landing page (still online; SWFs no longer play in modern browsers): <https://anat.lf1.cuni.cz/materialy/drahyCZ.php>
Source archive: <https://anat.lf1.cuni.cz/materialy/drahyCNS.zip>

This repository is an unofficial preservation mirror. The deployment at `drahy.steezr.cloud` is hosted pro bono by [steezr s. r. o.](https://steezr.com) for the benefit of medical students, with no claim to compensation. All copyright in the SWFs remains with the Institute. If you are from the Institute and want this taken down, moved, or hosted under your own domain, contact <johnny@steezr.com>.

## Develop locally

Requires Docker. From a fresh clone:

```sh
make dev    # build the image, run on http://localhost:5557
make test   # curl smoke test against the running container
make logs   # follow nginx logs
make stop   # tear down
```

`make help` lists every target.

## Project layout

```
public/
  index.html           landing page, lists all 30 items
  player.html          generic player; reads slug from URL path or ?id=
  data.js              slug → title → file mapping
  style.css            single-file design system
  swf/                 30 SWFs in clean, slugged paths
  fonts/, ruffle/      copied in by Dockerfile (not checked in)
  favicon.svg, og-image.svg, og-image.png, 404.html

Dockerfile             multi-stage; npm-installs ruffle + geist into nginx:alpine
nginx.conf             listens on :5000, /healthz, clean URLs, no-cache for HTML
stage-swfs.sh          fetches drahyCNS.zip from anat.lf1.cuni.cz and refreshes public/swf/
Makefile               developer commands
```

## Refresh from upstream

If `drahyCNS.zip` on `anat.lf1.cuni.cz` is updated, re-stage:

```sh
make stage
```

The script downloads the zip into a tempdir, copies the SWFs into `public/swf/` under their slugs, and cleans up. Edit the `MAP` array in `stage-swfs.sh` if upstream adds, removes, or renames a file. Update `public/data.js` to match, then rebuild.

## Deploy

The image is a stock `nginx:alpine` exposing port `5000`, with a `/healthz` endpoint. Drop it on any container host. We deploy via Dokku:

```sh
git push dokku main
```

A reasonable health check is `GET /healthz` returning `ok`. URL routing is handled in `nginx.conf` (`try_files` falls back to `/player.html`, which reads the slug from the URL path).

## Notes

- All SWFs are self-contained (no `loadMovie` / external URL fetches). Image stays around 60 MB: nginx:alpine + 53 MB SWFs + ~2 MB Ruffle + ~70 KB Geist.
- HTML/CSS/JS are served `Cache-Control: no-cache, must-revalidate` so updates roll out immediately. SWFs, fonts, and WebAssembly are immutable for a year.
- Stage size of every SWF is 800×600. The player container caps at 1024×768 (4:3) and Ruffle scales up cleanly.
- Some SWFs have a built-in `English version` toggle. The wrapper UI is Czech only.
- Source code: MIT (see [LICENSE](LICENSE)). The SWFs themselves are © Anatomický ústav 1. LF UK and are not covered by the MIT grant.

## Contributing

PRs welcome on the wrapper (UI, accessibility, deploy, build). The SWF content lives upstream at `anat.lf1.cuni.cz` and isn't editable here. See [CONTRIBUTING.md](CONTRIBUTING.md) for scope and workflow.

## Security

Report security issues to <johnny@steezr.com>. See [SECURITY.md](SECURITY.md).
