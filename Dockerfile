# based on: https://github.com/trion-development/docker-ng-cli/blob/master/Dockerfile
# AND based on: https://jtreminio.com/blog/running-docker-containers-as-current-host-user/#ok-so-what-actually-works

# Insights
# Knowing how to create this Dockerfile really does require you to understand your
# development environment and some developers may just want to get to it

# select latest version of Node.js stretch version
# ToDo: Is stretch the best version to use
FROM node:stretch

# define default values (can be overridden on command line)
ARG NG_CLI_VERSION=7.1.2
ARG USER_HOME_DIR="/tmp"
ARG APP_DIR="/app"
ARG USER_ID=1000
ARG GROUP_ID=1000
# ToDo: It would be nice to have this be more generic
ARG GIT_USER_EMAIL="scott.fredericksen@gmail.com"
ARG GIT_USER_NAME="Scott Fredericksen"

ENV NODE_ENV=development
ENV NPM_CONFIG_LOGLEVEL warn
ENV HOME "$USER_HOME_DIR"

# ToDo: Verify that all of this is still required for what I'm tring to do
RUN userdel -f node &&\
   if getent group node; then groupdel node; fi &&\
   groupadd -g ${GROUP_ID} node &&\
   useradd -l -u ${USER_ID} -g node node &&\
   install -d -m 0755 -o node -g node /home/node &&\
   chown -R node /usr/local/lib /usr/local/include /usr/local/share /usr/local/bin &&\
   (cd "$USER_HOME_DIR"; su node -c "npm install -g @angular/cli@$NG_CLI_VERSION; npm install -g serverless; npm install -g yarn; chmod +x /usr/local/bin/yarn; npm cache clean --force") &&\
   apt-get update &&\
   apt-get install -y python &&\
   apt-get install -y python-pip &&\
   pip install awscli &&\
   git config --global user.email ${GIT_USER_EMAIL} &&\
   git config --global user.name ${GIT_USER_NAME}
   
WORKDIR $APP_DIR
EXPOSE 9292 
USER $USER_ID
