Param([String]$SolutionName,$ShouldCreateGroups,$ShouldOverrideAtClass,$SolutionEleID)

$Error.Clear()
function MakeNewGroup([String]$GrpID,[String]$GrpDispName)
    {
        $document = new-object System.Xml.XMLDocument
        $rootElement = $document.CreateElement("Configuration")
        $document.AppendChild($rootElement) | Out-Null
        $membershipRuleElement = $document.CreateElement("MembershipRule")
        $membershipClassElement = $document.CreateElement("MonitoringClass")
        $membershipRelationshipElement = $document.CreateElement("RelationshipClass")
        $membershipExpressionElement = $document.CreateElement("Expression")
        $membershipClassElement.set_InnerText("`$MPEl"+"ement[Name=`"Windows!Microsoft.Windows.Computer`"]`$")  | Out-Null
        $membershipRelationshipElement.set_InnerText("`$MPEl"+"ement[Name=`"InstanceGroup!Microsoft.SystemCenter.InstanceGroupContainsEntities`"]`$")  | Out-Null
        $membershipExpressionElement.set_InnerXML("<SimpleExpression><ValueExpression><Value>True</Value></ValueExpression><Operator>Equal</Operator><ValueExpression><Value>False</Value></ValueExpression></SimpleExpression>")
        $rootElement.AppendChild($membershipRuleElement)  | Out-Null
        $membershipRuleElement.AppendChild($membershipClassElement) | Out-Null
        $membershipRuleElement.AppendChild($membershipRelationshipElement) | Out-Null
        $membershipRuleElement.AppendChild($membershipExpressionElement) | Out-Null
        $formula=$rootElement.get_InnerXml()

        [Microsoft.EnterpriseManagement.CreatableObjectGroup]$GroupObj = new-object Microsoft.EnterpriseManagement.Monitoring.CustomMonitoringObjectGroup($MPID,$GrpID,$GrpDispName,$formula)
        [Microsoft.EnterpriseManagement.Configuration.ManagementPackReferenceCollection]$newReferences = new-object Microsoft.EnterpriseManagement.Configuration.ManagementPackReferenceCollection
        $newReferences.Add("Windows",$windowsManagementPack)
        $newReferences.Add("InstanceGroup",$instanceGroupManagementPack)
        $MP.InsertCustomMonitoringObjectGroup($GroupObj,$newReferences)
                

    }

function OverrideMonitorClassLevel($Monitor)
	{
		$Target= Get-SCOMClass -id $Monitor.Target.id
		[String]$overridename=$Monitor.name+".Override"
		$override = New-Object Microsoft.EnterpriseManagement.Configuration.ManagementPackMonitorPropertyOverride($MP,$overridename)
		$override.Monitor = $Monitor
		$Override.Property = 'Enabled'
		$override.Value = 'false'
		$override.Context = $Target
		$override.DisplayName = $overridename
		$MonMsgName = $Monitor.Name
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5330 -Message "Overriding $MonMsgName for the class, setting to disabled" -Category 50
	}

function OverrideMonitorForGroup($Monitor,[String]$GroupID,[String]$EnableSetting,[Boolean]$Enforce=$false)
	{
		$Target= Get-SCOMClass -Name $GroupID
		[String]$overridename=$Monitor.name+".Override.For$GroupID"
		$override = New-Object Microsoft.EnterpriseManagement.Configuration.ManagementPackMonitorPropertyOverride($MP,$overridename)
		$override.Monitor = $Monitor
		$Override.Property = 'Enabled'
		$override.Value = $EnableSetting
		$override.Context = $Target
		$override.DisplayName = $overridename
		$override.Enforced = $Enforce
		$MonMsgName = $Monitor.Name
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5330 -Message "Overriding $MonMsgName with setting for $EnableSetting for $GroupID" -Category 50
	}

Function OverrideRuleClassLevel($Rule)
	{
		$Target= Get-SCOMClass -id $rule.Target.id
		$overridename=$rule.name+".Override"
		$override = New-Object Microsoft.EnterpriseManagement.Configuration.Management`PackRulePropertyOverride($MP,$overridename)
		$override.Rule = $rule
		$Override.Property = 'Enabled'
		$override.Value = 'false'
		$override.Context = $Target
		$override.DisplayName = $overridename
		$RuleMsgName = $rule.Name
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5321 -Message "Overriding $RuleMsgName for the class, set to disabled" -Category 50
	}

Function OverrideRuleForGroup($Rule,[String]$GroupID,[String]$EnableSetting,[Boolean]$Enforce=$false)
	{
		$Target= Get-SCOMClass -Name $GroupID
		$overridename=$rule.name+".Override.For$GroupID"
		$override = New-Object Microsoft.EnterpriseManagement.Configuration.Management`PackRulePropertyOverride($MP,$overridename)
		$override.Rule = $rule
		$Override.Property = 'Enabled'
		$override.Value = $EnableSetting
		$override.Context = $Target
		$override.DisplayName = $overridename
		$override.Enforced = $Enforce
		$RuleMsgName = $rule.Name
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5320 -Message "Overriding $RuleMsgName with setting for $EnableSetting for $GroupID" -Category 50
	}

function OverrideMPItems ([String]$MPFullName, [String]$EnableGroupID, [String]$DisableGroupID)
	{
		$MPToOverride = $MG.GetManagementPacks($MPFullName)
		$MPToOverride.GetRules() | % {
			OverrideRuleClassLevel -Rule $_
			OverrideRuleForGroup -Rule $_ -GroupID $EnableGroupID -EnableSetting 'true'
			OverrideRuleForGroup -Rule $_ -GroupID $DisableGroupID -EnableSetting 'false' -Enforce $true
		}
		$MPToOverride.GetMonitors() | % {
			OverrideMonitorClassLevel -Monitor $_
			OverrideMonitorForGroup -Monitor $_ -GroupID $EnableGroupID -EnableSetting 'true'
			OverrideMonitorForGroup -Monitor $_ -GroupID $DisableGroupID -EnableSetting 'false' -Enforce $true
		}


	}

function MakeAllOverrides ()
	{
		$SolutionInstance = Get-SCOMClassInstance -Id $SolutionEleId
		[GUID]$MPHostedByMPBID = 'd2510f2d-fb66-1255-3bb0-f97fb91f1acb'
		[System.Collections.ArrayList]$MPsToOverride = New-Object -TypeName System.Collections.ArrayList
		$RelatedItems = $SolutionInstance.GetMonitoringRelationshipObjects()| % {($_.TargetObject).GetMonitoringRelationshipObjects()}
		$MonitoringTargets = $RelatedItems  | ? {$_.MonitoringRelationshipClassId -eq $MPHostedByMPBID} | Select TargetObject
		ForEach ($Targ in $MonitoringTargets)
			{
				$MPsToOverride.Add(($Targ.TargetObject.Values | ? {$_.Type.ToString() -match 'MPName'}).ToString())        
			}
		[String[]]$UniqueMPs = $MPsToOverride | Select -Unique

		$EnableGroupID = "$MPID.EnableSolutionGroup"
        $DisableGroupID = "$MPID.DisableSolutionGroup"

		ForEach($MPFullName in $UniqueMPs)
			{
				OverrideMPItems $MPFullName $EnableGroupID $DisableGroupID
			}

		$MP.Verify()
		$MP.AcceptChanges()
			
	}

Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5000 -Message "Starting Override Pack checks for $SolutionName" -Category 50
#Try and Cast, cross fingers 
[Bool]$BoolCreateGroups = [System.Boolean]::Parse($ShouldCreateGroups)
[Bool]$BoolShouldOverride = [System.Boolean]::Parse($ShouldOverrideAtClass)

$CleanDisplayName = $SolutionName.Replace('.','')
$MPID = "P2P.OMSAdministration.SolutionControl.$CleanDisplayName"
$MPName = (($MPID.Replace('.',' '))).Replace('SolutionControl','Solution Override Control -')

Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5100 -Message "Determined that the Pack Name would be $MPID for $SolutionName" -Category 50

#Add Snapin then Connect Locally
Add-PSSnapin Microsoft.EnterpriseManagement.OperationsManager.Client
$MG = New-Object Microsoft.EnterpriseManagement.ManagementGroup('localhost')

#Load Modual and connect TOO
Import-Module OperationsManager -ErrorAction SilentlyContinue
$setupKey = Get-Item -Path "HKLM:\Software\Microsoft\Microsoft Operations Manager\3.0\Setup"
$installDirectory = $setupKey.GetValue("InstallDirectory") | Split-Path
$psmPath = $installdirectory + ‘\Powershell\OperationsManager\OperationsManager.psm1’
Import-Module $psmPath -ErrorAction SilentlyContinue

New-SCOMManagementGroupConnection 'localhost' -ErrorAction Stop

#Create Store and Pack
$MPStore = New-Object Microsoft.EnterpriseManagement.Configuration.IO.ManagementPackFileStore
$MP = New-Object Microsoft.EnterpriseManagement.Configuration.ManagementPack($MPID, $MPName, (New-Object Version(1, 0, 0)), $MPStore)
$FoundMP = $null
Try
    {
    #Before we go further, check for Installed Pack
    $FoundMP = $MG.GetManagementPacks($MPID)
    $PackInstallDate = $FoundMP.TimeCreated.ToLocalTime().ToString()
    Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5150 -Message "We found the pack $MPID for $SolutionName, it was installed on $PackInstallDate" -Category 50
    }
Catch
    {
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5151 -Message "We did not find the pack $MPID for $SolutionName, Time to make it" -Category 50
    }
If ($FoundMP -eq $null)
    {
        #time to get to work
        #Modify Then Import the MP
        $MP.DisplayName = $MPName
        $MP.Description = "Auto Generated Management Pack!  This pack contains groups and overrides that allow for more granular control of OMS Solutions"
        $MP.AcceptChanges()
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5210 -Message "$MPID Created, Adding to the ManagementGroup" -Category 50
        $MG.ImportManagementPack($MP)
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5220 -Message "$MPID Added to the ManagementGroup, Sleeping for a minute and then, atempting to retrive the Live Object" -Category 50
        sleep -Seconds 60
		#Reconnecting as sometimes it doesn't find out pack.
		$MG = New-Object Microsoft.EnterpriseManagement.ManagementGroup('localhost')
		$MP = $MG.GetManagementPacks($MPID)[0]
		$ReturnedMPName = $MP.DisplayName
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5221 -Message "Done Naping for $MPID, the Display name of the Returned MP was $ReturnedMPName" -Category 50
        $windowsManagementPack = $mg.GetManagementPack([Microsoft.EnterpriseManagement.Configuration.SystemManagementPack]::Windows)
        $instanceGroupManagementPack = $mg.GetManagementPack([Microsoft.EnterpriseManagement.Configuration.SystemManagementPack]::Group)
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5230 -Message "We were able to get all the required resources to proceed with $MPID creation" -Category 50

        If ($BoolCreateGroups)
            {
                Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5250 -Message "Creating the Enable and Disable groups for $MPID" -Category 50
                #Time to create our Stub Groups
                $EnableGroupID = "EnableSolutionGroup"
                $DisableGroupID = "DisableSolutionGroup"
                $EnableGroupDisplayName = "$SolutionName Enable Solution workflows Group"
                $DisableGroupDisplayName = "$SolutionName Disable Solution workflows Group"
                
                MakeNewGroup $EnableGroupID $EnableGroupDisplayName 
                MakeNewGroup $DisableGroupID $DisableGroupDisplayName
                Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5250 -Message "Both the Enable and Disable groups for $MPID have been created" -Category 50
				$MP.Verify()
				$MP.AcceptChanges()
            }
		If ($BoolShouldOverride)
			{
				MakeAllOverrides
			}
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5510 -Message "Management Pack Process is Completed for: $SolutionName" -Category 50
    }
Else
    {
		If ($BoolShouldOverride)
			{
				$MP = $MG.GetManagementPacks($MPID)[0]
				MakeAllOverrides
			}
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5501 -Message "Management Pack Process is Completed for: $SolutionName" -Category 50
    }


[string]$ErrorCount = $Error.Count
$EVTMessage = "Completed Pack Generation; The error count was $ErrorCount;"
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5001 -Message $EVTMessage
If ($Error -ne'0')
	{
		ForEach ($ER in $Error)
			{
				$ERString = $ER.tostring()
				$EVTMessage = "Pack Generation Error: $ERString;"
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Error -EventId 5090 -Message $EVTMessage
			}
	}
