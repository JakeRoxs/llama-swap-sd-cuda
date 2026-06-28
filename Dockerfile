# syntax=docker/dockerfile:1

FROM nvidia/cuda:12.6.3-devel-ubuntu24.04 AS sd-build

ARG DEBIAN_FRONTEND=noninteractive
ENV CCACHE_DIR=/root/.cache/ccache
ENV PATH="/usr/lib/ccache:${PATH}"

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      cmake \
      build-essential \
      pkg-config \
      ccache

WORKDIR /tmp/build

RUN git clone --recursive https://github.com/leejet/stable-diffusion.cpp.git

RUN --mount=type=cache,id=sd-cmake-build-cuda-86,target=/tmp/build/stable-diffusion.cpp/build,sharing=locked \
    --mount=type=cache,id=sd-ccache-cuda-86,target=/root/.cache/ccache,sharing=locked \
    cmake -S stable-diffusion.cpp -B stable-diffusion.cpp/build \
      -DSD_CUDA=ON \
      -DCMAKE_CUDA_ARCHITECTURES=86 \
      -DCMAKE_BUILD_TYPE=Release \
 && cmake --build stable-diffusion.cpp/build --config Release -j"$(nproc)" \
 && mkdir -p /out/bin \
 && cp stable-diffusion.cpp/build/bin/sd-server /out/bin/sd-server \
 && cp stable-diffusion.cpp/build/bin/sd-cli /out/bin/sd-cli


FROM ghcr.io/mostlygeek/llama-swap:unified-cuda

USER root

COPY --from=sd-build /out/bin/sd-server /usr/local/bin/sd-server
COPY --from=sd-build /out/bin/sd-cli /usr/local/bin/sd-cli

RUN chmod 0755 /usr/local/bin/sd-server /usr/local/bin/sd-cli

WORKDIR /app
