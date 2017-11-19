# vim: set ft=dockerfile:
FROM yen3/binfmt-register:0.1 as builder

FROM arm64v8/ubuntu:16.04
MAINTAINER yen3 <yen3@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Add qemu binary to run the inmage in x86-64 platform
# The binary is unused in macOS docker
COPY --from=builder /qemu/qemu-aarch64-static /usr/local/bin/qemu-aarch64-static

RUN apt-get update \
    && apt-get install -y --force-yes --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc x11vnc-data xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        libreoffice firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant libreoffice-l10n-zh-tw \
        nginx \
        python-pip python-dev build-essential \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD web /web/
ADD get-pip.py /get-pip.py
RUN python get-pip.py
RUN /usr/local/bin/pip install -r /web/requirements.txt

ADD noVNC /noVNC/
ADD nginx.conf /etc/nginx/sites-enabled/default
ADD startup.sh /
ADD supervisord.conf /etc/supervisor/conf.d/
ADD doro-lxde-wallpapers /usr/share/doro-lxde-wallpapers/

# Remove the binary. It's unused in the final result
RUN rm -f /usr/local/bin/qemu-aarch64-static

EXPOSE 6080
WORKDIR /root
ENTRYPOINT ["/startup.sh"]
