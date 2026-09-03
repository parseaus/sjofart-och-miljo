#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")" && pwd)"
docs_dir="$repo_root/docs"
org_dir="$repo_root/org"

# Ensure docs/ exists
mkdir -p "$docs_dir"

# Clear docs/ contents
find "$docs_dir" -mindepth 1 -delete

# Copy asset directories into docs/
for asset in css config img; do
  if [ -d "$repo_root/$asset" ]; then
    cp -r "$repo_root/$asset" "$docs_dir/"
  fi
done

# Export each org/*.org file to HTML in repo root, then move to docs/
for org_file in "$org_dir"/*.org; do
  [ -f "$org_file" ] || continue
  base_name=$(basename "$org_file" .org)
  html_file="$repo_root/${base_name}.html"

  echo "Exporting $org_file -> $docs_dir/${base_name}.html"

  # Export to HTML (respects #+EXPORT_FILE_NAME in the Org file)
  emacs --batch \
        --visit="$org_file" \
        --eval '(org-html-export-to-html)' \
        --kill

  # Move resulting HTML into docs/
  if [ -f "$html_file" ]; then
    mv "$html_file" "$docs_dir/"
  else
    echo "Warning: Expected HTML not created: $html_file" >&2
  fi
done

echo "Exported to: $docs_dir"
