#!/usr/bin/env bash
# Compress PNG files via the TinyPNG/Tinify API.
# Usage: compress.sh [--in-place] <file.png> [<file.png> ...]
# Default: foo.png -> foo.min.png (original preserved).
# --in-place: replace the original after a successful download.
set -u

API="https://api.tinify.com/shrink"
in_place=0
files=()
failures=0

for arg in "$@"; do
  case "$arg" in
    --in-place) in_place=1 ;;
    -*) echo "error: unknown option: $arg" >&2; exit 2 ;;
    *) files+=("$arg") ;;
  esac
done

if [ "${#files[@]}" -eq 0 ]; then
  echo "usage: compress.sh [--in-place] <file.png> [<file.png> ...]" >&2
  exit 2
fi

if [ -z "${TINIFY_API_KEY:-}" ]; then
  echo "error: TINIFY_API_KEY is not set." >&2
  echo "  export TINIFY_API_KEY=\"YOUR_API_KEY\"" >&2
  exit 1
fi

size_bytes() {
  stat -f%z "$1" 2>/dev/null || stat -c%s "$1" 2>/dev/null
}

report() {
  python3 - "$1" "$2" <<'PY'
import sys
before = int(sys.argv[1])
after = int(sys.argv[2])
saved = before - after
ratio = saved / before * 100 if before else 0
print(f"Compressed: {before/1024:.1f} KB -> {after/1024:.1f} KB ({ratio:.1f}% saved)")
PY
}

for input in "${files[@]}"; do
  if [ ! -f "$input" ]; then
    echo "skip: $input (file not found)" >&2
    failures=$((failures + 1))
    continue
  fi

  if [ "$in_place" -eq 1 ]; then
    output="$input"
    download_to="$(mktemp "${input}.XXXXXX")"
    trap 'rm -f "$download_to"' EXIT
  else
    output="${input%.png}.min.png"
    download_to="$output"
  fi

  response="$(curl -fsS --user "api:${TINIFY_API_KEY}" --data-binary "@${input}" "$API")" || {
    echo "error: $input (upload failed)" >&2
    failures=$((failures + 1))
    continue
  }

  url="$(printf '%s' "$response" | python3 -c 'import sys,json; print(json.load(sys.stdin)["output"]["url"])')" || {
    echo "error: $input (could not parse response)" >&2
    failures=$((failures + 1))
    continue
  }

  curl -fsS "$url" -o "$download_to" || {
    echo "error: $input (download failed, original preserved)" >&2
    failures=$((failures + 1))
    continue
  }

  if [ "$in_place" -eq 1 ]; then
    mv "$download_to" "$input"
  fi

  before="$(size_bytes "$input")"
  after="$(size_bytes "$output")"
  echo "$output"
  report "$before" "$after"
done

if [ "$failures" -gt 0 ]; then
  echo "$failures file(s) failed." >&2
  exit 1
fi
