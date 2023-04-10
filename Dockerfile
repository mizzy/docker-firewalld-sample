# https://github.com/ny-a/chrome-in-docker/blob/main/Dockerfile
FROM archlinux/archlinux:latest

RUN pacman -Syu --needed --noconfirm chromium otf-ipafont && \
    useradd -mG wheel,audio user

USER user

ENV DISPLAY=:0

CMD ["chromium"]
