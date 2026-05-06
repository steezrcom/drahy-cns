# Security

Report security issues to <johnny@steezr.com>. Please don't open a public issue first.

## In scope

- Misconfigured headers, CSP, or routing in `nginx.conf`
- Exposed sensitive files in the deployed Docker image
- Vulnerabilities in `nginx:alpine`, Ruffle, or `@fontsource-variable/geist` that affect this site as deployed
- TLS, DNS, or hosting misconfiguration on `drahy.steezr.cloud`

## Out of scope

- The Flash content itself. Ruffle sandboxes SWFs; they have no network or filesystem access.
- Bugs in upstream Ruffle. Report those at <https://github.com/ruffle-rs/ruffle>.
- Issues in third-party services (Cloudflare, GitHub, Dokku, the Institute's upstream archive).

## Bounty

None. This is a volunteer preservation project, hosted pro bono. We'll publicly thank you for a useful report.

## Disclosure

We try to respond within a few days. Coordinated disclosure: please don't publish a vulnerability before we have a chance to ship a fix.
