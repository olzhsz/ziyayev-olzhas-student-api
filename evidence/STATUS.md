# Evidence status

Student: Ziyayev Olzhas | Group: IT2-2302 | Updated: 28 October 2026

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

## Verified in the student's WSL environment

The following results were reviewed from real screenshots saved separately in
the submission workspace. Screenshot files are not included in this repository.
The earlier Windows logs above remain separate from these Linux demonstrations.

- **Linux:** Ubuntu 26.04.1 under WSL 2, user `olzhik`. The personal system
  report, process listing, disk/memory information, directory tree, `tail` and
  name analysis were demonstrated. The script permission was `744`; the README
  backup was compared successfully with `diff -s` (Screens 8, 9 and 11).
- **Docker/PostgreSQL:** Docker Desktop WSL integration and Docker access without
  `sudo` were demonstrated. The multi-stage image was built; the application and
  healthy PostgreSQL container ran successfully. CRUD checks passed, including
  expected validation/not-found responses; a saved record survived restarts
  (Screens 15, 19 and 20).
- **Version rebuild:** image `v1.0.1-ziyayev-olzhas` was built in the Ubuntu clone.
  The running application's actuator information reported version `1.0.1`, API
  checks passed, and the existing database record remained (Screens 22 and 23).
  This runtime version demonstration was performed in the Ubuntu clone; the
  committed source version and the Jenkins image tag remain unchanged.
- **Jenkins:** main job `Ziyayev_Olzhas_Student_API` build #1 succeeded (Screen 28).
  Demo job `Ziyayev_Olzhas_Student_API_Demo` build #2 checked out
  `7c39299c2cacdf6636305014cd78529294568d21`: Checkout and Build succeeded, Test
  failed in `PipelineSafetyTest`, and Docker Build/Verify were skipped
  (Screens 29 and 30).
- **Jenkins recovery:** Demo build #3 checked out fixed revision
  `d75aab0c27a85544962e334a65c67eca08dc3a7b` from
  `feature/ziyayev-olzhas-ci-demo` and completed successfully with no test errors
  (Screen 31). Demo build #1 had an SCM configuration error and is not the
  controlled test-failure demonstration. Disable Lightweight checkout when
  selecting the failing revision by its full commit hash.

## Automatic trigger verified

- Main build #2 starts with `Started by an SCM change` in its actual console
  (Screen 34). The main job's history shows builds #1, #2 and #3 as successful
  with 11 passing tests (Screen 33).
- Main build #3 checked out the published documentation revision
  `930ebc439a8e5ec12e0f34b698c2dbdc4d3db5fc` and completed successfully
  (Screen 32). This build was started by the user; the automatic-trigger
  evidence is build #2, not build #3.
- The English submission report includes the reviewed screenshot evidence.

No screenshots or output are invented. See `docs/DEMONSTRATION.md` for the
demonstration commands and `docs/JENKINS_SETUP.md` for the pipeline setup.
