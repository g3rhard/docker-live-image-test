#syntax=docker/dockerfile:1.4
FROM alpine:3.17

COPY <<EOF /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/v3.17/main
http://dl-cdn.alpinelinux.org/alpine/v3.17/community
EOF

RUN apk update
RUN apk --no-cache add linux-virt openrc
RUN echo "root:root" | chpasswd
RUN rc-update add root

RUN echo "live" > /etc/hostname

RUN apk --no-cache add supervisor sudo \
    && addgroup alpine \
    && adduser -G alpine -s /bin/sh -D alpine \
    && echo "alpine:alpine" | /usr/sbin/chpasswd \
    && echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers \
    && rm -rf /apk /tmp/* /var/cache/apk/*

COPY <<EOF /home/alpine/.xinitrc
#while true; do xsetroot -name "$( date +"%a %b %d %I:%M:%S %Y" )" ; sleep 1; done &
exec dwm
# exec xfce4-session
EOF

# Video & input
RUN apk --no-cache add xorg-server xf86-video-vesa xf86-input-libinput dbus udev
# WM
RUN apk --no-cache add dwm xfce4-terminal alsa-utils xfce4
RUN apk --no-cache add lightdm lightdm-gtk-greeter
RUN apk --no-cache add font-noto-emoji terminus-font xsetroot
RUN apk --no-cache add networkmanager
# Additional apps
RUN apk --no-cache add dhcpcd chrony macchanger wireless-tools iputils
RUN apk --no-cache add libxinerama xrandr
# Start services
RUN rc-update add udev sysinit dbus lightdm && \
    rc-update add dhcpcd && \
    rc-update add udev-postmount default && \
    rc-update add networkmanager
# Configurations
RUN dbus-uuidgen > /var/lib/dbus/machine-id
RUN sed -i 's/^#id:3:initdefault:/id:5:initdefault:/' /etc/inittab
# Cleanup
RUN rm -rf /apk /tmp/* /var/cache/apk/*
