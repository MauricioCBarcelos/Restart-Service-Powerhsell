# Restart-Service-Powerhsell

This PowerShell script is aimed at Windows server managers to help control reboot routines of one or more servers synchronously over winrm.

## Prerequisites
Before you begin, ensure you have met the following requirements:

* installed version of powershell 5.1 or latest
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

Ex
