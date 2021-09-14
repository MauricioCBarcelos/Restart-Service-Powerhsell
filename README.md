# Restart-Service-Powerhsell

This PowerShell script is aimed at Windows server managers to help control reboot routines of one or more servers synchronously over winrm.

## Prerequisites
Before you begin, ensure you have met the following requirements:

* Installed version of powershell 5.1 or latest
* Windows OS.
* Winrm support.
  * More about winrm: https://docs.microsoft.com/en-us/windows/win32/winrm/portal 


## Installing

* In powerhsell terminal execute the command below in all servers to allow execution of the powershell script:
```powershell
 Set-ExecutionPolicy RemoteSigned
```
* In cmd terminal execute the command below in all servers to allow the winrm functions:
```
 winrm quickconfig
```

In the server where the script will be executed, you need to add the servers in TrustedHosts of winrm:

* provide a single, comma-separated, string of computer names
```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'machineA,machineB'
```
* or (dangerous) a wild-card:

```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'
```

* to append to the list, the -Concatenate parameter can be used:

```powershell
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'machineC' -Concatenate
```

More about the tutorial above in: https://stackoverflow.com/questions/21548566/how-to-add-more-than-one-machine-to-the-trusted-hosts-list-using-winrm

## Using

On the source machine where the script will be run, deploy the restart_services.ps1 and servers.csv files.

* The servers.csv file must have the columns below and the must and the data must be separated by semicolon(;):
  * server: ip address or hostname .
  * user(Optional): user credential.
  * password(Optional): password credential.
  * script_path: path on remote or local server where the script will import the library Restart_Service_lib.psm1.
  * file_of_services: path on remote or local server where the script will read the file list_of_services.csv to restart the windows services.

On local or remote servers where the routine is run, where the windows service restart routine will run, extract the Restart_Service_lib.psm1 and list_of_services.csv files in the same path configured in the servers.csv file.

* The list_of_services.csv file must have the columns below and the must and the data must be separated by semicolon(;):
  * name: Display name or the name of windows service.
  * timeout_to_kill: the -------
  * attempts_to_start_service:
  * time_to_start_service_again:
