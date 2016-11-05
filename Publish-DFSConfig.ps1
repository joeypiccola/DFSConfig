<#
.SYNOPSIS
short desc

.DESCRIPTION
long desc

.NOTES
Author: Joey Piccola
Last Modified: 05/05/16
Version: 11.04.16
Req: The exe makecert.exe MUST exist in the same directory as this script! 
#>

[CmdletBinding()]
Param (
    [Parameter()]
    [System.Management.Automation.CredentialAttribute()]$Credential
)

. .\configuration.ps1

DFSConfig -OutputPath .\mofs -ConfigurationData .\configdata.psd1 -credential $Credential
# change the name of our mof from localhost to our configuratoin name
Move-Item ".\mofs\`localhost.mof" ".\mofs\DFSConfig.mof" -Force
Move-Item -Path .\mofs\DFSConfig.mof '\\dscpull01\c$\users\joey.piccola\Desktop\configs\DFSConfig.mof' -Force
Invoke-Command -ComputerName dscpull01 -ScriptBlock {Publish-DSCModuleandMOF -source 'c:\users\joey.piccola\desktop\configs'}