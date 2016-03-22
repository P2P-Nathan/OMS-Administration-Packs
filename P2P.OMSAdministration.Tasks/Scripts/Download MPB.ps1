Param([string]$certificateString,[string]$proxyUserName,[string]$proxyUserPassword,[string]$proxyUserDomain,[String]$filepaths,[String]$MPBName,[String]$DownloadURL,[String]$IsDynamic)

$Error.Clear()

function GetPathandLoadLibrary([String]$FilePaths,[String]$LibName)
    {
        Try
            {
                [String]$LibraryLocation
                $FilePathArray = $FilePaths.Split(",")
                $DllPath = $FilePathArray | ? {$_ -match $LibName}
                If ($DllPath.Length -lt 5) {Throw "Can't find the file path"}
                Else
                    {
                        $DLLBytes = [System.IO.File]::ReadAllBytes($DllPath)
                        [System.Reflection.Assembly]::Load($DLLBytes)
                    }
            }
        Catch
            {
                $api.LogScriptEvent("DiscoverOMSMPs.ps1",2000,1,"Failed to get Library $_")
            }
    }

#fingers crossed, String to Boolean
[boolean]$IsDynamic = [System.Boolean]::Parse($IsDynamic)

Write-Host "Attempting to download $MPBName"
Import-Module OperationsManager -ErrorAction SilentlyContinue
$setupKey = Get-Item -Path "HKLM:\Software\Microsoft\Microsoft Operations Manager\3.0\Setup"
$installDirectory = $setupKey.GetValue("InstallDirectory") | Split-Path
$psmPath = $installdirectory + ‘\Powershell\OperationsManager\OperationsManager.psm1’
Import-Module $psmPath -ErrorAction SilentlyContinue

New-SCOMManagementGroupConnection 'localhost' -ErrorAction Stop

[String]$MPLocation =  ([System.IO.Path]::GetTempFileName()).Replace('.tmp',$MPBName) #Its a Surprise!
$webClient = New-Object System.Net.WebClient

Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 7130 -Message "Downloading $MPBName from $DownloadURL" -Category 60	
If ($IsDynamic -eq 'True')
    {
		GetPathandLoadLibrary -FilePaths $FilePaths -LibName 'Microsoft.SystemCenter.Advisor.Common.dll'
		GetPathandLoadLibrary -FilePaths $FilePaths -LibName 'Microsoft.SystemCenter.Advisor.Core.Module.dll'

        [Microsoft.EnterpriseManagement.ManagementGroup] $managementGroup = Get-SCOMManagementGroup;
        [Microsoft.SystemCenter.Advisor.Core.WebService.IntelligenceServiceSettings]$Settings = New-Object Microsoft.SystemCenter.Advisor.Core.WebService.IntelligenceServiceSettings($ManagementGroup, $certificateString, $proxyUserDomain, $proxyUserName, $proxyUserPassword)
        $Client = New-Object -TypeName Microsoft.SystemCenter.Advisor.Core.WebService.IntelligenceServiceClient($Settings);
        [System.Array]$DynPackBytes = New-Object System.Byte[] 0                
        $DynPackBytes = $Client.GetDynamicManagementPack($MPName)
        [System.IO.File]::WriteAllBytes($MPLocation,$DynPackBytes)
    }
Else
    {
        $webClient.DownloadFile($DownloadURL,$MPLocation) 
    }

[string]$ErrorCount = $Error.Count
$EVTMessage = "Completed Pack Download; The error count was $ErrorCount;"
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 7131 -Message $EVTMessage
If ($Error -ne'0')
	{
		ForEach ($ER in $Error)
			{
				$ERString = $ER.tostring()
				$EVTMessage = "Pack Download Error: $ERString;"
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Error -EventId 7139 -Message $EVTMessage
			}
	}