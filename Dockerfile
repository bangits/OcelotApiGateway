FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Atom.Ocelot.Gateway/Atom.Ocelot.Gateway.csproj", "Atom.Ocelot.Gateway/"]
RUN dotnet restore "Atom.Ocelot.Gateway/Atom.Ocelot.Gateway.csproj"
COPY . .
WORKDIR "/src/Atom.Ocelot.Gateway"
RUN dotnet build "Atom.Ocelot.Gateway.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Atom.Ocelot.Gateway.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Atom.Ocelot.Gateway.dll"]
