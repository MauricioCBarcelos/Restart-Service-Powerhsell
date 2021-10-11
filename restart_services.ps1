#AUTHOR: Mauricio de Carvalho Barcelos
param (
    [Parameter(Mandatory=$true)]$server_file
)

function Controller-Restart {
    [CmdletBinding()]
    param (
        $csv_parametes_script,
        $StartOrStop
    )

    $script_parameters = @{
        ComputerName = $csv_parametes_script.server
        ArgumentList = $csv_parametes_script,$StartOrStop
    } 
    if ($csv_parametes_script.user -ne '') {
        $userPassword = ConvertTo-SecureString -String $csv_parametes_script.password -AsPlainText -Force
        
        $Credencial = new-object -typename System.Management.Automation.PSCredential -ArgumentList $csv_parametes_script.user, $userPassword

        $script_parameters.Add('Credential', $Credencial)
    }

    Invoke-Command @script_parameters -ScriptBlocK {
        param (
            [Parameter(Position = 0)]$csv_parametes_script,
            [Parameter(Position = 1)]$StartOrStop
        )

        Write-Host ('Controller-Restart on '+$csv_parametes_script.server)
        
        Import-Module ($csv_parametes_script.script_path + '\Restart_Service_lib.psm1')

        $listOfServices = Import-Csv $csv_parametes_script.file_of_services -Delimiter ';'
        foreach ($service in $listOfServices) {
            if ($StartOrStop -eq 'START') {
                To-Start-Service -serviceName $service.name -time_to_start_service_again $service.time_to_start_service_again -attempts_to_start_service $service.attempts_to_start_service
            } elseif ($StartOrStop -eq 'STOP') {
                To-Stop-Service -serviceName $service.name -timeout_to_kill $service.timeout_to_kill    
            } else {
                Write-Host 'Opt invalid!!!'
            }
        }
     }
    
}

Write-Host ('This script is being executed by the origin hostname ' + (hostname))

Write-Host 'Stoping services in all servers...'
Import-Csv $server_file -Delimiter ';' | ForEach-Object {Controller-Restart -csv_parametes_script $_ -StartOrStop 'STOP'}

Write-Host 'Starting services in all servers...'
Import-Csv $server_file -Delimiter ';' | ForEach-Object {Controller-Restart -csv_parametes_script $_ -StartOrStop 'START'}
