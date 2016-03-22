Param([string]$certificateString,[string]$proxyUserName,[string]$proxyUserPassword,[string]$proxyUserDomain,$FilePaths)

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

function CheckMPVersionStatus([Microsoft.AttachedServices.WebService.ManagementPackInfo]$OMSPack)
    {
        $LocalPack = $null
		$LocalPack = Get-SCOMManagementPack -Name $OMSPack.Name
        If ($OMSPack.Version -eq $LocalPack.Version)
            {
                #We are on-par with OMS, thats Great
                ##Raise Version Property Bag Here
                #$api.LogScriptEvent('MP Version is Good', 3713, 0, $OMSPack.Name)
				$EVTMessage = 'Following MP Version is Good: {0}' -f $OMSPack.Name 
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 3713 -Message $EVTMessage
            }
        Else
            {
                IF ($LocalPack -ne $null)
					{
						##We Need to alert that versions don't match
						#$api.LogScriptEvent('MP Version is Bad', 3703, 0, $OMSPack.Name)						
						$EVTMessage = 'Following MP Version is BAD: {0}' -f $OMSPack.Name 
						Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Warning -EventId 3703 -Message $EVTMessage
					}
				Else
					{
						##We don't have this pack, so version mismatch isn't an issue
						#$api.LogScriptEvent('MP not installed', 3713, 0, $OMSPack.Name)
					}
				
            }
    }

function CheckMPInstallStatus([Microsoft.AttachedServices.WebService.ManagementPackInfo]$OMSPack)
    {
        $LocalPack = Get-SCOMManagementPack -Name $OMSPack.Name
        If ($LocalPack)
            {
                Return $true
            }
        Else
            {
                Return $false
            }
    }

function NoOtherReqs([Microsoft.AttachedServices.WebService.ManagementPackInfo]$OMSPack)
    {
		#If we are going to delete a pack we need to make sure no one else needs it
        $OtherPackInst = $RequiredPacks | ? {$_.Name -eq $OMSPack.Name}
        If ($OtherPackInst)
            {
                Return $false
            }
        Else
            {
                Return $true
            }
    }

function CheckPacksToInstall([Microsoft.AttachedServices.WebService.ManagementPackBundleInfo]$MPBundle)
    {
        If ($MPBundle.IsDisabled -eq $false)
            {
                #This Should be Installed
                ForEach($OMSMP in $MPBundle.ManagementPacks)
                    {
                        If (CheckMPInstallStatus $OMSMP)
                            {
                                #Things Look Good Here
								#$api.LogScriptEvent('MP Already Installed', 3712, 0, ($OMSMP.Name))								
								$EVTMessage = 'Following MP Is Installed: {0}' -f $OMSMP.Name 
								Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 3712 -Message $EVTMessage
                            }
                        Else
                            {
                                #We Are missing this pack and should have it!
                                #$api.LogScriptEvent('Need to Add MP', 3702, 0, ($OMSMP.Name))
								$EVTMessage = 'Following MP Needs Installation: {0}' -f $OMSMP.Name 
								Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Warning -EventId 3702 -Message $EVTMessage
                            }
                    }
            }
        Else
            {
                #This Should be Removed
                ForEach($OMSMP in $MPBundle.ManagementPacks)
                    {
                        If ((CheckMPInstallStatus $OMSMP) -and (NoOtherReqs $OMSMP) )
                            {
                                #We have an Extra MP!
                                #$api.LogScriptEvent('May Need to Delete MP', 3701, 0, ($OMSMP.Name))
								$EVTMessage = 'Following MP May Need Deletion: {0}' -f $OMSMP.Name 
								Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Warning -EventId 3701 -Message $EVTMessage

                            }
                        Else
                            {
                                #Things Look Good Here
								#$api.LogScriptEvent('MP Does Not Need Deletion', 3711, 0, ($OMSMP.Name))
								$EVTMessage = 'Following MP DOES NOT Need Deletion: {0}' -f $OMSMP.Name 
								Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 3711 -Message $EVTMessage
                            }
                    }
            }
    }
    


$api = New-Object -comObject 'MOM.ScriptAPI'
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Error -EventId 3780 -Message "Checking MP Version and Status"
$Error.Clear()

GetPathandLoadLibrary -FilePaths $FilePaths -LibName 'Microsoft.SystemCenter.Advisor.Common.dll'
GetPathandLoadLibrary -FilePaths $FilePaths -LibName 'Microsoft.SystemCenter.Advisor.Core.Module.dll'

Import-Module OperationsManager -ErrorAction SilentlyContinue
$setupKey = Get-Item -Path "HKLM:\Software\Microsoft\Microsoft Operations Manager\3.0\Setup"
$installDirectory = $setupKey.GetValue("InstallDirectory") | Split-Path
$psmPath = $installdirectory + ‘\Powershell\OperationsManager\OperationsManager.psm1’
Import-Module $psmPath -ErrorAction SilentlyContinue

New-SCOMManagementGroupConnection 'localhost' -ErrorAction Stop

[Microsoft.EnterpriseManagement.ManagementGroup] $managementGroup = Get-SCOMManagementGroup;
[Microsoft.SystemCenter.Advisor.Core.WebService.IntelligenceServiceSettings]$Settings = New-Object Microsoft.SystemCenter.Advisor.Core.WebService.IntelligenceServiceSettings($ManagementGroup, $certificateString, $proxyUserDomain, $proxyUserName, $proxyUserPassword)
$Client = New-Object -TypeName Microsoft.SystemCenter.Advisor.Core.WebService.IntelligenceServiceClient($Settings);
$ClientProperties = New-Object Microsoft.AttachedServices.WebService.ClientProperties
$ClientProperties.version = 1
$IntelPacksInfo = $Client.GetIntelligencePacksInfo($ClientProperties)
$RequiredPacks = $IntelPacksInfo | ? {$_.isDisabled -eq $false} | % {$_.managementpacks} | Select Name

ForEach ($MPBundle in $IntelPacksInfo)
    {
		$EvtMsgString = 'Processing MPB Bundle ' + $MPBundle.Name
		#$api.LogScriptEvent('CheckOMSMPState', 3750, 0, ($EvtMsgString))
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 3750 -Message $EvtMsgString
		CheckPacksToInstall -MPBundle $MPBundle

        ForEach ($MP in $MPBundle.ManagementPacks)
            {
				$EvtMsgString = 'Processing MP Bundle ' + $MP.Name
				#$api.LogScriptEvent('CheckOMSMPState', 3751, 0, ($EvtMsgString))
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 3751 -Message $EvtMsgString
                CheckMPVersionStatus -OMSPack $MP
            }
    }

[string]$ErrorCount = $Error.Count
$EvtMessage = "Completed MP Checking; The error count was $ErrorCount;"
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 3781 -Message $EvtMessage
If ($Error -ne'0')
	{
		ForEach ($ER in $Error)
			{
				$ERString = $ER.tostring()				
				$EVTMessage = "MP Checking Error $ERString;" 
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Error -EventId 3790 -Message $EVTMessage
			}
	}