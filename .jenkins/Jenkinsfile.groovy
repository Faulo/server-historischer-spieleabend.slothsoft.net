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
							callShell "docker stack deploy ${STACK_NAME} --detach=false --prune --resolve-image=never -c=.jenkins/docker-compose-${DOCKER_OS_TYPE}.yml"
							callShell "docker service update --image ${DOCKER_IMAGE} --detach=false ${STACK_NAME}_frontend"
						}
					}
				}
			}
		}
	}
}