# DevOps midterm demonstration

Student: Ziyayev Olzhas | Group: IT2-2302 | GitHub: https://github.com/olzhsz

Commands below are demonstration instructions, not claims that they have already
run. See `evidence/STATUS.md` for actual verification. Run commands from the project
root. Use Linux/WSL for Part 1 and a Docker-capable host for Parts 3–4.

## Part 1 — Linux administration

### 1.1 Project structure

The delivered project already contains all required files. To demonstrate creating
the directories in a terminal, run these idempotent commands on Linux:

```bash
mkdir -p scripts logs backups src evidence
touch logs/Ziyayev_Olzhas_system_report.log
tree -a -I '.git|.gradle|build'
```

Run the complete demonstration and save its terminal output:

```bash
bash scripts/linux_demo.sh
```

### 1.2 System report

`scripts/Ziyayev_Olzhas_system_report.sh` prints student identity, timestamp,
username, OS, kernel, CPU, memory, disk usage and available space. `tee` writes
the same output to `logs/Ziyayev_Olzhas_system_report.log`.

### 1.3 Permissions and backup

```bash
chmod 744 scripts/Ziyayev_Olzhas_system_report.sh
./scripts/Ziyayev_Olzhas_system_report.sh
cp README.md backups/Ziyayev_Olzhas_README_backup.md
ls -l scripts/Ziyayev_Olzhas_system_report.sh backups/Ziyayev_Olzhas_README_backup.md
cmp README.md backups/Ziyayev_Olzhas_README_backup.md
cat backups/Ziyayev_Olzhas_README_backup.md
```

Expected permission text is `-rwxr--r--`: owner can read/write/execute, group and
others can only read. `755` would additionally allow others to execute and would
not match this assignment. Use the WSL/Linux filesystem, such as `~/projects`,
when recording permission evidence; Windows-mounted NTFS can emulate permissions.

### 1.4 Process and log analysis

```bash
ps aux
pgrep -af '[j]ava' || echo 'No Java process is running'
tail -n 5 logs/Ziyayev_Olzhas_system_report.log
grep -n 'Ziyayev' logs/Ziyayev_Olzhas_system_report.log > logs/Ziyayev_Olzhas_log_analysis.txt
cat logs/Ziyayev_Olzhas_log_analysis.txt
```

`>` creates or overwrites a file. `>>` creates or appends to a file.

## Part 2 — Git and GitHub

### 2.1 Repository initialization and identity

The delivered repository contains an actual local history. Inspect it with:

```bash
git config --local --get user.name
git config --local --get user.email
git status
git log --graph --oneline --decorate --all
```

For a completely new copy without `.git`, initialize it with `git init -b main`,
configure `git config user.name 'Ziyayev Olzhas'` and your GitHub email, then
`git add .` and `git commit -m 'Initial commit: Ziyayev Olzhas Student API'`.
Do not reinitialize or rewrite the delivered history.

### 2.2 CRUD feature branch

`feature/ziyayev-olzhas-crud` introduces the update operation in two meaningful
commits: implementation, then regression tests and README documentation. The merge
into `main` preserves the branch history. Show:

```bash
git log --oneline feature/ziyayev-olzhas-crud
git show --stat feature/ziyayev-olzhas-crud
git log --merges --oneline main
```

### 2.3 Documentation conflict

`feature/ziyayev-olzhas-documentation` and `main` both modified the
`Documentation status:` line. The actual conflict transcript is saved at
`evidence/git-conflict.txt`. The resolution combines the API and DevOps descriptions.
Explain the markers `<<<<<<<`, `=======`, `>>>>>>>`, then show:

```bash
git show --cc --format=fuller <resolution-commit>
git log --graph --oneline --decorate --all
```

Replace `<resolution-commit>` with the merge hash visible in `git log`.

### 2.4 Remote repository and tag

The published GitHub repository is `olzhsz/ziyayev-olzhas-student-api`.
It contains main, the three personal feature branches and the release tag.
The commands below also explain how to publish future changes or a new copy.
An `origin` URL alone does not prove that a repository exists or has been pushed.
If the GitHub repository has not been created, create an empty repository in your
account with that exact name; do not initialize a second README or license.
Authenticate locally through Git Credential Manager or GitHub CLI. Never paste
a token into the report or commit it.

```bash
git remote -v
git push -u origin main
git push origin feature/ziyayev-olzhas-crud feature/ziyayev-olzhas-documentation feature/ziyayev-olzhas-ci-demo
git push origin v1.0-ziyayev-olzhas
git branch -avv
git tag -n
git ls-remote --heads --tags origin
```

If `origin` is absent: `git remote add origin https://github.com/olzhsz/ziyayev-olzhas-student-api.git`.
Local Git metadata is included in the delivery ZIP so the merge history is retained.

## Part 3 — Docker and Docker Compose

### 3.1 Build and image evidence

```bash
cp .env.example .env
# Set your own POSTGRES_PASSWORD in .env before continuing.
docker build -t ziyayev-olzhas-student-api:v1.0-ziyayev-olzhas .
docker image ls ziyayev-olzhas-student-api
docker image inspect ziyayev-olzhas-student-api:v1.0-ziyayev-olzhas --format 'Size={{.Size}} Created={{.Created}}'
```

The official Temurin JDK 21 build stage runs the Gradle Wrapper and tests. The
runtime stage uses a JRE and runs as an unprivileged user. Only the application
JAR is copied into the final image. Port 8080 matches Spring Boot configuration.

### 3.2 Compose and database readiness

```bash
docker compose config --quiet
docker compose up -d --build
docker compose ps
docker compose logs --tail=80 app
```

PostgreSQL is reachable as `db:5432` on `ziyayev-olzhas-network`. Inside the app
container, `localhost` points to that app container, not to PostgreSQL. Compose
waits for the database health check. The named volume
`ziyayev-olzhas-postgres-data` stores database files. PostgreSQL is not exposed on
a host port. The API is available locally at
`http://localhost:8080/api/ziyayev-olzhas`.

### 3.3 Container management, version rebuild and persistence

Run `bash scripts/docker_demo.sh` for container/image details, selected inspection
fields, a command inside the container, stop/start, CRUD tests and a real
database/application restart with a persisted record check. If APP_PORT was changed,
set `BASE_URL=http://localhost:YOUR_PORT/api/ziyayev-olzhas` before running scripts.
Do not record full `docker inspect` or full `docker compose config` output because
they can expose environment secrets. The scripts print only selected fields.

For the required rebuild after a version change, edit `build.gradle`:

```groovy
version = '1.0.1'
```

Then run:

```bash
docker build -t ziyayev-olzhas-student-api:v1.0.1-ziyayev-olzhas .
IMAGE_TAG=v1.0.1-ziyayev-olzhas docker compose up -d --no-build app
curl --fail http://localhost:8080/actuator/info
```

The build metadata should show `1.0.1`. Preserve the local `.env` file and named
volume. `docker compose down` removes containers and network but retains the named
volume. Adding `-v` removes the database volume and its records; it is not part of
the demonstration.

### 3.4 API verification

```bash
bash scripts/test_api.sh
```

The script checks create (201), list (200), get by ID (200), update (200), invalid
data (400), delete (204) and subsequent missing-record operations (404). It
captures the generated ID from the Location header instead of assuming ID 1.
Output is saved to `evidence/Ziyayev_Olzhas_api_tests.txt`.
On Windows, the same HTTP checks can be run without a Bash shell:
`py scripts/test_api.py`. Its log is `evidence/Ziyayev_Olzhas_api_python.txt`.
The supplied local log used an isolated H2 demonstration runtime on port 18080;
rerun against the Compose API on port 8080 for PostgreSQL/container evidence.

## Part 4 — Jenkins CI/CD

Follow `docs/JENKINS_SETUP.md`. Job name: `Ziyayev_Olzhas_Student_API`.
Pipeline stages: Checkout → Build → Test → Docker Build → Verify.

The job uses SCM polling every two minutes after its first manual build. Make a
new commit, push it, then capture the automatic build cause and console log.
`feature/ziyayev-olzhas-ci-demo` contains a controlled failing-test commit followed
by a fix. Use only a separate demonstration job/branch for this exercise.

CI integrates code and runs automated build/tests. Continuous Delivery keeps
validated artifacts ready for a human-approved release. Continuous Deployment
automatically releases successful changes. This assignment does not require
deployment, and this pipeline does not deploy the application.

## Submission checklist

- GitHub URL that opens and shows the branches, merges and version tag.
- Source code, Gradle Wrapper JAR and scripts.
- Linux terminal log, personal report log, permissions and README backup.
- Actual Docker image details, running containers and CRUD/persistence evidence.
- Jenkins successful build, controlled failed build, fixed build and automatic trigger.
- Word report with real screenshots/logs attached after those demonstrations.

Never substitute sample expected output for actual demonstration evidence.
