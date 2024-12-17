pipeline {
	agent {
		label 'backend && mörkö'
	}
	stages {
		stage('Load environment') {
			steps {
				script {
					stage ('Pull base image') {
						callShell "docker image pull faulo/farah:8.3"
					}
					stage('Build custom image') {
						callShell "docker-compose build"
					}
					stage ('Run tests') {
						docker.image("faulo/historischer-spieleabend:latest").inside {
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
						// unstash 'lock'
                        callShell "docker-compose up --detach --no-build"
					}
				}
			}
		}
	}
}