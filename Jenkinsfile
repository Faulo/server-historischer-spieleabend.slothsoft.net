pipeline {
	agent {
		label 'backend && mörkö'
	}
	environment {
		SERVICE = 'historischer-spieleabend'
	}
	stages {
		stage('Load environment') {
			steps {
				script {
					stage('Build custom image') {
						callShell "docker compose build --pull"
					}
					stage ('Run tests') {
						docker.image("slothsoft/$SERVICE:latest").inside {
							callShell 'composer install --no-interaction'

							try {
								callShell 'composer exec phpunit -- --log-junit report.xml'
							} catch(e) {
								currentBuild.result = "UNSTABLE"
							}

							junit 'report.xml'
							// stash name:'lock', includes:'composer.lock'
						}
					}
					stage ('Deploy container') {
						callShell "docker stack deploy ${SERVICE} --detach=true --prune --resolve-image=never -c=docker-compose-linux.yml"
						callShell "docker service update --force ${SERVICE}_farah"
					}
				}
			}
		}
	}
}