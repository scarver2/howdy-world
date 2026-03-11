# Howdy World Benchmarks

Curious how the raw performance of various software languages and frameworks compare with each other?

## Results

```bash
bin/benchmark
```

```text
Howdy World CLI
Version: crystal-kemal@6b13819 (2026-03-11) dirty:yes
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
caddy                     1788.4839    0.0112       in           0       
clojure                   1695.0139    0.0118       in           0       
crystal-kemal             3952.8795    0.0051       in           0       
dotnet-aspnet             2933.7352    0.0068       in           0       
elixir-bandit             2858.1212    0.0070       in           0       
elixir-phoenix            2547.8715    0.0078       in           0       
go                        3628.0543    0.0055       in           0       
go-fiber                  3915.6089    0.0051       in           0       
java-spring-boot          2292.1377    0.0087       in           0       
javascript                3407.3972    0.0059       in           0       
javascript-inertia        1454.0110    0.0137       in           0       
javascript-jquery         2763.5905    0.0072       in           0       
javascript-react          2969.8707    0.0067       in           0       
javascript-stimulus       2935.7701    0.0068       in           0       
javascript-vue            2879.4959    0.0069       in           0       
odin                      3639.2912    0.0055       in           0       
php                       3309.1155    0.0060       in           0       
python-fastapi            1181.2650    0.0169       in           0       
ruby-falcon               1281.5287    0.0156       in           0       
ruby-on-rails             308.9745     0.0643       in           0       
ruby-rage                 1469.0025    0.0136       in           0       
ruby-webrick              572.4778     0.0348       in           0       
rust-leptos               3363.3833    0.0059       in           0       
zig                       3100.3857    0.0064       in           0       
```
