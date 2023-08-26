FROM jenkins/jenkins:lts-jdk11
MAINTAINER lirond101@gmail.com
USER root

COPY --chown=jenkins:jenkins jenkins-plugins.txt /usr/share/jenkins/ref/jenkins-plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/jenkins-plugins.txt

# copy seedjob
COPY --chown=jenkins:jenkins kandula-pipeline/config.xml /usr/share/jenkins/ref/jobs/kandula-pipeline/config.xml
COPY --chown=jenkins:jenkins rollout-app/config.xml /usr/share/jenkins/ref/jobs/rollout-app/config.xml

# allows to skip Jenkins setup wizard
# ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Jenkins runs all groovy files from init.groovy.d dir
# COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

VOLUME /var/jenkins_home
USER jenkins

RUN ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
