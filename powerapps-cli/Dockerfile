# escape=`

#ARG 

FROM  openstrata/nodejs:dotnet-framework-sdk_4.8.1

USER ContainerAdministrator

RUN setx /M PATH "%PATH%;c:\Users\ContainerAdministrator\AppData\Local\Microsoft\PowerAppsCLI"

# Download Powerapp CLI
RUN powershell -Command " `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        `
        Invoke-WebRequest -OutFile powerappcli.msi https://aka.ms/PowerAppsCLI; `
        $powerappcli_sha256 = 'AF4C7058AB52E433ED0E18CB5D5E17256187A1B08ADD319F94C06C3EAC5D9190'; `
        if ((Get-FileHash powerappcli.msi -Algorithm sha256).Hash -ne $powerappcli_sha256) { `
            Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
            exit 1; `
        }; `
        Start-Process 'msiexec' -ArgumentList '/i powerappcli.msi /quiet /qn /norestart /log c:\installAuth.log'; `
        Start-Sleep -s 3 ; `
        Remove-Item -Force powerappcli.msi"


 RUN pac install latest
