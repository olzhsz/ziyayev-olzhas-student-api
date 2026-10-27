#!/bin/bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
if [[ "$(uname -s)" != Linux ]]; then
    printf 'Run this evidence demonstration on Linux or WSL, not Git Bash.\n' >&2
    exit 1
fi
mkdir -p scripts logs backups src evidence
touch logs/Ziyayev_Olzhas_system_report.log
exec > >(tee evidence/Ziyayev_Olzhas_linux_terminal.txt) 2>&1
printf 'Linux demonstration: Ziyayev Olzhas | IT2-2302\n'
printf '\nProject tree:\n'
if command -v tree >/dev/null; then
    tree -a -I '.git|.gradle|build'
else
    find . -maxdepth 3 -not -path './.git/*' -not -path './.gradle/*' -not -path './build/*' | sort
fi
for required in Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md scripts/Ziyayev_Olzhas_system_report.sh; do
    test -f "$required"
    printf 'Verified: %s\n' "$required"
done
chmod 744 scripts/Ziyayev_Olzhas_system_report.sh
./scripts/Ziyayev_Olzhas_system_report.sh
cp README.md backups/Ziyayev_Olzhas_README_backup.md
printf '\nPermissions (owner rwx; group r--; other r--):\n'
ls -l scripts/Ziyayev_Olzhas_system_report.sh backups/Ziyayev_Olzhas_README_backup.md
test "$(stat -c '%a' scripts/Ziyayev_Olzhas_system_report.sh)" = 744
cmp README.md backups/Ziyayev_Olzhas_README_backup.md
printf '\nBackup contents:\n'; cat backups/Ziyayev_Olzhas_README_backup.md
printf '\nRunning processes:\n'; ps aux
printf '\nJava processes:\n'
if ! pgrep -af '[j]ava'; then printf 'No Java process is running.\n'; fi
printf '\nLast five report lines:\n'; tail -n 5 logs/Ziyayev_Olzhas_system_report.log
grep -n 'Ziyayev' logs/Ziyayev_Olzhas_system_report.log | tee logs/Ziyayev_Olzhas_log_analysis.txt
printf '\n> creates or truncates a file; >> creates or appends to a file.\n'
