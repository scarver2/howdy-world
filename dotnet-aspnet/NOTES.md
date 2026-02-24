# DotNet Notes



## Initial Chat

Before reading, know that my .Net knowledge goes back to the 1.1 days, so I have an idea of what the ecosystem expects.

After training Deputy (my AI assistant) on my Howdy World project, I asked it to add a .NET (ASP.NET Core) endpoint to my Howdy World project. I have included the chat transcript below. Thirty-six seconds later, I have what appears to be a working .NET endpoint. Just copy-and-paste each code snippet, and viola! Instant .NET app. 

**WRONG!**

# Outdated. Unless you explicitly tell AI the version you are using, it will "randomly" pick a version. In the example below, it chose a version of .Net slated for end of life later this year.
# This code doesn't run. Since this version is not what's installed on my machine, I now have multiple decisions to make. 
  # Install an older version, possibly destabilizing my other projects. Package version management has it's own complexities that can consume many hours of your time.
  # Work solely within a containerized development environment -- advantageous when dealing with legacy environments.
  # Update the source code to work with the version installed on my machine. (my choice for this project)
# The code is bloated. Typical of AI output, My final version is less verbose.
# AI makes assumptions. It is always learning, not just from your coding style, but also from millions of articles and interactions with others.

AI today give guidance. It is not a replacement for a human developer. It should be treated as a tool to assist you. The best developers will glean _intent_ from AI's output, cherry-pick items from the output,make corrections, and continue on. I encourage any developer to read the commentary from AI to understand it's rationale, whether you agree with it or not.

In the end, I taught Deputy about modern .Net 10 -- which it miraculously became "all knowing" of the subject and made corrections.

## Chat Transcript

```
Deputy, let's make a Dotnet Howdy World example that runs on Linux.
```

Alright Sheriff 🤠 — let’s add a **.NET (ASP.NET Core) Howdy World** endpoint to your HowdyWorld corral that:

* ✅ Runs on **Linux**
* ✅ Uses modern **.NET 8**
* ✅ SSR HTML (no frontend framework)
* ✅ Dockerized
* ✅ Works behind your root NGINX like the others
* ✅ Clean, minimal, production-ready

We’ll follow your standard endpoint structure (root-level folder, Dockerfile, compose, nginx conf).

---

# 1️⃣ Prerequisites (macOS or Linux)

### Install .NET 8 SDK

**macOS (Homebrew)**

```bash
brew install dotnet
```

**Linux (Ubuntu example)**

```bash
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0
```

Verify:

```bash
dotnet --version
```

Should show `8.x.x`

---

# 2️⃣ Create the Endpoint

From your project root:

```bash
dotnet new web -o dotnet-aspnet
cd dotnet-aspnet
```

This generates a minimal ASP.NET Core app.

---

# 3️⃣ Replace `Program.cs`

`dotnet-aspnet/Program.cs`

```csharp
// dotnet-aspnet/Program.cs

using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", async context =>
{
    context.Response.ContentType = "text/html; charset=utf-8";

    await context.Response.WriteAsync("""
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Howdy World - .NET</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body>
  <main>
    <h1>Howdy, World!</h1>
    <p>Served from ASP.NET Core running on Linux.</p>
  </main>
</body>
</html>
""");
});

app.Run();
```

This is:

* Modern minimal API style
* No MVC overhead
* Clean SSR HTML
* Very “HowdyWorld appropriate”

---

# 4️⃣ Development Compose (endpoint-level)

`dotnet-aspnet/compose.yml`

```yaml
# dotnet-aspnet/compose.yml

services:
  dotnet-aspnet:
    build:
      context: .
    container_name: howdy-dotnet-aspnet
    ports:
      - "5000:8080"
    volumes:
      - .:/app
    environment:
      - ASPNETCORE_URLS=http://+:8080
```

---

# 5️⃣ Dockerfile (Production-Ready, Multi-Stage)

`dotnet-aspnet/Dockerfile`

```dockerfile
# dotnet-aspnet/Dockerfile

# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o /app/publish

# Runtime stage (Linux)
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "dotnet-aspnet.dll"]
```

This gives you:

* Proper production build
* Slim runtime image
* Linux-native
* Very Docker-friendly

---

# 6️⃣ Root-Level Compose Addition

Add to your main `compose.yml`:

```yaml
  dotnet-aspnet:
    build:
      context: ./dotnet-aspnet
    container_name: dotnet-aspnet
    expose:
      - "8080"
    networks:
      - corral
```

---

# 7️⃣ Root NGINX Config

`nginx/conf.d/dotnet-aspnet.conf`

```nginx
# nginx/conf.d/dotnet-aspnet.conf

location = /dotnet-aspnet {
  return 301 /dotnet-aspnet/;
}

location ^~ /dotnet-aspnet/ {
  proxy_pass http://dotnet-aspnet:8080/;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
}
```

---

# 8️⃣ Run It

From project root:

```bash
docker compose up --build --remove-orphans
```

Then visit:

```
http://localhost/dotnet-aspnet/
```

---

# 🎯 What You Just Added to Your Arsenal

You now have:

* Ruby
* Zig
* Go
* Rust (Leptos)
* Elixir (Bandit + Phoenix)
* Java (Spring Boot)
* Node (Express / Next)
* React (Vite)
* And now…

## .NET 8 (ASP.NET Core on Linux)

That’s serious polyglot credibility, Sheriff.

And this is not “toy .NET” — this is modern cloud-native .NET that runs beautifully in containers and Kubernetes.

---

If you’d like next:

* Add Razor Pages version?
* Add minimal API JSON endpoint?
* Add watch-mode dev Dockerfile?
* Add test project with xUnit?
* Or integrate it into your E2E Playwright manifest?

Deputy is ready.

