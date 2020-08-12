<#
Get-ChildItem C:\Temp | Select-Object -Property FullName, Length, CreationTime, Attributes | ConvertTo-Html | Set-Content C:\Temp\ConvertToHtml.html
&explorer C:\Temp\ConvertToHtml.html

$env:PSModulePath
$env:PSModulePath.split(";")
$env:PSModulePath.split(";")[0]
$env:PSModulePath.split(";")[1]

dot sourcing:
. .\myscript.ps1

remove dout sourcing:
del function:\myfunction

$name = Read-Host -Prompt "Enter server name"
switch -Regex ($name){
    "DC" {Write-Host "is a domain controller"}
    "TOP" {Write-Host "my pc name"}
    "PARENT"{Write-Host "my domain controller"}
}

if ($name -match "TOP") {Write-Host "my computer name"}
#>

Function Get-ExportVmAsOvf
{
    <#
.SYNOPSIS
   This is help synopsis for function get-cbh
.DESCRIPTION
   Some inline comment based help for a function Note the
   link points to ETree.Org's collection of live GD recordings!
.EXAMPLE
    #PS C:\> Get-ExportVmAsOvf -Domain REDINK -Servers REDINKPP01
    #
    #REDINKPP01 = REDINKPP01
    #PS C:\> Get-ExportVmAsOvf -Domain REDINK -Servers REDINKPP01,REDINKPP02
    #
    #REDINKPP01 = REDINKPP01
    #REDINKPP02 = REDINKPP02
    #
    #
    #PS C:\> Get-ExportVmAsOvf -Domain REDINK
    #
    #UREDINKAPP01 = UREDINKAPP01
    #UREDINKAPP02 = UREDINKAPP02
    #UREDINKAPP03 = UREDINKAPP03
    #UREDINKAPP04 = UREDINKAPP04
    #UREDINKMGT01 = UREDINKMGT01
    #UREDINKMGT02 = UREDINKMGT02
    #UREDINKDPS01 = UREDINKDPS01
    #UREDINKSPL01 = UREDINKSPL01
    #UREDINKADS01 = UREDINKADS01
    #UREDINKASD02 = UREDINKASD02
    #UREDINKVCS01 = UREDINKVCS01
.EXAMPLE
   Get-help get-cbh -online
   Takes you to Bt.Etree.Org - where you can download more GD Shows!
#>
    [CmdletBinding()]
    #instead of using ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$True)], you can use OutputType
	param
	(
        [Parameter(ParameterSetName="Domain", Position=1, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateLength(7,7)]
        [String]$Domain,

        [Parameter(ParameterSetName="Server", Position=2, HelpMessage='Enter Hostname(S) e.g UREDINKPP01, UREDINKPP02', ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('Hostname')]
        [String[]]$Servers = @("U${Domain}APP01","U${Domain}APP02","U${Domain}APP03","U${Domain}APP04","U${Domain}MGT01","U${Domain}MGT02","U${Domain}DPS01","U${Domain}SPL01","U${Domain}ADS01","U${Domain}ASD02","U${Domain}VCS01")

    )

    begin {}

	# 0..10 | foreach {
	# 	[pscustomobject]@{ 'Name' = "VM$PSItem"; 'HostName' = "U${Domain}APP01" }
    # }

    <#
    $cimParams=@{
        Classname = "win32_logicaldisk"
        Filter = "deviceid='c:'"
        ErrorAction = "continue"
    }
    #>

   process {

        try {

            $data1 = foreach ($Server in $Servers) {
                [pscustomobject][ordered]@{
                    Item = $Servers.IndexOf($Server)
                    HostName = $Server
                }
            }
            #return $data1   #return the object to pipeline; run this to retrieve it -> Get-ExportVmAsOvf -Domain REDINK|select -expand hostname
            #$data | sort Item | select Item, HostName
            #$data | Select -expand Hostname

            $data2 = foreach ($Server in $Servers) {
                $properties = [ordered]@{
                    Item = $Servers.IndexOf($Server)
                    HostName = $Server
                }
                New-Object -TypeName PSObject -Property $properties
            }

            #$wsh = new-object -com wscript.shell
            #$wsh.Popup.OverloadDefinitions
            #$wsh.Popup("Isn't this fun?",10,"PowerShell Automation",0+64)
            #$wsh.Popup("Failed to do something. Do you want to try again?",-1,"Script Error",4+32)


            #$data2 | Out-GridView

            return $data2 #return the object to pipeline; run this to retrieve it -> Get-ExportVmAsOvf -Domain REDINK|select -expand hostname
            #$data2 | sort Item | select Item, HostName
            #$data2 | Select -expand Hostname
            #$data2.GetEnumerator() | select -expand Item | Where {$_.Item -le 7} | sort item -Desc



            $data3 = foreach ($Server in $Servers) {
                $hash =[ordered]@{
                    Item = $Servers.IndexOf($Server)
                    HostName = $Server
                }
                [pscustomobject]$hash
            }
            #return $data3   #return the object to pipeline; run this to retrieve it -> Get-ExportVmAsOvf -Domain REDINK|select -expand hostname
            #$data3 | sort Item | select Item, HostName
            #$data3 | Select -expand Hostname


            foreach ($Server in $Servers) {
            "$Server = " + $Server
            }
        }catch{
            Write-Warning "Failed to get data from $Server"
            Write-Warning $_.exception
        } Finally {
            # Write-Host "This is optional and always runs" -ForegroundColor Green
            #Disconnect vCenter
        }
   }
   #end {return $data2}
   end {return}
   #end { Write-Output $data2}
   #end {$data2 | Out-File $data2File}
   #end {
   #    #return the XML
   #    $xml.Document.ToString()
   #}
}

. F:\scripts\VMware\ExportVmAsOvf.ps1
Get-ExportVmAsOvf -Domain REDINK

#get-help Get-ExportVmAsOvf
#@("REDINKpp01", "REDINKpp02") | Get-ExportVmAsOvf

#ByValue won't work but byProperty works; see NoteProperty below ComputerName and DriverType
# GetType      Method       type GetType()
# ToString     Method       string ToString()
# ComputerName NoteProperty System.String ComputerName=DESKTOP-N5523PQ
# DriveType    NoteProperty System.String DriveType=local
