FROM archlinux

RUN pacman -Syu --noconfirm
RUN pacman -S --needed --noconfirm base-devel git

RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -m user -G wheel
USER user
RUN cd /tmp && git clone --depth 1 https://aur.archlinux.org/paru.git \
  && cd paru && makepkg -si --noconfirm

USER root
ARG JAVA_VER=21
RUN pacman -S --noconfirm jdk${JAVA_VER}-openjdk

RUN sudo -u user paru -S android-sdk-cmdline-tools-latest

ARG SDK_VER=34
RUN source /etc/profile && yes | sdkmanager "platforms;android-${SDK_VER}"
