#!/bin/bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_dir"
test -f .env || { printf 'Copy .env.example to .env and set a password first.\n' >&2; exit 1; }
mkdir -p evidence
exec > >(tee evidence/Ziyayev_Olzhas_docker_terminal.txt) 2>&1
printf 'Docker demonstration: Ziyayev Olzhas | IT2-2302\n'
docker compose config --quiet
docker compose up -d --build
docker compose ps
image_ref="$(docker compose images -q app)"
docker image inspect "$image_ref" --format 'Image={{.Id}} Size={{.Size}} Created={{.Created}}'
docker compose logs --tail=60 app
# Selected fields only: full docker inspect would print database passwords.
docker inspect ziyayev-olzhas-student-api --format 'Name={{.Name}} Image={{.Config.Image}} User={{.Config.User}} Networks={{json .NetworkSettings.Networks}}'
docker compose exec -T app sh -c 'id; java -version; pwd'
BASE_URL="${BASE_URL:-http://localhost:8080/api/ziyayev-olzhas}" bash scripts/test_api.sh
printf '\nCreate a dedicated record for the PostgreSQL persistence check:\n'
record="$(curl --fail -sS --max-time 20 -X POST "${BASE_URL:-http://localhost:8080/api/ziyayev-olzhas}/students" \
    -H 'Content-Type: application/json' \
    --data '{"fullName":"Ziyayev Olzhas Persistence","groupName":"IT2-2302","email":"persistence@example.com"}')"
printf '%s\n' "$record"
persist_id="$(printf '%s' "$record" | sed -nE 's/.*"id":([0-9]+).*/\1/p')"
[[ "$persist_id" =~ ^[0-9]+$ ]]
docker compose stop app
docker compose start app
docker compose restart db app
ready=false
for ((attempt=1; attempt<=90; attempt++)); do
    if curl --fail -sS --max-time 3 "${BASE_URL:-http://localhost:8080/api/ziyayev-olzhas}/students/$persist_id" > evidence/Ziyayev_Olzhas_persistence.json; then
        ready=true; break
    fi
    sleep 2
done
[[ "$ready" == true ]]
grep -q 'Ziyayev Olzhas Persistence' evidence/Ziyayev_Olzhas_persistence.json
cat evidence/Ziyayev_Olzhas_persistence.json
printf '\nPostgreSQL record survived database/application restart.\n'
docker compose ps
printf '\nFor version rebuild, follow section 3.3 in docs/DEMONSTRATION.md.\n'
