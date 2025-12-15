# Endpoint Scaffold Generator

The _builder_ directory contains the files necessary to generate the Howdy World endpoints.

** This is a work in progress. Expect substantial changes. **

```
_builder/
  builder.rb              # non-Thor builder script (1st gen)
  lang_scaffold.rb        # Thor CLI (2nd gen)
  languages.csv           # CSV for builder
  templates/              # ERB templates for builder
    Dockerfile.erb
    nginx_site.conf.erb
    docker-compose.yml.erb
```

&copy;2025 Stan Carver II

![Made in Texas](https://raw.githubusercontent.com/scarver2/howdy-world/main/nginx/www/made-in-texas.png)
