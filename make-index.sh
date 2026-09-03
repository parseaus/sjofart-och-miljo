#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")" && pwd)"
docs_dir="$repo_root/docs"

# Base template
cat > "$docs_dir/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="sv">
<head>
<meta charset="utf-8"/>
<title>Presentationer</title>
<style>
  body {
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    max-width: 60rem;
    margin: 2rem auto;
    padding: 0 1rem;
    line-height: 1.5;
  }
  h1 { margin-bottom: 1.5rem; }
  ul { list-style: disc; padding-left: 1.5rem; }
  li { margin-bottom: 0.5rem; }
  a { text-decoration: none; color: #0066cc; }
  a:hover { text-decoration: underline; }
</style>
</head>
<body>
<h1>Presentationer</h1>
<ul>
<!-- ITEMS -->
</ul>
</body>
</html>
EOF

# Replace <!-- ITEMS --> with actual list items
tmp_index=$(mktemp)

awk -v docs_prefix="$docs_dir/" '
  /<!-- ITEMS -->/ {
    cmd = "ls -1 " docs_prefix "*.html 2>/dev/null | grep -v index.html | sort"
    while ((cmd | getline file) > 0) {
      base = file
      sub("^" docs_prefix, "", base)   # strip directory
      title = base
      sub(/\.html$/, "", title)        # default title

      # Try to extract <title> from HTML
      title_cmd = "grep -m1 \"<title>\" \"" file "\" | sed -n \"s/.*<title>\\(.*\\)<\\/title>.*/\\1/p\""
      if ((title_cmd | getline t) > 0 && t != "") {
        title = t
      }
      close(title_cmd)

      printf "  <li><a href=\"%s\">%s</a></li>\n", base, title
    }
    close(cmd)
    next
  }
  { print }
' "$docs_dir/index.html" > "$tmp_index"

mv "$tmp_index" "$docs_dir/index.html"

echo "Generated $docs_dir/index.html with links to all HTML presentations."
