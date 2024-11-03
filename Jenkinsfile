pipeline {
	agent {
		label 'backend && mörkö'
	}
	stages {
		stage('Load environment') {
			steps {
				script {
					stage ('Pull image') {
						sh "docker image pull faulo/farah:8.3"
					}
					stage ('Run tests') {
						docker.image("faulo/farah:8.3").inside {
							sh 'composer update --no-interaction'

							try {
								sh 'composer exec phpunit -- --log-junit report.xml'
							} catch(e) {
								currentBuild.result = "UNSTABLE"
							}

							junit 'report.xml'
							stash name:'lock', includes:'composer.lock'
						}
					}
					stage ('Deploy stack') {
						dir("/var/vhosts/historischer-spieleabend") {
							checkout scm
							unstash 'lock'

							sh "mkdir -p assets src html data log"
							sh "chmod 777 . assets src html data log"

							def service = "historischer-spieleabend_historischer-spieleabend"
							sh "docker stack deploy historischer-spieleabend --detach=true --prune --resolve-image=never -c=docker-compose.yml"
							sh "docker service update --force " + service
						}
					}
				}
			}
		}
	}
}