# escape=`

ARG REPO=mcr.microsoft.com/dotnet/aspnet
#FROM $REPO:6.0.10-windowsservercore-ltsc2022
FROM mcr.microsoft.com/dotnet/framework/runtime:4.8.1

ENV `
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= `
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false `
    # Do not show first run text
    DOTNET_NOLOGO=true `
    # SDK version
    DOTNET_SDK_VERSION=6.0.402 `
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true `
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip `
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-WindowsServerCore-ltsc2022

RUN powershell -Command " `
            mkdir DebugPackages; `
            mkdir src;`
            "
# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\dotnet;C:\Program Files\powershell;C:\Program Files\MinGit\cmd"

#USER ContainerUser

# https://aka.ms/vs/17/release/vc_redist.x86.exe

RUN `
    # Install vc_redist
    curl -fSLo vc_redist.exe https://aka.ms/vs/17/release/vc_redist.x86.exe `
    #&& start /w vc_redist /q /norestart `
    #&& powershell -Command "if ($err = dir $Env:TEMP -Filter dd_setup_*_errors.log | where Length -gt 0 | Get-Content) { throw $err }" 
    #&& del vc_redist.exe 

# Download MinGit
RUN powershell -Command " `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        Invoke-WebRequest -OutFile mingit.zip https://github.com/git-for-windows/git/releases/download/v2.37.3.windows.1/MinGit-2.37.3-64-bit.zip; `
        $mingit_sha256 = 'cec8d038fadbdd82e269a5c458fd2a62711c1bb9a76c85f07c46de3bff6cdf32'; `
        if ((Get-FileHash mingit.zip -Algorithm sha256).Hash -ne $mingit_sha256) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        mkdir $Env:ProgramFiles\mingit; `
        tar -oxzf mingit.zip -C $Env:ProgramFiles\mingit; `
        Remove-Item -Force mingit.zip"

RUN powershell -Command " `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        # Retrieve .NET SDK
        $sdk_version = '6.0.402'; `
        Invoke-WebRequest -OutFile dotnet.zip https://dotnetcli.azureedge.net/dotnet/Sdk/$sdk_version/dotnet-sdk-$sdk_version-win-x64.zip; `
        $dotnet_sha512 = '609217ef0e1baecc250db94cf0a0255301220d8f6a443424c0bd912b07c1fdaa5eef89b28907a70e05bee5b76c4792afdbf3e5399dc609a41c05319e523b96dd'; `
        if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        mkdir $Env:ProgramFiles\dotnet; `
        tar -oxzf dotnet.zip -C $Env:ProgramFiles\dotnet; `
        Remove-Item -Force dotnet.zip; `
        `
        # Install PowerShell global tool
        $powershell_version = '7.2.6'; `
        Invoke-WebRequest -OutFile PowerShell.Windows.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Windows.x64.$powershell_version.nupkg; `
        $powershell_sha512 = '5e67f2cea98fef1c2e985aa3827b5c5c0cfc239cecf82a12bc80633f91d057e4cf024831172b9b851220877d1c5dac426ae88970cb941cbdbe094d4cd42b954f'; `
        if ((Get-FileHash PowerShell.Windows.x64.$powershell_version.nupkg -Algorithm sha512).Hash -ne $powershell_sha512) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        & $Env:ProgramFiles\dotnet\dotnet tool install --add-source . --tool-path $Env:ProgramFiles\powershell --version $powershell_version PowerShell.Windows.x64; `
        & $Env:ProgramFiles\dotnet\dotnet nuget locals all --clear; `
        Remove-Item -Force PowerShell.Windows.x64.$powershell_version.nupkg; `
        Remove-Item -Path $Env:ProgramFiles\powershell\.store\powershell.windows.x64\$powershell_version\powershell.windows.x64\$powershell_version\powershell.windows.x64.$powershell_version.nupkg -Force;"


# Trigger first run experience by running arbitrary cmd
RUN dotnet help