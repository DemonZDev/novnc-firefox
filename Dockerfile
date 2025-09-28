FROM ubuntu:22.04

# Prevent timezone prompt
ENV DEBIAN_FRONTEND=noninteractive

# Install desktop, browser, VNC, noVNC
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    firefox \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    supervisor x11-apps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a user
RUN useradd -m -s /bin/bash desktop
USER desktop
WORKDIR /home/desktop

# VNC password (change if needed)
RUN mkdir -p ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# Expose Render web port
EXPOSE 8080

# Copy supervisord config
USER root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-n"]
