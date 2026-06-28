# llama-swap-sd-cuda

![License](https://img.shields.io/badge/license-MIT-blue.svg)

CUDA-enabled `llama-swap` images with `stable-diffusion.cpp` built in.

The default image starts from:

```text
ghcr.io/mostlygeek/llama-swap:unified-cuda
```

and adds CUDA-built `sd-server` and `sd-cli` binaries.

## Images

| Image | Purpose |
| --- | --- |
| `ghcr.io/jakeroxs/llama-swap-sd-cuda:latest` | Default image. Preserves upstream `llama-swap:unified-cuda` behavior and adds `sd-server` and `sd-cli`. |
| `ghcr.io/jakeroxs/llama-swappo-sd-cuda:latest` | Optional Ollama-compatible image. Adds the same SD binaries and replaces `llama-swap` with a locally patched build. |

Both images are also tagged with the commit SHA that built them. Use the default image unless you specifically need Ollama-compatible endpoints such as `/api/tags`, `/api/show`, `/api/ps`, `/api/generate`, `/api/chat`, `/api/embed`, or `/api/embeddings`.

## Local Builds

Build the default image:

```sh
docker build -f Dockerfile -t llama-swap-sd-cuda:local .
```

Build the optional Ollama-compatible variant from the local default image:

```sh
docker build \
  -f Dockerfile.llama-swappo \
  --build-arg LLAMA_SWAP_SD_CUDA_BASE=llama-swap-sd-cuda:local \
  -t llama-swappo-sd-cuda:local \
  .
```

If `LLAMA_SWAP_SD_CUDA_BASE` is omitted, `Dockerfile.llama-swappo` uses `ghcr.io/jakeroxs/llama-swap-sd-cuda:latest`. This keeps local swappo builds from compiling `stable-diffusion.cpp` twice when you already have a default image.

To build the optional variant fully from source instead:

```sh
docker build -f Dockerfile.llama-swappo-full -t llama-swappo-sd-cuda:full .
```

`Dockerfile.llama-swappo-full` is intended for manual local builds and is not used by the publish workflow.

## Swappo Patch

The optional image builds a replacement `llama-swap` binary from the current default branch of `mostlygeek/llama-swap` and applies:

```text
docker/llama-swappo/ollama-api.patch
```

Use `LLAMA_SWAP_REPO` or `LLAMA_SWAP_REF` build args if you need to build the patched binary from a different upstream repository or ref. No ref is pinned by default, so the patch stays explicit in this repository while applying on top of current upstream source.

## Credits

- Built on [mostlygeek/llama-swap](https://github.com/mostlygeek/llama-swap)
- Optional Ollama-compatible layer inspired by [kooshi/llama-swappo](https://github.com/kooshi/llama-swappo)
