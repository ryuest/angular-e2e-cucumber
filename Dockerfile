FROM jenkins/jenkins:lts

USER root

COPY blueocean/target/plugins /usr/share/jenkins/ref/plugins/

RUN for f in /usr/share/jenkins/ref/plugins/*.hpi; do mv "$f" "${f%%hpi}jpi"; done
RUN install-plugins.sh antisamy-markup-formatter matrix-auth # for security, you know

# Force use of locally built blueocean plugin
RUN for f in /usr/share/jenkins/ref/plugins/blueocean-*.jpi; do mv "$f" "$f.override"; done

# let scripts customize the reference Jenkins folder. Used in bin/build-in-docker to inject the git build data
COPY docker/ref /usr/share/jenkins/ref

RUN apt-get install -y curl \
  && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
  && apt-get install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh
  
USER jenkins