# escape=`

#ARG REPO=mcr.microsoft.com/dotnet/aspnet

# Installer image
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64 AS installer

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
        mkdir mingit; `
        tar -oxzf mingit.zip -C mingit; `
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
        mkdir dotnet; `
        tar -oxzf dotnet.zip -C dotnet; `
        Remove-Item -Force dotnet.zip; `
        `
 #       # Install PowerShell global tool
 #       $powershell_version = '7.2.6'; `
 #       Invoke-WebRequest -OutFile PowerShell.Windows.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Windows.x64.$powershell_version.nupkg; `
 #       $powershell_sha512 = '5e67f2cea98fef1c2e985aa3827b5c5c0cfc239cecf82a12bc80633f91d057e4cf024831172b9b851220877d1c5dac426ae88970cb941cbdbe094d4cd42b954f'; `
 #       if ((Get-FileHash PowerShell.Windows.x64.$powershell_version.nupkg -Algorithm sha512).Hash -ne $powershell_sha512) { `
 #           Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
 #           exit 1; `
 #       }; `
 #       & \dotnet\dotnet tool install --add-source . --tool-path \powershell --version $powershell_version PowerShell.Windows.x64; `
 #       & \dotnet\dotnet nuget locals all --clear; `
 #       Remove-Item -Force PowerShell.Windows.x64.$powershell_version.nupkg; `
 #       Remove-Item -Path \powershell\.store\powershell.windows.x64\$powershell_version\powershell.windows.x64\$powershell_version\powershell.windows.x64.$powershell_version.nupkg -Force; `
        `
        # Workaround for https://github.com/dotnet/sdk/issues/18410
        \dotnet\dotnet build-server shutdown; `
        `
        # Delete everything in the dotnet folder that's not needed in the SDK layer but will instead be derived from base layers
        Get-ChildItem -Exclude 'LICENSE.txt','ThirdPartyNotices.txt','packs','sdk','sdk-manifests','templates','shared' -Path dotnet `
            | Remove-Item -Force -Recurse; `
        Get-ChildItem -Exclude 'Microsoft.WindowsDesktop.App' -Path dotnet\shared `
            | Remove-Item -Force -Recurse"

#Create Downloads to copy
RUN powershell -Command "`
    $ErrorActionPreference = 'Stop' ; `
    $DownloadDir = 'downloads' ;`
    mkdir $DownloadDir  ;
#    $DotnetExePath = $DownloadDir+'\dotnet-framework-installer.exe' ;`
#    $PatchMsuPath = $DownloadDir+'\patch.msu' ;`
#    Invoke-WebRequest -Method Get -OutFile $DotnetExePath -Uri https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe ; `
#    Invoke-WebRequest -Method Get -OutFile $PatchMsuPath -Uri https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/updt/2022/08/windows10.0-kb5017268-x64-ndp481_684aa04c830ad9b05b4f91c6f4e5b4a3970a0a23.msu  ; `
#    "

# SDK image
#FROM $REPO:6.0.10-nanoserver-ltsc2022
FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

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
    NUGET_XMLDOC_MODE=skip 
    # PowerShell telemetry for docker image usage
   # POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-NanoServer-ltsc2022 
    # Enable detection of running in a container
   # DOTNET_RUNNING_IN_CONTAINER=true `
   # COMPLUS_RUNNING_IN_CONTAINER=1 `
   # COMPLUS_NGenProtectedProcess_FeatureEnabled=0    
     

# In order to set system PATH, ContainerAdministrator must be used
USER ContainerAdministrator
#RUN setx /M PATH "%PATH%;C:\Program Files\dotnet;C:\Program Files\powershell;C:\Program Files\MinGit\cmd"
RUN setx /M PATH "%PATH%;C:\Program Files\dotnet;C:\Program Files\MinGit\cmd"

USER ContainerUser
#COPY --from=installer /windows/system32/netapi32.dll /windows/system32/netapi32.dll
COPY --from=installer ["/dotnet", "/Program Files/dotnet"]
#COPY --from=installer ["/powershell", "/Program Files/powershell"]
COPY --from=installer ["/mingit", "/Program Files/mingit"]
COPY --from=installer ["/downloads", "/downloads"]

RUN powershell -Command " `
            mkdir DebugPackages; `
            mkdir src;`
            "

#RUN `
#    # Install .NET Fx 4.8.1
#    #curl -fSLo dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe `
#    .\downloads\dotnet-framework-installer.exe /q `
#    && del .\downloads\dotnet-framework-installer.exe `
#    && powershell Remove-Item -Force -Recurse ${Env:TEMP}\* `
#    `
#    # Apply latest patch
#    #&& curl -fSLo patch.msu https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/updt/2022/08/windows10.0-kb5017268-x64-ndp481_684aa04c830ad9b05b4f91c6f4e5b4a3970a0a23.msu `
#    && mkdir patch `
#    && expand .\downloads\patch.msu patch -F:* `
#    && del /F /Q .\downloads\patch.msu `
#    && dism /Online /Quiet /Add-Package /PackagePath:C:\patch\windows10.0-kb5017268-x64-ndp481.cab `
#    && rmdir /S /Q patch `
#   `
#   # Ngen top of assembly graph to optimize a set of frequently used assemblies
#    && %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen install "Microsoft.PowerShell.Utility.Activities, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" `
#    # To optimize 32-bit assemblies, uncomment the next line
#    # && %windir%\Microsoft.NET\Framework\v4.0.30319\ngen install "Microsoft.PowerShell.Utility.Activities, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" `
#    && %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen update `
#    && %windir%\Microsoft.NET\Framework\v4.0.30319\ngen update


# Trigger first run experience by running arbitrary cmd
#RUN dotnet help