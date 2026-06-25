FROM nvidia/cuda:12.6.3-devel-ubuntu24.04 AS sd-build

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git \
      cmake \
      build-essential \
      pkg-config \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/build

RUN git clone --recursive https://github.com/leejet/stable-diffusion.cpp.git

RUN cmake -S stable-diffusion.cpp -B stable-diffusion.cpp/build \
      -DSD_CUDA=ON \
      -DCMAKE_CUDA_ARCHITECTURES=86 \
      -DCMAKE_BUILD_TYPE=Release

RUN cmake --build stable-diffusion.cpp/build --config Release -j"$(nproc)"


FROM ghcr.io/mostlygeek/llama-swap:unified-cuda

USER root

COPY --from=sd-build /tmp/build/stable-diffusion.cpp/build/bin/sd-server /usr/local/bin/sd-server
COPY --from=sd-build /tmp/build/stable-diffusion.cpp/build/bin/sd-cli /usr/local/bin/sd-cli

RUN chmod 0755 /usr/local/bin/sd-server /usr/local/bin/sd-cli

WORKDIR /app
