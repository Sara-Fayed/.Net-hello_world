# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application files and publish
COPY . ./
RUN dotnet publish -c Release -o out

# Stage 2: Create the runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1
WORKDIR /app

# Copy only the necessary output files from the build stage
COPY --from=build-env /app/out .

# Expose the port your app will listen on
EXPOSE 80

# Command to run the application
ENTRYPOINT ["dotnet", "dotnet-hello-world.dll"]
