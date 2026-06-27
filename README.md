# llama-swap-sd-cuda

Custom `llama-swap` CUDA image based on:

```text
ghcr.io/mostlygeek/llama-swap:unified-cuda
```

with `stable-diffusion.cpp` `sd-server` compiled in using CUDA.

This repo keeps the default image aligned with upstream `mostlygeek/llama-swap`, while the optional variant is built with the `kooshi/llama-swappo` Ollama compatibility layer.

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
docker build -f Dockerfile.llama-swappo -t llama-swappo-sd-cuda:local .
```

## Optional Variant Maintenance

The optional `llama-swappo-sd-cuda` image keeps the core Dockerfile independent from the Ollama-compatible changes. It builds a replacement `llama-swap` binary from a pinned upstream `llama-swap` commit plus the local patch at:

```text
docker/llama-swappo/ollama-api.patch
```

The default `Dockerfile` does not use this patch and remains the minimal `llama-swap-sd-cuda` image path.

## Credits

- Built on the upstream `llama-swap` work from [mostlygeek/llama-swap](https://github.com/mostlygeek/llama-swap)
- Optional Ollama-compatible layer inspired by [kooshi/llama-swappo](https://github.com/kooshi/llama-swappo)
