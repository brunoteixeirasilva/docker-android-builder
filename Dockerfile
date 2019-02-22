FROM beevelop/cordova:latest

LABEL MAINTAINER "Arquia Inovação <desenvolvimento@arquia.com.br>"

# setting the app folder
ENV APP_FOLDER agildash

# reporting position
RUN echo "=> BEGIN: Testing dependencies"

# testing pre-requisites
RUN echo "=> git --version => " && git --version
RUN echo "=> node --v => " && node -v
RUN echo "=> npm --v => " && npm -v
RUN echo "=> cordova -v => " && cordova -v

RUN echo "=> END: Testing dependencies"

# navigating to the app folder
WORKDIR ${APP_FOLDER}

# reporting position
RUN echo "=> Working directory set and navigated to it"

# BEGIN: copying source files

# req'd directories
COPY src src
COPY public public
COPY signkey signkey

# req'd files copy
COPY build.gradle .
COPY build.json .
COPY package.json .
COPY package-lock.json .
COPY config.xml .
COPY server.js .
COPY __prepareForCordova.js .

# END: copying source files

# reporting position
RUN echo "=> Installing project dependencies..."

# installing all project-level dependencies
RUN npm install

# building for cordova usage
RUN npm run build:cordova

# adding platform android for build step
RUN cordova platform add android

# building the app
# RUN cordova build android --release --archs=arm --device --gradleArg=--no-daemon
RUN cordova build android --release --device --buildConfig

# "homepage": "https://agildash.arquia.com.br/",
# "start": "node server.js", 