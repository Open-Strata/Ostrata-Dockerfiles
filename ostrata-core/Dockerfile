# escape=`

#ARG FXFILEDIR="C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8.1"

FROM openstrata/nodejs:dotnet-framework-sdk_4.8.1

ENV FXPATH="C:\Program Files (x86)\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.8.1 Tools"

USER ContainerAdministrator
#RUN setx /M PATH "%PATH%;C:\Program Files\mingit\cmd"








RUN  `
        mkdir DebugPackages `
    &&  mkdir src `
    &&  dotnet new --install OpenStrata.NET.Templates `
    &&  dotnet new openstrata-dotnetsolution --name TestProject --output c:\src


WORKDIR /src
