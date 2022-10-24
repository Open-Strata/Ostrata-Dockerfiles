set-location $PSScriptRoot
docker -l debug  build -t openstrata/core-container:dotnet-framework-sdk-4_8_1 $PSScriptRoot\.


#docker pull mcr.microsoft.com/dotnet/sdk:6.0-windowsservercore-ltsc2022
#docker pull mcr.microsoft.com/dotnet/framework/sdk:4.8.1