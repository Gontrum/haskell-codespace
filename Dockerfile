FROM mcr.microsoft.com/vscode/devcontainers/universal:linux
ARG GHC_VERSION_TO_USE=8.10.2
WORKDIR /src
USER root

ARG INSTALL_DOCKER="false"
COPY library-scripts/docker-debian.sh /tmp/library-scripts/
RUN if [ "${INSTALL_DOCKER}" = "true" ]; then \
    bash /tmp/library-scripts/docker-debian.sh "true" "/var/run/docker-host.sock" "/var/run/docker.sock" "codespace"; \
    else \
    echo '#!/bin/bash\nexec "$@"' > /usr/local/share/docker-init.sh && chmod +x /usr/local/share/docker-init.sh; \
    fi \
    && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl            \
    xz-utils        \
    gcc             \
    make            \
    libtinfo5       \
    libgmp-dev      \
    zlib1g-dev

USER codespace

ENV PATH="/home/codespace/.cabal/bin:/home/codespace/.ghcup/bin:${PATH}"
RUN mkdir -p ~/.ghcup/bin && \
    curl https://downloads.haskell.org/~ghcup/0.1.11/x86_64-linux-ghcup-0.1.11 > ~/.ghcup/bin/ghcup  && \
    chmod +x ~/.ghcup/bin/ghcup  && \
    ghcup upgrade && \
    ghcup install ghc ${GHC_VERSION_TO_USE} && \
    ghcup set ghc ${GHC_VERSION_TO_USE} && \
    ghcup install-cabal  && \
    cabal update  && \
    ghcup install hls

RUN echo "export PATH=$PATH:/home/codespace/.cabal/bin:/home/codespace/.ghcup/bin" >> /home/codespace/.bashrc
