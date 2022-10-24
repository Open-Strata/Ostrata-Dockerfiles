# escape=`

#ARG 

FROM  mcr.microsoft.com/dotnet/framework/sdk:4.8.1

USER ContainerAdministrator
RUN setx /M PATH "%PATH%;C:\Program Files\mingit\cmd"

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
