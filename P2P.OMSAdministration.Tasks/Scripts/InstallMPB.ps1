Param([string]$certificateString,[string]$proxyUserName,[string]$proxyUserPassword,[string]$proxyUserDomain,[String]$filepaths,[String]$MPBName,[String]$DownloadURL,[String]$IsDynamic, [String]$SolutionName)

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


Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 7120 -Message "Installing $MPBName from $DownloadURL" -Category 60	

Import-Module OperationsManager -ErrorAction SilentlyContinue
$setupKey = Get-Item -Path "HKLM:\Software\Microsoft\Microsoft Operations Manager\3.0\Setup"
$installDirectory = $setupKey.GetValue("InstallDirectory") | Split-Path
$psmPath = $installdirectory + ‘\Powershell\OperationsManager\OperationsManager.psm1’
Import-Module $psmPath -ErrorAction SilentlyContinue

New-SCOMManagementGroupConnection 'localhost' -ErrorAction Stop

#fingers crossed, String to Boolean
[boolean]$IsDynamic = [System.Boolean]::Parse($IsDynamic)

[String]$MPLocation =  ([System.IO.Path]::GetTempFileName()).Replace('.tmp',$MPBName) #Its a Surprise!
$webClient = New-Object System.Net.WebClient

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

Import-SCOMManagementPack $MPLocation


try
    {
        Remove-Item $MPLocation -ErrorAction SilentlyContinue
    }
Catch
    {
		Write-Host "Failed to remove the Temp file located at $MPLocation, OpsMgr likely has a lock on the MPB"
        #Lets Try to Remove this, It will Likely fail as OpsMgr is going to Lock the file.
    }

[string]$ErrorCount = $Error.Count
$EVTMessage = "Completed Pack Installation; The error count was $ErrorCount;"
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 7121 -Message $EVTMessage
$EVTMessage = "Generate Admin Pack For $SolutionName"
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5105 -Message $EVTMessage
If ($Error -ne'0')
	{
		ForEach ($ER in $Error)
			{
				$ERString = $ER.tostring()
				$EVTMessage = "Pack Installation Error: $ERString;"
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Error -EventId 7129 -Message $EVTMessage
			}
	}