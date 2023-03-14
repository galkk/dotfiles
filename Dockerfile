FROM ubuntu:latest AS minimal

ADD . /root/projects/dotfiles
WORKDIR /root/projects/dotfiles

# TODO(galk): It would be nice to add user 'andy' here, but I'll live for now.
RUN ./1-install-minimal.sh \
    && ./2-configure-user.sh

CMD ["/bin/zsh"]

# Stage 2 - full image
FROM minimal as full 

WORKDIR /root/projects/dotfiles

RUN ./3-install-full.sh

CMD ["/bin/zsh"]