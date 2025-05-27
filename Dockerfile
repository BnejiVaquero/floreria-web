# Etapa 1: build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copiar archivos csproj y restaurar dependencias
COPY *.sln .
COPY **/*.csproj ./
RUN for file in *.csproj; do mkdir -p src/$(basename $file .csproj) && mv $file src/$(basename $file .csproj)/; done
WORKDIR /app/src
RUN dotnet restore

# Copiar el resto del código y compilar
WORKDIR /app
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "floreria.dll"]

