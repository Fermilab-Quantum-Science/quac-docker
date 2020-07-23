# docker build -t quac_deps_vnc .

FROM quac_deps

RUN apt-get update && apt-get install -y \
      libx11-6 libxcb1 libxau6 \
      lxde tightvncserver xvfb dbus-x11 x11-utils \
      xfonts-base xfonts-75dpi xfonts-100dpi \
      lwm xterm xdotool xvnc4viewer && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5901

ENV USER root
ENV GEOM 1920x1200
# ENV GEOM 2880x1800

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT /usr/local/bin/docker-entrypoint.sh


