// dotnet/Program.cs
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", async context =>
{
    context.Response.ContentType = "text/html; charset=utf-8";

    await context.Response.WriteAsync("""
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Howdy from .NET</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
</head>
<body>
  <h1>Howdy, World!</h1>
</body>
</html>
""");
});

app.Run();
