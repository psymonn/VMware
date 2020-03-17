Setup Powershell offline for linux:
https://davidwzhang.com/2018/06/21/install-powernsx-offline-on-rhel7/
https://thesysadminchannel.com/install-vmware-powercli-module-powershell/

check env:
($env:PSModulePath).split(":")

download powercli (just get the latest one):
https://code.vmware.com/web/tool/11.2.0/vmware-powercli

turn off ssl error and stuffs:
Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCeip $false -InvalidCertificateAction Ignore

https://cloudhat.eu/powercli-11-1-0-linux/
error:
Import-Module : VMware.VimAutomation.License module is not currently supported on the Core edition of PowerShell.

solution:
modify the RquireModules in VMware.PowerCLI.psd1 to look like below:

RequiredModules = @(
@{"ModuleName"="VMware.VimAutomation.Sdk";"ModuleVersion"="11.0.0.10334495"}
@{"ModuleName"="VMware.VimAutomation.Common";"ModuleVersion"="11.0.0.10334497"}
@{"ModuleName"="VMware.Vim";"ModuleVersion"="6.7.0.10334489"}
@{"ModuleName"="VMware.VimAutomation.Core";"ModuleVersion"="11.0.0.10336080"}
@{"ModuleName"="VMware.VimAutomation.Vds";"ModuleVersion"="11.0.0.10336077"}
@{"ModuleName"="VMware.VimAutomation.Vmc";"ModuleVersion"="11.0.0.10336076"}
@{"ModuleName"="VMware.VimAutomation.Nsxt";"ModuleVersion"="11.0.0.10364044"}
@{"ModuleName"="VMware.VimAutomation.Storage";"ModuleVersion"="11.0.0.10380343"}
@{"ModuleName"="VMware.VimAutomation.StorageUtility";"ModuleVersion"="1.3.0.0"}
#@{"ModuleName"="VMware.VumAutomation";"ModuleVersion"="6.5.1.7862888"}
@{"ModuleName"="VMware.VimAutomation.Security";"ModuleVersion"="11.0.0.10380515"}
)
