FROM mcr.microsoft.com/dotnet/core/sdk:5.0 AS builder
WORKDIR /app

# Copy project and restore
COPY *.csproj .
RUN dotnet restore
# Copy everything and build project
COPY . .
RUN dotnet publish -c Release -o out

# Build run time image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app
COPY --from=builder /app/out .
COPY docker-entrypoint.sh .
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT [ "./docker-entrypoint.sh" ]