# Evidence status

Student: Ziyayev Olzhas | Group: IT2-2302 | Prepared: 27 October 2026

## Verified locally

- Spring Boot source compiles and `bootJar` produces `build/libs/student-api.jar`.
- Gradle verification: **11 tests, 0 failures, 0 errors, 0 skipped**.
- A controlled run of `PipelineSafetyTest` fails as intended when
  `-PcontrolledFailure=true` is passed; the normal build then passes.
- Real HTTP requests against an isolated H2 demonstration runtime pass:
  identity, create, list, retrieve, update, retrieve updated data, invalid input,
  delete, and missing-record GET/PUT/DELETE. This is HTTP/H2 evidence, not Docker
  or PostgreSQL evidence. The temporary runtime used localhost port 18080.
- Real local Git commits and personal feature branches exist.
- The project is published at https://github.com/olzhsz/ziyayev-olzhas-student-api
  with main, the three personal feature branches and the release tag
  `v1.0-ziyayev-olzhas`. Only project files are published; the Word report and
  delivery ZIP are not included.
- The README merge conflict occurred and was resolved in a real merge commit.
- Official Gradle 8.13 wrapper JAR SHA256 matches the published checksum:
  `81a82aaea5abcc8ff68b3dfcb58b3c3c429378efd98e7433460610fecd7ae45f`.
- A portable JDK 21 was downloaded and checksum-verified without changing the
  broken system Java installation.
- The personal README backup was copied and compared successfully on Windows.

## Evidence files

| File | Meaning |
| --- | --- |
| Ziyayev_Olzhas_gradle_build.txt | Actual passing Gradle build/test output |
| Ziyayev_Olzhas_controlled_failure.txt | Actual intentional Gradle test failure |
| Ziyayev_Olzhas_api_python.txt | Actual successful HTTP verification with H2 |
| git-conflict.txt | Actual Git merge-conflict output |
| git-history.txt | Local Git graph, branches, remote and release tag |
| ../build/reports/tests/test/index.html | Final passing HTML test report |

## Pending environment-dependent demonstrations

- **Linux:** WSL/Linux is not installed. Git Bash also cannot start under the
  current environment restrictions. The empty personal log is included; it is
  not a fabricated system report. Run `bash scripts/linux_demo.sh` on Linux/WSL
  to generate the report, analysis, actual permission listing and terminal evidence.
- **Docker/PostgreSQL:** Docker is not installed. Image build, container management,
  PostgreSQL connection/persistence and the version rebuild have not run. Use
  `scripts/docker_demo.sh` after installing Docker and configuring the local `.env`.
- **Jenkins:** no controller/agent was supplied. Pipeline execution, the controlled
  failed/fixed Jenkins builds and SCM-trigger history require a running Jenkins
  setup. A local Gradle failure is not a Jenkins console result.

No screenshots or output are invented for pending demonstrations. See
`docs/DEMONSTRATION.md` for completion instructions.
