# DevOps defense questions and answers

Student: Ziyayev Olzhas | IT2-2302

These answers cover the questions in the supplied assignment, combining duplicate
questions. Relate each answer to the actual project during the defense.

## Linux and Bash

1. **What is Linux and why use it in DevOps?** An operating-system kernel used
   in distributions such as Ubuntu. Linux offers scripting, process tools and
   broad server/container support.
2. **What does `pwd` do?** Prints the current working directory.
3. **What is the shebang `#!/bin/bash`?** It tells the OS to execute the script
   with `/bin/bash` when the script is run directly.
4. **How do you make a script executable?** `chmod +x script.sh`. This project
   uses `chmod 744 scripts/Ziyayev_Olzhas_system_report.sh` for the exact task.
5. **What does `chmod` do?** Changes file permission bits. Read=4, write=2,
   execute=1 for owner, group and other users.
6. **What does 755 mean?** Owner rwx, group r-x, others r-x. The assignment asks
   for 744, which gives group/others read-only access.
7. **How do you check available disk space?** `df -h`; `du -sh directory` shows
   the space used by that directory rather than filesystem free space.
8. **What does `free -h` show?** RAM and swap totals, usage and availability
   in readable units, including buffers/cache.
9. **What is a process and how do you list it?** A running program instance
   identified by a PID. Use `ps aux`, `top` or `pgrep -af java`.
10. **Find and terminate a process by PID?** Identify it with `ps`/`pgrep`, then
    `kill PID` for a normal termination request; use `kill -9 PID` only if needed.
11. **Last five lines of a log?** `tail -n 5 logs/Ziyayev_Olzhas_system_report.log`.
12. **Search a word and save matches?** `grep -n 'Ziyayev' logs/Ziyayev_Olzhas_system_report.log > logs/Ziyayev_Olzhas_log_analysis.txt`.
13. **Difference between `>` and `>>`?** `>` creates/truncates the output file;
    `>>` creates/appends. Both redirect standard output unless otherwise specified.
14. **Display hidden files?** `ls -la`.
15. **Pass arguments to Bash?** `bash script.sh first second`; read `$1`, `$2`,
    `$#` and use `"$@"` to preserve all arguments.
16. **Absolute vs relative path?** An absolute path begins from the filesystem
    root, such as `/home/olzhas/project`; a relative path depends on the current directory.
17. **`mkdir` vs `mkdir -p`?** `mkdir` creates a directory; `-p` also creates
    missing parents and accepts existing directories.
18. **`cp` vs `mv`?** Copy creates a separate file; move renames or relocates it.
19. **Create an empty file?** `touch filename` creates one if absent; for an existing
    file it updates timestamps without emptying it. `: > filename` truncates it.

## Git and GitHub

20. **What does `git init` do?** Creates a local Git repository and its metadata.
21. **What does `git add` do?** Stages selected content for the next commit.
22. **What does `git commit` do?** Records the staged snapshot, metadata and message
    in local repository history. It does not upload it.
23. **Working directory, staging area and repository?** The working directory is
    editable files; the index is the proposed next snapshot; the repository stores commits.
24. **What does `git status` show?** Branch state, staged/unstaged changes and
    untracked files; tracking state can also show ahead/behind information.
25. **What is a branch and why use it?** A movable reference to a commit. It lets
    development proceed independently before integration.
26. **Create and switch to a branch?** `git switch -c feature/ziyayev-olzhas-crud`.
27. **What is a merge conflict?** Git cannot automatically reconcile competing
    changes, such as two edits to the same README line.
28. **Resolve a README conflict?** Read both intentions, edit to the intended final
    text, remove markers, `git add README.md`, then `git commit` to finish the merge.
29. **Merge vs rebase?** Merge combines histories, often adding a merge commit.
    Rebase replays commits onto a new base and changes their identities; avoid
    rewriting shared history without agreement.
30. **Git vs GitHub?** Git is distributed version-control software; GitHub hosts
    repositories and provides collaboration features.
31. **What does `git push` do?** Sends local commits and selected refs to a remote.
32. **`git fetch` vs `git pull`?** Fetch updates remote-tracking refs without
    integrating the working branch. Pull fetches and then merges or rebases.
33. **Commit vs tag?** A commit records a snapshot and parent history. A tag names
    a specific revision, usually a release; this project uses `v1.0-ziyayev-olzhas`.
34. **Purpose of `.gitignore`?** Excludes matching untracked files from normal
    staging. It does not remove already tracked secrets from history.
35. **Why meaningful commit messages?** They explain the intent of a change and
    help review, debugging and rollback.
36. **Why keep `.env` and passwords out of Git?** History and remote clones can
    expose secrets. Use environment configuration and a credential store.
37. **Local code differs from GitHub: what next?** Inspect `git status`, protect
    local work with a commit or stash, `git fetch origin`, compare `git log` and
    `git diff` against `origin/main`, then merge/rebase deliberately and resolve conflicts.

## Docker and PostgreSQL

38. **What is Docker and why use it?** A platform for building and running
    isolated containers with repeatable application dependencies and configuration.
39. **Image vs container?** An image is a layered template; a container is an
    execution instance with its own writable layer, processes and runtime settings.
40. **What does `FROM` do?** Chooses the base image for a Dockerfile stage.
41. **`RUN` vs `CMD`?** RUN executes at image build time. CMD supplies the default
    runtime command/arguments and can be overridden. This project starts Java with ENTRYPOINT.
42. **What does `WORKDIR` do?** Sets the working directory for following Dockerfile
    instructions and the container's default working directory.
43. **`COPY` vs `ADD`?** COPY copies build-context files or files from another
    stage. ADD supports extra behaviors such as local archive extraction and remote sources.
44. **What does `EXPOSE` do?** Documents an intended container port; it does not
    publish a host port. Use `-p` or Compose `ports` for publishing.
45. **What is a multi-stage build?** A build with multiple FROM stages. This project
    compiles with a JDK and copies only the JAR into the smaller JRE runtime stage.
46. **What does `docker build` do?** Builds an image from a Dockerfile and context;
    `-t` supplies a repository name and tag.
47. **Run and publish port 8080?** `docker run --rm -p 8080:8080 IMAGE`. This API
    also requires database configuration; Compose supplies it.
48. **View logs?** `docker logs CONTAINER` or `docker compose logs -f app`.
49. **Execute a command inside a running container?** `docker compose exec app sh`
    or `docker exec CONTAINER COMMAND`.
50. **`docker stop` vs `docker rm`?** Stop ends execution while keeping the container.
    Remove deletes the container; persistent named volumes have a separate lifecycle.
51. **What is Compose and its YAML file?** A declarative definition of services,
    networks, volumes and configuration, managed together with `docker compose`.
52. **Network vs volume?** A network connects containers; a volume persists files
    independently of a container's writable layer.
53. **Why a volume for PostgreSQL?** It retains database files when the database
    container is replaced. This project mounts it at `/var/lib/postgresql/data` for PG16.
54. **Why use `db` instead of localhost?** Each container has its own localhost.
    Compose DNS resolves `db` to the PostgreSQL service on the shared network.
55. **What is a health check?** A repeated readiness/status command. PostgreSQL
    uses `pg_isready`; `depends_on: condition: service_healthy` delays app startup.
56. **How to pass database credentials?** Through environment variables resolved
    from a local `.env` or an appropriate secret store. Do not bake passwords into images.
57. **App cannot connect to PostgreSQL: troubleshoot?** Check `docker compose ps`,
    database health and logs, the shared network, host `db`, port 5432, database/user
    names and secret configuration. An initialized volume retains its original users
    and passwords; changing `.env` alone does not reset them.

## Jenkins and CI/CD

58. **What is Jenkins and a job?** Jenkins is an automation server; a job is a
    configured automation task with builds, history, inputs and triggers.
59. **What is a Jenkinsfile?** Version-controlled pipeline code. Here it defines
    Checkout, Build, Test, Docker Build and Verify stages.
60. **Controller vs agent?** The controller coordinates scheduling/configuration;
    agents execute build steps using their tools and workspace.
61. **Purpose of Checkout?** Retrieves the requested source revision from SCM into
    the build workspace using the configured repository and credentials.
62. **Purpose of Build?** Compiles and packages the application; here Gradle assemble.
63. **Purpose of Test?** Runs automated verification and reports failures before
    accepting the artifact or proceeding with later pipeline stages.
64. **Why tests before deployment?** They detect regressions before users receive
    the change; passing tests reduce risk but do not prove the absence of defects.
65. **What is CI?** Frequent integration with automatic builds and tests to detect
    problems early.
66. **CI vs Continuous Deployment?** CI validates integrated changes. Continuous
    Deployment additionally releases every successful qualifying change automatically.
67. **Continuous Delivery vs Continuous Deployment?** Delivery keeps software
    ready to release with a human release decision; Deployment automates that decision.
68. **What happens when a stage fails?** With this Jenkinsfile, a failed shell step
    fails the build and skips subsequent normal stages; applicable post actions still run.
69. **How to stop when tests fail?** Let `./gradlew test` return its nonzero exit
    code through `sh`; do not swallow it using `|| true` or permissive error handling.
70. **What is a trigger and GitHub webhook?** A trigger starts a build. A GitHub
    webhook notifies a configured Jenkins endpoint of repository events. This project
    uses SCM polling instead, so Jenkins checks periodically for changes.
71. **What are Jenkins Credentials?** Stored secrets referenced by ID rather than
    committed literals. Select the credential in SCM for private GitHub checkout.
72. **Declarative vs Scripted Pipeline?** Declarative uses a structured pipeline,
    agent and stages schema; Scripted uses Groovy program flow, often within node blocks.
73. **Why a Docker-capable agent?** `docker build` needs the Docker CLI, access to
    a daemon and sufficient permissions/resources; the Jenkinsfile cannot provide these alone.
74. **What is in console output?** Checkout revision, step commands, tool output,
    failures and timing. Avoid printing secrets or complete environment dumps.
75. **Investigate a Gradle build failure?** Read the first cause in the failed stage,
    inspect test reports when relevant, verify JDK/dependency access and reproduce
    the same Gradle task. Use `--stacktrace` for more detail when needed.
76. **Compile succeeds but Docker Build fails?** Inspect the failing Dockerfile
    instruction, daemon access, base-image download, build context, JAR path and disk
    space. A Java compilation success does not establish Docker daemon availability.

## Project-specific explanation

The personalized endpoint is `/api/ziyayev-olzhas/students`. POST returns 201,
GET/PUT return 200, DELETE returns 204, missing records return 404 and invalid
data returns 400. Test records use Ziyayev Olzhas and IT2-2302. JPA persists data
in PostgreSQL through the `db` service. Automated Java tests use H2, while the
Docker demonstration separately verifies the real PostgreSQL persistence path.
