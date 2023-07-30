# Rust wasm32-wasi threads
This repository demonstrates how to prepare a Rust toolchain for [wasi-threads](https://github.com/WebAssembly/wasi-threads/).

## Quick start
Run the following command to compile an example code to WASM:
```bash
./compile-rust.sh stable-wasm32-wasi-preview1-threads tests/simple
```
This will generate a WASM binary in `tests/simple/target/wasm32-wasi-preview1-threads/debug/simple.wasm` that can be run in WASM runtime that implements `wasi-threads` (e.g. [WebAssembly Micro Runtime (WAMR)](https://wamr.dev) or [Wasmtime](https://wasmtime.dev/)):
```bash
 # running on WAMR
iwasm tests/simple/target/wasm32-wasi-preview1-threads/debug/simple.wasm

# running on Wasmtime
wasmtime run --wasm-features=threads --wasi-modules=experimental-wasi-threads \
    tests/simple/target/wasm32-wasi-preview1-threads/debug/simple.wasm
```

## How does it work?
`./compile-rust.sh` command builds a toolchain container that compiles a Rust version with some of the [patches](./patches) applied (please note patches won't be needed after [this PR](https://github.com/rust-lang/rust/pull/112922) is merged and available in the Rust stable branch).
The script takes two parameters:
* BUILD_TYPE - it describes a variant of the Rust toolchain. Currently, there are three variants supported:
  * `stable-wasm32-wasi-with-threads` - a stable branch of the Rust compiler is used; the threading support is by pointing the `wasm32-wasi` target to use `wasm32-wasi-threads` WASI libc target, and compiling Rust's standard library with the following target features: `+atomics,+bulk-memory,+mutable-globals`. The [wasi-locks](./patches/wasi-locks.patch) patch is applied
  * `stable-wasm32-wasi-preview1-threads` -  a stable branch of the Rust compiler is used; the threading is exposed in the `wasm32-wasi-preview1-threads` target by applying the [wasm32-wasi-preview1-threads](./patches/wasm32-wasi-preview1-threads.patch) patch.
  * `nightly-wasm32-wasi-preview1-threads` -  a [g0djan:godjan/wasi-threads](https://github.com/g0djan/rust/tree/godjan/wasi-threads) branch of the Rust compiler is used; the threading is exposed in the `wasm32-wasi-preview1-threads`. No patches are required
* CRATE_PATH - a path to a crate to compile using the toolchain
