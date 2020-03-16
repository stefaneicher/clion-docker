FROM  meyermeyer/esw_build

MAINTAINER StefanEicher "stefan.eicher@gmail.com"

ARG INTELLIJ_VERSION=${INTELLIJ_VERSION:-CLion-2019.3.4}
ENV INTELLIJ_VERSION=${INTELLIJ_VERSION}

ARG IDEA_PRODUCT_NAME=${IDEA_PRODUCT_NAME:-ClionIC2019}
ENV IDEA_PRODUCT_NAME=${IDEA_PRODUCT_NAME}

ARG IDEA_PRODUCT_VERSION=${IDEA_PRODUCT_VERSION:-3}
ENV IDEA_PRODUCT_VERSION=${IDEA_PRODUCT_VERSION}

## -- derived vars ---
ENV IDEA_INSTALL_DIR="${IDEA_PRODUCT_NAME}.${IDEA_PRODUCT_VERSION}"
ENV IDEA_CONFIG_DIR=".${IDEA_PRODUCT_NAME}.${IDEA_PRODUCT_VERSION}"
ENV IDEA_PROJECT_DIR="ClionProjects"

ENV USER_NAME=debugger
RUN useradd -ms /bin/bash ${USER_NAME}
RUN echo 'debugger:pwd' | chpasswd

ENV HOME=/home/${USER_NAME}

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

USER ${USER_NAME}

WORKDIR ${HOME}
ARG INTELLIJ_IDE_TAR=${INTELLIJ_VERSION}.tar.gz
ARG INTELLIJ_IDE_DOWNLOAD_FOLDER=cpp

## -- (Release build) --
RUN wget https://download-cf.jetbrains.com/${INTELLIJ_IDE_DOWNLOAD_FOLDER}/${INTELLIJ_IDE_TAR} && \
    tar xvf ${INTELLIJ_IDE_TAR}
RUN ls -l
RUN mv clion-* ${IDEA_INSTALL_DIR}  && \
    rm ${INTELLIJ_IDE_TAR}

RUN mkdir -p \
    ${HOME}/${IDEA_PROJECT_DIR} \
    ${HOME}/${IDEA_CONFIG_DIR} 
    #chown -R ${USER_NAME}:${USER_NAME} ${HOME}

VOLUME ${HOME}/${IDEA_PROJECT_DIR}
VOLUME ${HOME}/${IDEA_CONFIG_DIR}

CMD "${HOME}/${IDEA_INSTALL_DIR}/bin/clion.sh"
