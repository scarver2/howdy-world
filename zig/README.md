# Zig

## Prerequisites

```bash
brew install zig
```

## Build

```bash
zig build-exe -O ReleaseFast -fstrip -fsingle-threaded -femit-bin=howdy howdy.zig
```

## Run

```bash
./howdy
```

then visit http://localhost:3000

&copy;2026 [Stan Carver II](http://stancarver.com)

![Made in Texas](https://raw.githubusercontent.com/scarver2/howdy-world/master/_dashboard/www/assets/made-in-texas.png)
