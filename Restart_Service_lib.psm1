#AUTHOR: Mauricio C. Barcelos

function Wait-Service-Status {
    param (

        [System.ServiceProcess.ServiceController]$service,
        [string]$status,
        [int]$seconds
    )
    try {
        for ($i = 0; $i -lt $seconds; $i++) {

            if ($service.Status -ne $status) {
                $service.Refresh()
                Start-Sleep -Seconds 1
            }
            else {
                break
            }
        }       
    }
    catch [System.Exception] {
        write-host $_.Exception
        write-host $PSItem.ScriptStackTrace
    }
}

function To-Start-Service {  
    [CmdletBinding()]
    Param 
    (
        [Parameter(Position = 0)]
        $serviceName,
        [Parameter(Position = 1)]
        $time_to_start_service_again,
        [Parameter(Position = 2)]
        $attempts_to_start_service
    )

    $ServiceObj = (Get-Service | Where-Object { $_.Name -eq $serviceName -or $_.DisplayName -eq $serviceName })
    
    if ($null -ne $ServiceObj) {
    
        for ($i = 0; $i -lt $attempts_to_start_service; $i++) {

            $ServiceObj | Start-Service

            Wait-Service-Status -service $ServiceObj -status 'Running' -seconds $time_to_start_service_again

            if ((get-wmiobject win32_service | Where-Object { $_.name -eq $ServiceObj.Name }).ProcessId -ne 0 -and $ServiceObj.Status -eq "Running") {
    
                Write-Host ("To-Start-Service - The service ", $serviceName, " was started")
                
                break;

            }
            else {

                Write-Host ("To-Start-Service - Attempts to start the service " + $serviceName + ": " + $i + 1)

            }
        }
    
        Start-Sleep -Seconds 2
    
        $ServiceObj.Refresh()
    
        Write-Host ("To-Start-Service - Service name: ", $serviceName, ";status: ", $ServiceObj.Status)
    
    }
    else {
        Write-Host ("To-Start-Service - Service name:", $serviceName , ";status: Not found")
    }
}


function To-Stop-Service {
    [CmdletBinding()]
    Param 
    (
        [Parameter(Position = 0)]
        $serviceName,
        [Parameter(Position = 1)]
        $timeout_to_kill
    )

    $ServiceObj = (Get-Service | Where-Object { $_.Name -eq $serviceName -or $_.DisplayName -eq $serviceName })
    
    if ($null -ne $ServiceObj) {
        $ServiceObj | Stop-Service -Force
        Wait-Service-Status -service $ServiceObj -status 'Stopped' -seconds $timeout_to_kill

        if ((get-wmiobject win32_service | Where-Object { $_.name -eq $ServiceObj.Name }).ProcessId -eq 0 -or `
                $null -eq (get-wmiobject win32_service | Where-Object { $_.name -eq $ServiceObj.Name }).ProcessId -and $ServiceObj.Status -eq "Stopped") {
            
            Write-Host ('To-Stop-Service - Service ' + $serviceName + ' was stopedd')
          
        }
        else {

            Write-Host ("To-Stop-Service - Forcing service shutdown " + $serviceName + " by process id")
            
            Stop-Process -Id (get-wmiobject win32_service | Where-Object { $_.name -eq $ServiceObj.Name }).ProcessId -Force
        }

    }

}