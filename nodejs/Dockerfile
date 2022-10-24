# escape=`

#ARG 

FROM  openstrata/git:dotnet-framework-sdk_4.8.1

USER ContainerAdministrator

RUN setx /M PATH "%PATH%;C:\Program Files\nodejs"

#COPY node-v16.18.0-win-x64.zip .


# Download NodeJs
RUN powershell -Command " `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        Invoke-WebRequest -OutFile nodejs.zip https://nodejs.org/dist/v16.18.0/node-v16.18.0-win-x64.zip; `
        $nodejs_sha256 = 'B5DC231944DB59701E8C299AD309821D5DD99408E2E39D4FAA0F7FAFC85F733A'; `
        if ((Get-FileHash nodejs.zip -Algorithm sha256).Hash -ne $nodejs_sha256) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        #mkdir $Env:ProgramFiles\nodejs; `
        tar -oxzf nodejs.zip -C $Env:ProgramFiles; `
        Rename-Item -Path 'C:\program files\node-v16.18.0-win-x64' -NewName 'nodejs' ; `
        Remove-Item -Force nodejs.zip"
