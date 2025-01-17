pipeline {
	agent {
		label 'backend && mörkö'
	}
	stages {
		stage('Load environment') {
			steps {
				script {
					withEnv(readFile('.env').split('\n') as List) {
						env.DOCKER_IMAGE = "tmp/${STACK_NAME}:latest"

						stage('Setup dependencies') {
							callShell "docker pull faulo/farah:${PHP_VERSION}"

							env.DOCKER_OS_TYPE = callShellStdout 'docker info --format {{.OSType}}'
							env.DOCKER_WORKDIR = callShellStdout 'docker image inspect faulo/farah:${PHP_VERSION} --format={{.Config.WorkingDir}}'
						}
						stage('Build image') {
							callShell "docker build -t ${DOCKER_IMAGE} --build-arg PHP_VERSION=${PHP_VERSION} ."
						}
						stage ('Run tests') {
							docker.image(env.DOCKER_IMAGE).inside {
								callShell 'composer install --no-interaction'

								try {
									callShell 'composer exec phpunit -- --log-junit report.xml'
								} catch(e) {
									currentBuild.result = "UNSTABLE"
								}

								junit 'report.xml'
							}
						}
						stage ('Deploy container') {
							callShell "docker stack deploy ${STACK_NAME} --detach=false --prune --resolve-image=changed -c=.jenkins/docker-compose-${DOCKER_OS_TYPE}.yml"

							def services = callShellStdout("docker stack services ${STACK_NAME} --format '{{ .Name }}'").split("\n")

							services.each { service ->
								stage("Service: ${service}") {
									def tasks = callShellStdout("docker service ps ${service} --format '{{ .ID }} {{ .CurrentState }}'")
											.split("\n")
											.findAll { it.contains("Running") }
											.collect { it.split(" ")[0] }

									tasks.each {  task ->
										echo "  Task: ${task}"

										def imageId = callShellStdout "docker service inspect ${service} --format '{{ index .Spec.Labels \"com.docker.stack.image\" }}'"
										echo "    Image: ${imageId}"

										def repos = callShellStdout "docker image inspect ${imageId} --format '{{ index .RepoDigests  }}'"

										if (repos == "[]") {
											def containerId = callShellStdout "docker inspect ${task} --format '{{ .Status.ContainerStatus.ContainerID }}'"
											echo "    Container: ${containerId}"

											def currentDigest = callShellStdout "docker inspect ${containerId} --format '{{ .Image }}'"
											echo "    Aktueller Digest: ${currentDigest}"

											def expectedDigest = callShellStdout "docker image inspect ${imageId} --format '{{ .Id }}'"
											echo "    Erwarteter Digest: ${expectedDigest}"

											// Überprüfen, ob ein Update nötig ist
											if (currentDigest != expectedDigest) {
												callShell "docker service update --image=${imageId} --detach=false ${service} --force"
											}
										} else  {
											callShell "docker service update --image=${imageId} --detach=false ${service}"
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}