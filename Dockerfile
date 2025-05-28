# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia el archivo csproj y restaura dependencias
COPY *.csproj ./
RUN dotnet restore

# Copia el resto del código y compila
COPY . ./
RUN dotnet publish -c Release -o out

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expone el puerto por defecto de ASP.NET
EXPOSE 80

# Ejecuta la app
ENTRYPOINT ["dotnet", "floreria-web.dll"]


