FROM openjdk:8-jdk

ENV SONAR_RUNNER_HOME /usr/local/sonar-scanner
ENV SONAR_VERSION 3.3.0.1492

USER root

RUN apt-get update \
    && apt-get install -y build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_VERSION}-linux.zip && \
    unzip sonar-scanner-cli-${SONAR_VERSION}-linux.zip && \
    mv sonar-scanner-${SONAR_VERSION}-linux /usr/local && \
    ln -s /usr/local/sonar-scanner-${SONAR_VERSION}-linux /usr/local/sonar-scanner && \
    ln -s /usr/local/sonar-scanner/bin/sonar-scanner /usr/bin/sonar-scanner && \
    rm -rf sonar-scanner-cli-${SONAR_VERSION}-linux.zip

ENV PATH $PATH:/usr/local/sonar-scanner/bin:/usr/local/apache-maven/bin

RUN  wget -q https://sonarcloud.io/static/cpp/build-wrapper-linux-x86.zip && \
     unzip build-wrapper-linux-x86.zip

RUN  ln -s build-wrapper-linux-x86-64 /usr/local/bin/build-wrapper

ENV PATH $PATH:/usr/local/sonar-scanner/bin:/usr/local/apache-maven/bin
