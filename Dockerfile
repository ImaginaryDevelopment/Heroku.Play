# FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build_base

RUN dotnet --list-sdks
RUN dotnet --info
# | /usr/sh - && apt-get install -y nodejs npm
# RUN curl -sL https://deb.nodesource.com/setup_8.x
# RUN apt-get install -y nodejs npm
# RUN npm install -g yarn@1.12.3
# RUN apt update

# RUN wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft.prod.deb -O packages-microsoft-prod.deb
# RUN dpkg -i packages-microsoft-prod.deb
# RUN apt update
# RUN apt-get install -y aspnetcore-runtime-2.2

WORKDIR /code/app


COPY .config/ .config/
RUN dotnet tool list --global
RUN dotnet tool restore --tool-manifest ./.config/dotnet-tools.json


COPY paket.dependencies paket.dependencies
COPY paket.lock paket.lock
COPY .paket .paket
COPY Directory.Build.props Directory.Build.props

COPY build.sh build.sh
COPY build.fsx build.fsx
COPY Directory.Build.props Directory.Build.props

RUN dotnet paket restore

FROM build_base as build

WORKDIR /code/app

# Copy csproj and restore as distinct layers
# COPY ./src/Heroku.Play/*.fsproj ./
COPY ./src ./src
COPY ./tests ./tests
COPY Heroku.Play.sln ./
COPY CHANGELOG.md CHANGELOG.md

ENV FAKE_DETAILED_ERRORS true
ENV INDOCKER=true
RUN dotnet fake build release


# WORKDIR /code/app/src/Heroku.Play/

# RUN dotnet restore Heroku.Play.fsproj

# Copy everything else and build
# COPY . .

# RUN dotnet publish -c Release -o /code/app/out
# RUN dotnet publish -c Release

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app
COPY --from=build /code/app/out .

RUN dotnet --list-sdks



# Run the app on container startup
# Use your project name for the second parameter
# e.g. MyProject.dll
ENTRYPOINT [ "dotnet", "Heroku.Play.dll" ]
