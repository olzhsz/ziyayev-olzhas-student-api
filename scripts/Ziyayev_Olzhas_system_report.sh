#!/bin/bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
log_file="$project_dir/logs/Ziyayev_Olzhas_system_report.log"
mkdir -p "$project_dir/logs"
{
    printf 'Student: Ziyayev Olzhas\nGroup: IT2-2302\n'
    printf 'Date and time: '; date --iso-8601=seconds
    printf 'Username: '; whoami
    printf '\nOperating system:\n'
    if [[ -r /etc/os-release ]]; then cat /etc/os-release; else uname -o; fi
    printf '\nKernel version:\n'; uname -r
    printf '\nCPU information:\n'
    if command -v lscpu >/dev/null; then lscpu; else uname -m; fi
    printf '\nMemory information:\n'
    if command -v free >/dev/null; then free -h; else printf 'free is unavailable on this platform\n'; fi
    printf '\nDisk usage:\n'; df -h
    printf '\nAvailable disk space:\n'; df -h --output=source,avail,target
} | tee "$log_file"
