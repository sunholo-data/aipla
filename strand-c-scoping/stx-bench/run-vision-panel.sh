#!/usr/bin/env bash
# Repeat the vision graph-reading panel N times per model for mean±std,
# matching the text panel's 5-run treatment. Per-run output:
#   runs/stage2vision/<label>-r<N>.jsonl
# Usage: ./run-vision-panel.sh <N-runs> <group>   group = gemini | orweights
set -u
cd "$(dirname "$0")"
N="${1:-5}"; GROUP="${2:-gemini}"
mkdir -p runs/stage2vision

one() { # api-name  friendly(--ai)  label
  local api="$1" ai="$2" label="$3"
  for r in $(seq 1 "$N"); do
    TRIAL_MODEL="$api" ailang run --ai "$ai" --caps IO,FS,AI,Env,Clock \
      --entry main benchmark/runmodel_vision.ail 2>/dev/null \
      | grep '^{' > "runs/stage2vision/${label}-r${r}.jsonl"
    local ok tot; ok=$(grep -c '"verdict":"correct"' "runs/stage2vision/${label}-r${r}.jsonl")
    tot=$(grep -c '"item_id"' "runs/stage2vision/${label}-r${r}.jsonl")
    echo "${label} run ${r}: ${ok}/${tot}"
  done
}

if [ "$GROUP" = "gemini" ]; then
  one gemini-3.5-flash      gemini-3-5-flash      gemini-3.5-flash
  one gemini-2.5-flash      gemini-2-5-flash      gemini-2.5-flash
  one gemini-2.5-flash-lite gemini-2-5-flash-lite gemini-2.5-flash-lite
  one gpt-5-mini            gpt-5-mini            gpt-5-mini
else
  one google/gemma-3-27b-it                    google/gemma-3-27b-it                    gemma-3-27b
  one mistralai/mistral-small-3.2-24b-instruct mistralai/mistral-small-3.2-24b-instruct mistral-small-3.2-24b
fi
echo "DONE ${GROUP}"
