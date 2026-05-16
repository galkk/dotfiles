# syntax=docker/dockerfile:1

FROM ubuntu:rolling AS minimal

COPY . /root/

RUN --mount=from=setupscripts,dst=/setupscripts/ \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /setupscripts/setup.sh

WORKDIR /root/
CMD ["/bin/zsh"]

FROM minimal AS full

RUN --mount=from=setupscripts,dst=/setupscripts/ \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /setupscripts/setup.sh dev

FROM full AS gui

RUN --mount=from=setupscripts,dst=/setupscripts/ \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /setupscripts/setup.sh gui && /setupscripts/setup.sh personal
