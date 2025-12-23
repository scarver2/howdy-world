# Zig

## Prerequisites

```bash
brew install zig
```

## Build

```bash
zig build-exe -O ReleaseFast -fstrip -fsingle-threaded -femit-bin=howdy howdy.zig
```
