#!/usr/bin/env bash
set -euo pipefail

OUTPUT="_redirect_site"
TARGET_ORIGIN="https://aipla.ku.dk"

rm -rf "${OUTPUT}"
mkdir -p "${OUTPUT}/assets/examples"

write_redirect() {
  local source_path="$1"
  local target_path="$2"
  local output_file="${OUTPUT}/${source_path}"
  mkdir -p "$(dirname "${output_file}")"
  cat > "${output_file}" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AIPLA has moved</title>
  <meta http-equiv="refresh" content="0; url=${TARGET_ORIGIN}${target_path}">
  <link rel="canonical" href="${TARGET_ORIGIN}${target_path}">
  <meta name="robots" content="noindex, follow">
  <script>window.location.replace("${TARGET_ORIGIN}${target_path}" + window.location.hash);</script>
  <style>
    body { max-width: 42rem; margin: 12vh auto; padding: 1.5rem; font: 18px/1.6 system-ui, sans-serif; color: #20232d; }
    a { color: #8b1d1d; }
  </style>
</head>
<body>
  <h1>AIPLA has moved</h1>
  <p>The maintained AIPLA project website is now part of the application at the University of Copenhagen.</p>
  <p><a href="${TARGET_ORIGIN}${target_path}">Continue to the new page</a>.</p>
</body>
</html>
EOF
}

write_redirect "index.html" "/project"
write_redirect "about.html" "/project/about"
write_redirect "strands.html" "/project/workstreams"
write_redirect "examples.html" "/project/activities"
write_redirect "timeline.html" "/project/progress"
write_redirect "architecture.html" "/project/platform"
write_redirect "evaluation.html" "/project/evaluation"
write_redirect "self-hosting.html" "/project/data-and-hosting"
write_redirect "led-planck.html" "/project/activities/led-planck"
write_redirect "kinebot.html" "/project/activities/kinebot"
write_redirect "assets/examples/projectile-motion.html" "/project/activities/boldkast"
write_redirect "assets/examples/led-planck-virtual-lab.html" "/project/activities/led-planck"
write_redirect "assets/examples/kinebot-v2.html" "/project/activities/kinebot"
write_redirect "404.html" "/project"

touch "${OUTPUT}/.nojekyll"
echo "Built $(find "${OUTPUT}" -name '*.html' | wc -l | tr -d ' ') redirect pages in ${OUTPUT}."
