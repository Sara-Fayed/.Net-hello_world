# Use the .NET Core SDK as the build environment
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build-env
WORKDIR /app

# Copy the .csproj file and restore dependencies
COPY hello-world-api/hello-world-api.csproj ./hello-world-api/
WORKDIR /app/hello-world-api
RUN dotnet restore

# Copy the remaining application files
COPY . /app

# Publish the application
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1
WORKDIR /app
COPY --from=build-env /app/hello-world-api/out .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
