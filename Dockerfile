ARG BASE_IMAGE=archlinux:latest
FROM $BASE_IMAGE

# install sudo
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
  gawk -i inplace '!/usr\/share\/doc/' /etc/pacman.conf && \
  pacman -Sy && \
  pacman -S --noconfirm sudo yadm openssh

# ccreate new user with uid and gid 1000 and add user to sudoers
RUN useradd -m -u 1000 -U -s /bin/bash user && \
  echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# switch to new user
USER user
WORKDIR /home/user

# create ssh directory with correct permissions
RUN mkdir -p ~/.ssh && \
  chmod 700 ~/.ssh

# add github to known hosts
RUN mkdir -p ~/.ssh && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts

# RELEASE: clone dotfiles via yadm
RUN --mount=type=ssh,required=true,uid=1000,gid=1000 \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  yadm clone --bootstrap git@github.com:kureta/devcontainer-dotfiles.git && \
  yadm bootstrap

# TESTING: copy files from host to container for rapid testing
# COPY --chown=user:user devcontainer-dotfiles /home/user
# RUN --mount=type=ssh,required=true,uid=1000,gid=1000 \
#   --mount=type=cache,target=/var/cache/pacman/pkg \
#   yadm bootstrap

ENTRYPOINT ["/usr/bin/zsh"]
