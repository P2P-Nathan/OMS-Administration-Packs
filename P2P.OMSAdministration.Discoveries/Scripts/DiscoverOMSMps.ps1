﻿Param($sourceId, $managedEntityId,[string]$certificateString,[string]$proxyUserName,[string]$proxyUserPassword,[string]$proxyUserDomain,$FilePaths,$DiscoveryType)

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

Function DiscoverMP([Microsoft.AttachedServices.WebService.ManagementPackInfo]$OMSPack, [Microsoft.AttachedServices.WebService.ManagementPackBundleInfo]$MPBundle)
    {
		$LocalPack = Get-SCOMManagementPack -Name $OMSPack.Name
		If($LocalPack)	
			 {
				$LocalPackVer = $LocalPack.Version.ToString()
			 }		
		Else
			{
			$LocalPackVer = 'Not Installed'
			}

		If ($MPBundle.IsDynamic)
			{
				$SolutionName = 'DynamicPacks'
				$SolutionURL = 'N/A'
			}
		Else
			{			
				$SolutionName = ($MPBundle.downloadURL.Segments[3]).Replace('/','')
				$SolutionURL = (($MPBundle.downloadURL.OriginalString).Replace($MPBundle.name,''))
			}

		$PrettyName = ($OMSPack.Name).Replace('Microsoft.IntelligencePacks.','').Replace('.mp','')

		#$api.LogScriptEvent("DiscoverOMSMPs.ps1",2200,0,"Discovering ManagementPack $PrettyName")
		$PrincipalName = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain
		[string]$EVTMessage = "Discovering ManagementPack $PrettyName within $SolutionName"
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 2630 -Message $EVTMessage


        $instanceOMS_MP = $discoveryData.CreateClassInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPack']$")
		$instanceOMS_MP.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$",$PrincipalName)
		$instanceOMS_MP.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSSolution']/URLPath$",$SolutionURL)
		$instanceOMS_MP.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']/MPBName$",$MPBundle.Name.ToString())
		$instanceOMS_MP.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$",$PrettyName)
		$instanceOMS_MP.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPack']/MPName$",$OMSPack.Name)
        $instanceOMS_MP.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPack']/InstalledVersion$",$LocalPackVer)
		$instanceOMS_MP.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPack']/ReleasedVersion$",$OMSPack.Version.ToString())
        $instanceOMS_MP.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPack']/PublicKeyToken$",$OMSPack.PublicKeyToken.ToString())
		$discoveryData.AddInstance($instanceOMS_MP)

		$BundleName = ($MPBundle.Name.ToString().Replace('.mpb',''))
		$SolutionName = ($MPBundle.downloadURL.Segments[3]).Replace('/','')
		$SolutionURL = (($MPBundle.downloadURL.OriginalString).Replace($MPBundle.name,''))

		$instanceOMS_MPB = $discoveryData.CreateClassInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']$")
		$instanceOMS_MPB.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$",$PrincipalName)
		$instanceOMS_MPB.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$",$BundleName)
		$instanceOMS_MPB.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSSolution']/URLPath$",$SolutionURL)
		$instanceOMS_MPB.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']/MPBName$",$MPBundle.Name.ToString())

		$MPBHostMPRelationship = $discoveryData.CreateRelationshipInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Relationships.BundleHostsManagementPacks']$")
        $MPBHostMPRelationship.Source = $instanceOMS_MPB
        $MPBHostMPRelationship.Target = $instanceOMS_MP
        $discoveryData.AddInstance($MPBHostMPRelationship)


    }

Function DiscoveryBundle([Microsoft.AttachedServices.WebService.ManagementPackBundleInfo]$MPBundle)
	{

		$BundleName = ($MPBundle.Name.ToString().Replace('.mpb','')).Replace('Microsoft.IntelligencePacks.','')
		If ($MPBundle.IsDynamic)
			{
				$SolutionName = 'DynamicPacks'
				$SolutionURL = 'N/A'
			}
		Else
			{			
				$SolutionName = ($MPBundle.downloadURL.Segments[3]).Replace('/','')
				$SolutionURL = (($MPBundle.downloadURL.OriginalString).Replace($MPBundle.name,''))
			}
		$BundleURL = $MPBundle.DownloadURL.ToString()
		#$api.LogScriptEvent("DiscoverOMSMPs.ps1",2200,0,"Discovering Bundle $SolutionName with URL $BundleURL")
		
		[string]$EVTMessage = "Discovering Bundle $SolutionName with URL $BundleURL"
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 2620 -Message $EVTMessage

		$PrincipalName = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain

		$instanceOMS_MPB = $discoveryData.CreateClassInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']$")
		$instanceOMS_MPB.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$",$BundleName)
		$instanceOMS_MPB.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$",$PrincipalName)
		$instanceOMS_MPB.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSSolution']/URLPath$",$SolutionURL)
		$instanceOMS_MPB.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']/MPBName$",$MPBundle.Name.ToString())
		$instanceOMS_MPB.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']/DownloadURL$",$MPBundle.DownloadURL.ToString())
		$instanceOMS_MPB.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']/IsDynamic$",$MPBundle.IsDynamic.ToString())
		$instanceOMS_MPB.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSManagementPackBundle']/IsDisabled$",$MPBundle.IsDisabled.ToString())
		$discoveryData.AddInstance($instanceOMS_MPB)

		$instanceOMS_Solution = $discoveryData.CreateClassInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSSolution']$")
		$instanceOMS_Solution.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$",$PrincipalName)
		$instanceOMS_Solution.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$",$SolutionName)
		$instanceOMS_Solution.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSSolution']/URLPath$",$SolutionURL)
        

		$SolutionHostMPBRelationship = $discoveryData.CreateRelationshipInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Relationships.SolutionHostsManagementPackBundle']$")
        $SolutionHostMPBRelationship.Source = $instanceOMS_Solution
        $SolutionHostMPBRelationship.Target = $instanceOMS_MPB
        $discoveryData.AddInstance($SolutionHostMPBRelationship)

	}

Function DiscoverSolution([Microsoft.AttachedServices.WebService.ManagementPackBundleInfo]$MPBundle)
	{
		If ($MPBundle.IsDynamic)
			{
				$SolutionName = 'DynamicPacks'
				$SolutionURL = 'N/A'
			}
		Else
			{			
				$SolutionName = ($MPBundle.downloadURL.Segments[3]).Replace('/','')
				$SolutionURL = (($MPBundle.downloadURL.OriginalString).Replace($MPBundle.name,''))
			}

		#$api.LogScriptEvent("DiscoverOMSMPs.ps1",2200,0,"Discovering Solution $SolutionName with URL $SolutionURL")
		
		[string]$EVTMessage = "Discovering Solution $SolutionName with URL $SolutionURL"
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 2610 -Message $EVTMessage
		$PrincipalName = (Get-WmiObject win32_computersystem).DNSHostName+"."+(Get-WmiObject win32_computersystem).Domain

		$instanceOMS_Solution = $discoveryData.CreateClassInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSSolution']$")
		$instanceOMS_Solution.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$",$PrincipalName)
		$instanceOMS_Solution.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$",$SolutionName)
		$instanceOMS_Solution.AddProperty("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSSolution']/URLPath$",$SolutionURL)
        $discoveryData.AddInstance($instanceOMS_Solution)

		$instanceOMS_Installation = $discoveryData.CreateClassInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Classes.OMSInstallation']$")
		$instanceOMS_Installation.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$",$PrincipalName)
		$instanceOMS_Installation.AddProperty("$MPElement[Name='System!System.Entity']/DisplayName$","Operations Manager Administration")
		$discoveryData.AddInstance($instanceOMS_Installation)

		$InstanceRMS = $discoveryData.CreateClassInstance("$MPElement[Name='Windows!Microsoft.Windows.Computer']$")
		$InstanceRMS.AddProperty("$MPElement[Name='Windows!Microsoft.Windows.Computer']/PrincipalName$",$PrincipalName)

		$instanceRMSOMSHost = $discoveryData.CreateRelationshipInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.RMSHostsInstallation']$")
        $instanceRMSOMSHost.Source = $InstanceRMS
        $instanceRMSOMSHost.Target = $instanceOMS_Installation
        $discoveryData.AddInstance($instanceRMSOMSHost)

        $instanceOMSHostRelationship = $discoveryData.CreateRelationshipInstance("$MPElement[Name='P2PAdmin!P2P.OMSAdministration.Relationships.OMSInstallationHostsSolution']$")
        $instanceOMSHostRelationship.Source = $instanceOMS_Installation
        $instanceOMSHostRelationship.Target = $instanceOMS_Solution
        $discoveryData.AddInstance($instanceOMSHostRelationship)
	}

$api = New-Object -comObject 'MOM.ScriptAPI'
$discoveryData = $api.CreateDiscoveryData(0, $SourceId, $ManagedEntityId)

#$api.LogScriptEvent("DiscoverOMSMPs.ps1",2202,0,"Discovery is running with type $DiscoveryType")
[string]$EVTMessage = 'Begining OMS Object Discovery'
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 2800 -Message $EVTMessage

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

#If ($DiscoveryType -eq 'Solution')
#	{
		ForEach ($MPBundle in $IntelPacksInfo)
		{
			DiscoverSolution $MPBundle
		}
#	}

	
#If ($DiscoveryType -eq 'MPBundle')
#	{
		ForEach ($MPBundle in $IntelPacksInfo)
		{
			DiscoveryBundle $MPBundle
		}
#	}

#If ($DiscoveryType -eq 'ManagementPack')
#	{
		ForEach ($MPBundle in $IntelPacksInfo)
		{
			ForEach ($MP in $MPBundle.ManagementPacks)
				{
					DiscoverMP -OMSPack $MP -MPBundle $MPBundle
				}
		}
#	}

[string]$ErrorCount = $Error.Count
[string]$EVTMessage = "Completed Discovery; The error count was $ErrorCount;"
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 2801 -Message $EVTMessage
If ($Error -ne'0')
	{
		ForEach ($ER in $Error)
			{
				$ERString = $ER.tostring()
				[string]$EVTMessage = "Discovery Error $ERString;"
				Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Error -EventId 2890 -Message $EVTMessage
			}
	}

$discoveryData