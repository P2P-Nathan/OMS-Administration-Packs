if ($env:PSModulePath -notlike "*\PowerShell\OperationsManager*") {
$setupKey = Get-Item -Path "HKLM:\Software\Microsoft\Microsoft Operations Manager\3.0\Setup"
$installDirectory = $setupKey.GetValue("InstallDirectory") | Split-Path
$psmPath = $installdirectory + ‘\Powershell\OperationsManager\OperationsManager.psm1’
Import-Module $psmPath
}

$RAAccount = Get-SCOMRunAsAccount -Name 'Microsoft.SystemCenter.Advisor.RunAsAccount.Certificate'
$RAProfile = Get-SCOMRunAsProfile -Name 'P2P.OMSAdministration.CertificateRunAs'
Try 
    {
        $TargetClass = Get-SCOMClass -Name 'P2P.OMSAdministration.Classes.OMSInstallation'
        Set-SCOMRunAsProfile -Action "Add" -Profile $RAProfile -Account $RAAccount -Class $TargetClass
    }
Catch
    {
        #we Already have this in our profile and there doesn't appear to be a way to detect it
    }
Try 
    {
        $TargetClass = Get-SCOMClass -Name 'P2P.OMSAdministration.Classes.OMSManagementPackBundle'
        Set-SCOMRunAsProfile -Action "Add" -Profile $RAProfile -Account $RAAccount -Class $TargetClass
    }
Catch
    {
        #we Already have this in our profile and there doesn't appear to be a way to detect it
    }
Try 
    {
        $TargetClass = Get-SCOMClass -Name 'P2P.OMSAdministration.Classes.OMSSolution'
        Set-SCOMRunAsProfile -Action "Add" -Profile $RAProfile -Account $RAAccount -Class $TargetClass
    }
Catch
    {
        #we Already have this in our profile and there doesn't appear to be a way to detect it
    }
Try 
    {
        $TargetClass = Get-SCOMClass -Name 'P2P.OMSAdministration.Classes.OMSManagementPack'
        Set-SCOMRunAsProfile -Action "Add" -Profile $RAProfile -Account $RAAccount -Class $TargetClass
    }
Catch
    {
        #we Already have this in our profile and there doesn't appear to be a way to detect it
    }
Try 
    {
        $TargetClass = Get-SCOMClass -Name 'Microsoft.SystemCenter.RootManagementServer'
        Set-SCOMRunAsProfile -Action "Add" -Profile $RAProfile -Account $RAAccount -Class $TargetClass
    }
Catch
    {
        #we Already have this in our profile and there doesn't appear to be a way to detect it
    }