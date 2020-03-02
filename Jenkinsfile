//
// Copyright (c) 2019 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

def image
def logImage_amd64
def logImage_arm64
def mavenSettings = env.SILO == 'sandbox' ? 'sandbox-settings' : 'ci-build-images-settings'

pipeline {
    agent {
        label 'centos7-docker-4c-2g'
    }

    options {
        timestamps()
    }

    stages {
        stage('LF Prep') {
            steps {
                edgeXSetupEnvironment()
            }
        }

        stage('Build Docker Image') {
            parallel {
                stage('amd64') {
                    agent {
                        label 'centos7-docker-4c-2g'
                    }
                    stages {
                        stage('Docker Build') {
                            steps {
                                script {
                                    edgeXDockerLogin(settingsFile: mavenSettings)
                                    image = docker.build('edgex-lftools', '-f Dockerfile .')
                                    logImage_amd64 = docker.build('edgex-lftools-log-publisher', '-f Dockerfile.logs-publish .')
                                }
                            }
                        }

                        stage('Docker Push') {
                            when { expression { env.GIT_BRANCH == 'lftools' } }
                            steps {
                                script {
                                    docker.withRegistry("https://${env.DOCKER_REGISTRY}:10003") {
                                        image.push("latest")
                                        image.push(env.GIT_COMMIT)
                                        image.push("0.31.0-centos7")
                                    }

                                    docker.withRegistry("https://${env.DOCKER_REGISTRY}:10003") {
                                        logImage_amd64.push("alpine")
                                        logImage_amd64.push("0.31.0-alpine")
                                        logImage_amd64.push("amd64")
                                        logImage_amd64.push("x86_64")
                                    }
                                }
                            }
                        }
                    }
                }

                stage('arm64') {
                    agent {
                        label 'ubuntu18.04-docker-arm64-4c-16g'
                    }
                    stages {
                        stage('Docker Build') {
                            steps {
                                script {
                                    edgeXDockerLogin(settingsFile: mavenSettings)
                                    logImage_arm64 = docker.build('edgex-lftools-log-publisher', '-f Dockerfile.logs-publish .')
                                }
                            }
                        }

                        stage('Docker Push') {
                            when { expression { env.GIT_BRANCH == 'lftools' } }
                            steps {
                                script {
                                    docker.withRegistry("https://${env.DOCKER_REGISTRY}:10003") {
                                        logImage_arm64.push("arm64")
                                        logImage_arm64.push("aarch64")
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }

        stage('Clair Image Scan') {
            when { expression { env.GIT_BRANCH == 'lftools' } }
            steps {
                edgeXClair("${env.DOCKER_REGISTRY}:10003/edgex-lftools:0.31.0-centos7")
                edgeXClair("${env.DOCKER_REGISTRY}:10003/edgex-lftools-log-publisher:amd64")
                edgeXClair("${env.DOCKER_REGISTRY}:10003/edgex-lftools-log-publisher:arm64")
            }
        }
    }

    post {
        always {
            edgeXInfraPublish()
        }
    }
}