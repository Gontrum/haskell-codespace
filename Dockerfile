ARG VARIANT=debian-10
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}
ARG GHC_VERSION_TO_USE=8.10.2
ARG INSTALL_DOCKER="false"
ARG USERNAME=codespace
ARG USER_UID=1001
ARG USER_GID=$USER_UID

WORKDIR /src
USER root

COPY library-scripts/docker-debian.sh library-scripts/common-debian.sh library-scripts/setup-user.sh /tmp/scripts/

RUN export DEBIAN_FRONTEND=noninteractive
RUN if [ "${INSTALL_DOCKER}" = "true" ]; then \
    bash /tmp/scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "codespace"; \
    else \
    echo '#!/bin/bash\nexec "$@"' > /usr/local/share/docker-init.sh && chmod +x /usr/local/share/docker-init.sh; \
    fi

RUN bash /tmp/scripts/common-debian.sh "true" "${USERNAME}" "${USER_UID}" "${USER_GID}" "false" "true" && \
    bash /tmp/scripts/setup-user.sh "${USERNAME}" "${PATH}"

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    libkrb5-3           \
    gnome-keyring       \
    libsecret-1-0       \
    desktop-file-utils  \ 
    x11-utils           \
    curl                \
    xz-utils            \
    gcc                 \
    make                \
    libtinfo5           \
    libgmp-dev          \
    zlib1g              \
    zlib1g-dev       && \
    rm -rf /var/lib/apt/lists/*

USER codespace

ENV PATH="/home/codespace/.cabal/bin:/home/codespace/.ghcup/bin:${PATH}"
RUN mkdir -p ~/.ghcup/bin && \
    curl https://downloads.haskell.org/~ghcup/0.1.11/x86_64-linux-ghcup-0.1.11 > ~/.ghcup/bin/ghcup  && \
    chmod +x ~/.ghcup/bin/ghcup  && \
    ghcup upgrade && \
    ghcup install ghc ${GHC_VERSION_TO_USE} && \
    ghcup set ghc ${GHC_VERSION_TO_USE} && \
    ghcup install cabal  && \
    cabal update  && \
    cabal install hspec --lib && \
    ghcup install hls

RUN echo "export PATH=$PATH:/home/codespace/.cabal/bin:/home/codespace/.ghcup/bin" >> /home/codespace/.bashrc

CMD [ "sleep", "infinity" ]
