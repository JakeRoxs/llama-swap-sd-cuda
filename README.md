# llama-swap-sd-cuda

![License](https://img.shields.io/badge/license-MIT-blue.svg)

Custom `llama-swap` CUDA image based on:

```text
ghcr.io/mostlygeek/llama-swap:unified-cuda
```

with `stable-diffusion.cpp` `sd-server` compiled in using CUDA.

This repo keeps the default image aligned with upstream `mostlygeek/llama-swap`, while the optional variant applies a maintained local Ollama compatibility patch inspired by `kooshi/llama-swappo`.

## Images

This repository publishes two image variants.

| Image                                          | Purpose                                                                                                                                          |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ghcr.io/jakeroxs/llama-swap-sd-cuda:latest`   | Default image. Preserves the upstream `llama-swap:unified-cuda` behavior and adds CUDA-built `sd-server` and `sd-cli`.                           |
| `ghcr.io/jakeroxs/llama-swappo-sd-cuda:latest` | Optional image. Adds the same CUDA-built SD binaries and replaces `llama-swap` with a patched binary that includes Ollama-compatible API routes. |

Use the default image unless you specifically need Ollama-compatible endpoints such as `/api/tags`, `/api/show`, `/api/ps`, `/api/generate`, `/api/chat`, `/api/embed`, or `/api/embeddings`.

## What it publishes

After the GitHub Action runs, the default image is published to:

```text
ghcr.io/jakeroxs/llama-swap-sd-cuda:latest
```

The optional Ollama-compatible variant is published to:

```text
ghcr.io/jakeroxs/llama-swappo-sd-cuda:latest
```

Both images are also tagged with the commit SHA that built them.

## Local Builds

Build the default image:

```sh
docker build -f Dockerfile -t llama-swap-sd-cuda:local .
```

Build the optional Ollama-compatible variant:

```sh
docker build \
  -f Dockerfile.llama-swappo \
  --build-arg LLAMA_SWAP_SD_CUDA_BASE=llama-swap-sd-cuda:local \
  -t llama-swappo-sd-cuda:local \
  .
```

The optional variant reuses the default image as its base so local builds do not compile `stable-diffusion.cpp` twice. If `LLAMA_SWAP_SD_CUDA_BASE` is omitted, it defaults to the published `ghcr.io/jakeroxs/llama-swap-sd-cuda:latest` image.

Build the optional Ollama-compatible variant from scratch, without using the published default image as its base:

```sh
docker build -f Dockerfile.llama-swappo-full -t llama-swappo-sd-cuda:full .
```

`Dockerfile.llama-swappo-full` is intended for local/manual builds and is not part of the GitHub Actions publish workflow.

## Optional Variant Maintenance

The optional `llama-swappo-sd-cuda` image keeps the core Dockerfile independent from the Ollama-compatible changes. It builds a replacement `llama-swap` binary from the current default branch of upstream `llama-swap` and applies the local swappo overlay patch:

```text
docker/llama-swappo/ollama-api.patch
```

The build accepts `LLAMA_SWAP_REPO` and `LLAMA_SWAP_REF` build args if a different upstream repository or ref is needed, but no specific ref is pinned by default. Keeping the patch in this repository makes the swappo behavior explicit and reviewable while still applying it on top of the latest upstream source by default.

The default `Dockerfile` does not use the swappo source and remains the minimal `llama-swap-sd-cuda` image path.

## Credits

- Built on the upstream `llama-swap` work from [mostlygeek/llama-swap](https://github.com/mostlygeek/llama-swap)
- Optional Ollama-compatible layer inspired by [kooshi/llama-swappo](https://github.com/kooshi/llama-swappo)
