# Howdy World Benchmarks

Curious how the raw performance of various software languages and frameworks compare with each other?

## Results

```bash
bin/benchmark
```

```text
Howdy World CLI
Version: master@26f0e29 (2026-03-12)
Root:    /Users/scarver2/Projects/OSS/howdy-world/project
Command: benchmark

🏇 Benchmark
-----------------------------------------------
Concurrency : 20
Duration    : 5s
Host        : http://howdy.localhost
Requests    : 0

Endpoint                  Req/sec      Avg(ms)      P95(ms)      Errors  
--------                  --------     -------      -------      ------  
caddy                     3499.4845    0.0057       in           0
clojure                   2076.1651    0.0096       in           0
crystal-kemal             2936.3423    0.0068       in           0
dotnet-aspnet             3323.7359    0.0060       in           0
elixir-bandit             3449.0976    0.0058       in           0
elixir-phoenix            2606.6800    0.0077       in           0
go                        3954.2417    0.0051       in           0
go-fiber                  3820.1392    0.0052       in           0
java-spring-boot          2659.8715    0.0075       in           0
javascript                3702.3174    0.0054       in           0
javascript-inertia        1777.0855    0.0112       in           0
javascript-jquery         3583.6507    0.0056       in           0
javascript-react          3667.5262    0.0054       in           0
javascript-stimulus       3589.0637    0.0056       in           0
javascript-vue            3674.3763    0.0054       in           0
odin                      4645.8656    0.0043       in           0
php                       3802.2119    0.0053       in           0
python-fastapi            1238.9918    0.0161       in           0
ruby-falcon               1430.1673    0.0140       in           0
ruby-on-rails             351.6139     0.0566       in           0
ruby-rage                 1536.0958    0.0130       in           0
ruby-webrick              656.6636     0.0304       in           0
rust-leptos               3652.2848    0.0055       in           0
zig                       4884.5022    0.0041       in           0
```
