FROM ubuntu:16.04

#
# USERS AND GROUPS
#
ENV HOME /home/jenkins
RUN groupadd -g 10000 jenkins && \
    useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins && \
    mkdir /home/jenkins/.jenkins/ && mkdir /home/jenkins/.bin/ && \
    chown -R jenkins:jenkins /home/jenkins/ && \
    chown jenkins:jenkins /home/jenkins/.bin && \
    chown jenkins:jenkins /home/jenkins/.jenkins && \
    chmod 750 /home/jenkins/ && \
    chmod 750 /home/jenkins/.bin  && \
    chmod 750 /home/jenkins/.jenkins
    


#
# BASE PACKAGES
#
RUN apt-get -qqy update \
    && apt-get -qqy --no-install-recommends install \
    openjdk-8-jre \
    bzip2 \
    ca-certificates \
    unzip \
    wget \
    curl \
    git \
    jq \
    zip \
    xvfb \
    pulseaudio \
    dbus \
    dbus-x11 \
    build-essential && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#
# NODEJS
#
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get update -qqy && apt-get -qqy install -y nodejs && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#
# CHROME
#
ARG CHROME_VERSION="google-chrome-stable"
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -qqy && apt-get -qqy install ${CHROME_VERSION:-google-chrome-stable} && \
    rm /etc/apt/sources.list.d/google-chrome.list && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    ln -s /usr/bin/google-chrome /usr/bin/chromium-browser


#
# CLOUDFOUNDRY CLI
#
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - && \
    echo "deb http://packages.cloudfoundry.org/debian stable main" >> /etc/apt/sources.list.d/cloudfoundry-cli.list && \
    apt-get update -qqy && apt-get -qqy install cf-cli && \
    rm /etc/apt/sources.list.d/cloudfoundry-cli.list && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#
# YARN
#
RUN wget -q -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qqy && apt-get -qqy install yarn && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*


#
# DBUS
#
COPY dbus-system.conf /tmp/dbus-system.conf
RUN mkdir /var/run/dbus/ && \
    chown -R jenkins:jenkins /var/run/dbus/


#
# INSTALL AND CONFIGURE
#
COPY docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod u+rx,g+rx,o+rx,a-w /opt/docker-entrypoint.sh && \
    mkdir /tmp/.X11-unix && \
    chown -R root:root /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix

#
# RUN
#
ENV INSPECT "false"
USER jenkins
VOLUME /home/jenkins/.jenkins
WORKDIR /home/jenkins
ENTRYPOINT ["/opt/docker-entrypoint.sh"]
