# syntax=docker/dockerfile:1.4

FROM ubuntu:rolling AS minimal

COPY . /root/

# Using bind mount to not copy installation scripts to the container
RUN --mount=from=setupscripts,dst=/setupscripts/ /setupscripts/1-base.sh && /setupscripts/2-minimal-config.sh

WORKDIR /root/
CMD ["/bin/zsh"]

# Stage 2 - full image
FROM minimal as full

RUN --mount=from=setupscripts,dst=/setupscripts/ /setupscripts/3-dev.sh && /setupscripts/5-personal.sh

CMD ["/bin/zsh"]

# Stage 3 - gui image
FROM full as gui

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=from=setupscripts,dst=/setupscripts/ /setupscripts/4-gui.sh && /setupscripts/4-gui-fonts.sh && /setupscripts/6-personal-gui.sh

CMD ["/bin/zsh"]
