# syntax=docker/dockerfile:1.4

FROM ubuntu:rolling AS minimal

COPY . /root/

# Using bind mount to not copy installation scripts to the container
RUN --mount=from=setupscripts,dst=/setupscripts/ /setupscripts/setup.sh

WORKDIR /root/
CMD ["/bin/zsh"]

# Stage 2 - full image
FROM minimal as full

RUN --mount=from=setupscripts,dst=/setupscripts/ /setupscripts/setup.sh dev

CMD ["/bin/zsh"]