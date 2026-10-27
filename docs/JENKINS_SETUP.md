# Jenkins setup and execution

Student: Ziyayev Olzhas | Group: IT2-2302

## Agent prerequisites

Use an existing authorized Jenkins controller and a Linux build agent with Git,
JDK 21, Docker CLI and access to its Docker daemon. The agent needs outbound
access to GitHub, Gradle, Maven Central and the container registry. The project
includes a Gradle Wrapper; a globally installed Gradle is unnecessary.

Assign the agent the label `linux-docker-java21`. Configure its JAVA_HOME/PATH
to JDK 21. Verify `java -version` and `docker version` as the agent user. Docker
daemon access is privileged, so use a dedicated trusted educational agent.

Required plugins: Pipeline, Pipeline: Declarative, Git, Credentials Binding and
JUnit. Suggested Jenkins plugins may already include these.

## Main job

1. Create a Pipeline job named `Ziyayev_Olzhas_Student_API`.
2. Set Definition to **Pipeline script from SCM** and SCM to **Git**.
3. Repository URL: `https://github.com/olzhsz/ziyayev-olzhas-student-api.git`.
4. Use branch specifier `*/main` and Script Path `Jenkinsfile`.
5. Public repositories can be cloned without a token. For a private repository,
   save an appropriate GitHub token under Jenkins Credentials and select its
   credentials ID in the SCM configuration. Never hard-code the token.
6. Save and run **Build Now** once. Confirm all five stages succeed.
7. Save the console output and screenshot of the stage/build history. The log
   must show `Student: Ziyayev Olzhas | Group: IT2-2302`.

`checkout scm` uses this job's repository, branch and credentials. A failed `sh`
command returns a nonzero exit code and fails the stage. The pipeline has no
`catchError` or ignored failure around builds/tests, so later stages are skipped.
JUnit reports and the generated JAR are retained in Jenkins.

## Controlled failure and fix

Use a second job named `Ziyayev_Olzhas_Student_API_Demo`, configured identically
but pointed at `*/feature/ziyayev-olzhas-ci-demo`. The delivered branch has two
commits: `controlledFailure=true` in `gradle.properties`, then its correction to
`false`. `PipelineSafetyTest` reads this property and fails intentionally when true.

To show the historical failing revision without changing main:

1. Find the failing commit with `git log --oneline feature/ziyayev-olzhas-ci-demo`.
2. Set the demo job SCM Branch Specifier to that full commit hash.
3. Run the demo job. Build/assemble succeeds, Test fails and Docker Build/Verify
   do not execute. Save the console, assertion message and JUnit report.
4. Set the branch specifier back to `*/feature/ziyayev-olzhas-ci-demo`, whose tip
   contains the fix. Run it again and save the successful result.

Do not merge the intentionally failing revision into main. The local Gradle test
demonstration, if available, is evidence of Gradle behavior, not of Jenkins execution.

## Automatic trigger

The Jenkinsfile configures `pollSCM('H/2 * * * *')`. After the first manual build,
Jenkins polls the SCM every two minutes. Make a genuine README change on main:

```bash
git switch main
# Edit README.md to add a short demonstration note.
git add README.md
git commit -m 'Ziyayev Olzhas: document the automatic Jenkins trigger'
git push origin main
```

Wait for polling, then record the build cause (SCM change), console output and
build history. Polling requires Jenkins to remain running and able to access GitHub.
No webhook or public Jenkins endpoint is needed for this polling option.

## Troubleshooting

| Failure | Check |
| --- | --- |
| Agent stays queued | Agent is online and its label matches |
| Checkout fails | Repository URL, branch and selected credentials |
| Gradle cannot start | `java -version`, JAVA_HOME, executable bit and LF line endings |
| Dependencies fail | Agent network access and Gradle console error |
| Test stage fails | First assertion error and JUnit report |
| Docker Build fails | Dockerfile line, daemon availability, disk space, registry access |
| Verify fails | Exact image name/tag and same Docker daemon across stages |
| No automatic build | Initial manual run, polling log, pushed commit and branch |
