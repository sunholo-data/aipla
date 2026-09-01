# Retiring the legacy AIPLA website

The maintained English project website now lives in the main application at
`https://aipla.ku.dk/project`. This repository remains the historical source
and, after cutover, the compatibility layer for old links under
`https://www.sunholo.com/aipla/`.

## Safety gates

Do not enable retirement until all of these are true:

1. `aipla.ku.dk` resolves to the intended production application.
2. The managed certificate is active and HTTPS works without warnings.
3. Production smoke checks pass for `/project`, every project navigation page,
   the three activity case studies, `/robots.txt`, and `/sitemap.xml`.
4. The legacy-to-new mapping has been link-checked.
5. A copy of the last full Quarto artifact and this repository revision has
   been recorded for rollback.

## Activation

The Pages workflow is deliberately controlled by the repository variable
`AIPLA_LEGACY_RETIREMENT`:

- unset or any value other than `enabled`: publish the full Quarto website;
- `enabled`: publish the small redirect site built by
  `retirement/build-redirect-site.sh`.

Set the variable only after the safety gates pass, then run **Publish Quarto
site** manually. Verify representative old URLs before announcing retirement.

## Rollback

Set `AIPLA_LEGACY_RETIREMENT` to `disabled` (or remove it) and run the workflow
again. The original Quarto site will be rebuilt from the repository. Do not
delete the source or its GitHub Pages project during the initial retirement
period.

Keep the redirects for at least 12 months and review access data before any
later repository archival or domain removal.
