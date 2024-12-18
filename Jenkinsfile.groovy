pipeline {
	agent {
		label 'backend && mörkö'
	}
	stages {
		stage('Load environment') {
			steps {
				script {
					withEnv(readFile('.env').split('\n') as List) {
						stage('Build custom image') {
							callShell "docker compose build --pull"
						}
						stage ('Run tests') {
							docker.image("tmp/$STACK_NAME:latest").inside {
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
							callShell "docker stack deploy ${STACK_NAME} --detach=true --prune --resolve-image=never -c=docker-compose-linux.yml"
							callShell "docker service update --force ${STACK_NAME}_farah"
						}
					}
				}
			}
		}
	}
}