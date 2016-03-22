Param([String]$ManagementPackName,[String]$SolutionName)

Import-Module OperationsManager -ErrorAction SilentlyContinue
$setupKey = Get-Item -Path "HKLM:\Software\Microsoft\Microsoft Operations Manager\3.0\Setup"
$installDirectory = $setupKey.GetValue("InstallDirectory") | Split-Path
$psmPath = $installdirectory + ‘\Powershell\OperationsManager\OperationsManager.psm1’
Import-Module $psmPath -ErrorAction SilentlyContinue

New-SCOMManagementGroupConnection 'localhost' -ErrorAction Stop

#Produce IDs so we can clean our pack.
$CleanDisplayName = $SolutionName.Replace('.','')
$MPID = "P2P.OMSAdministration.SolutionControl.$CleanDisplayName"

Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5600 -Message "Deleting Management Pack $ManagementPackName for Solution $SolutionName" -Category 50

$FoundMP = $null
Try
    {
		#Before we go further, check for Installed Pack
		$FoundMP = $MG.GetManagementPacks($MPID)
		If ($FoundMP -ne $null)
			{
				$PackInstallDate = $FoundMP.TimeCreated.ToLocalTime().ToString()
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5650 -Message "We found the pack $MPID for $SolutionName, it was installed on $PackInstallDate.  This will be deleted as part of the Process." -Category 50
				Remove-SCOMManagementPack -ManagementPack $FoundMP -ErrorAction SilentlyContinue	
			}
		Else
			{
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5651 -Message "We did not find the Override pack $MPID for $SolutionName" -Category 50
			}
    }
Catch
    {
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5651 -Message "We did not find the Override pack $MPID for $SolutionName" -Category 50
    }

Get-SCOMManagementPack -Name $ManagementPackName | Remove-SCOMManagementPack

[string]$ErrorCount = $Error.Count
Write-Host "Task Completed; The error count was $ErrorCount;"
If ($Error -ne'0')
	{
		ForEach ($ER in $Error)
			{
				$ERString = $ER.tostring()
				Write-Host $ERString
			}
	}