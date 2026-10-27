#!/bin/bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$project_dir/evidence"
exec > >(tee "$project_dir/evidence/Ziyayev_Olzhas_api_tests.txt") 2>&1
base="${BASE_URL:-http://localhost:8080/api/ziyayev-olzhas}"
base="${base%/}"
tmp_dir="$(mktemp -d)"
# Remove only the two explicitly named temporary files created by this script.
trap 'rm -f -- "$tmp_dir/body" "$tmp_dir/headers"; rmdir -- "$tmp_dir"' EXIT
printf 'API verification: Ziyayev Olzhas | IT2-2302\nURL: %s\n' "$base"
ready=false
for ((attempt=1; attempt<=90; attempt++)); do
    if curl -fsS --max-time 3 "$base" >/dev/null 2>&1; then ready=true; break; fi
    sleep 2
done
[[ "$ready" == true ]] || { printf 'Application did not become ready\n' >&2; exit 1; }
request() {
    local expected="$1" method="$2" path="$3" data="${4:-}" status
    local args=(-sS --max-time 20 -X "$method" -D "$tmp_dir/headers" -o "$tmp_dir/body" -w '%{http_code}')
    if [[ -n "$data" ]]; then args+=(-H 'Content-Type: application/json' --data "$data"); fi
    status="$(curl "${args[@]}" "$base$path")"
    printf '\n%s %s -> HTTP %s (expected %s)\n' "$method" "$path" "$status" "$expected"
    cat "$tmp_dir/body"; printf '\n'
    [[ "$status" == "$expected" ]] || { printf 'Unexpected HTTP status\n' >&2; exit 1; }
}
request 200 GET ''
request 201 POST /students '{"fullName":"Ziyayev Olzhas","groupName":"IT2-2302","email":"olzhas@example.com"}'
student_id="$(tr -d '\r' < "$tmp_dir/headers" | sed -nE 's|^[Ll]ocation: .*/students/([0-9]+)$|\1|p')"
[[ "$student_id" =~ ^[0-9]+$ ]] || { printf 'Missing student ID in Location header\n' >&2; exit 1; }
request 200 GET /students
request 200 GET "/students/$student_id"
request 200 PUT "/students/$student_id" '{"fullName":"Ziyayev Olzhas Updated","groupName":"IT2-2302","email":"olzhas.updated@example.com"}'
grep -q 'Ziyayev Olzhas Updated' "$tmp_dir/body"
request 400 POST /students '{"fullName":"","groupName":"","email":"invalid"}'
request 204 DELETE "/students/$student_id"
request 404 GET "/students/$student_id"
request 404 PUT "/students/$student_id" '{"fullName":"Ziyayev Olzhas","groupName":"IT2-2302","email":"olzhas@example.com"}'
request 404 DELETE "/students/$student_id"
printf '\nAll API checks passed.\n'
