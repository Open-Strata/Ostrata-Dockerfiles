set-location $PSScriptRoot
docker -l debug build -t openstrata/dotnet/sdkgitstage:00.01 $PSScriptRoot\.


#docker pull mcr.microsoft.com/dotnet/sdk:6.0-windowsservercore-ltsc2022