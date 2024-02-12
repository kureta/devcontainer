FROM archlinux:latest

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

# clone dotfiles via yadm
RUN --mount=type=ssh,required=true,uid=1000,gid=1000 \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  # Actual command below
  # yadm clone --bootstrap git@github.com:kureta/devcontainer-dotfiles.git
  # Code for rapid testing
  yadm clone git@github.com:kureta/devcontainer-dotfiles.git
COPY ./devcontainer-dotfiles/.config/yadm/bootstrap /home/user/.config/yadm/bootstrap
RUN --mount=type=ssh,required=true,uid=1000,gid=1000 \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  yadm bootstrap

ENTRYPOINT ["/usr/bin/zsh"]
