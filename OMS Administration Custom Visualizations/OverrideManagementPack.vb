Imports Microsoft.EnterpriseManagement
Imports Microsoft.EnterpriseManagement.Configuration

Public Class OverrideManagementPackControl
    Public OverrideMP As ManagementPack
    Private EvtLog As New EventLog("OMS Admin Extensions", "Localhost", "OMSAdminSetup")

    Sub New(MG As ManagementGroup)
        SetStatus("Initializing Control Class")
        Try

            Dim PackCriteria As New ManagementPackCriteria("Name = 'P2P.OMSAdministration.AutomatedPack.DoNotModify'")
            SetStatus("Searching for Pack")
            Dim PackResults As System.Collections.ObjectModel.ReadOnlyCollection(Of Microsoft.EnterpriseManagement.Configuration.ManagementPack)
            PackResults = MG.ManagementPacks.GetManagementPacks(PackCriteria)
            If PackResults.Count = 1 Then
                'Good news...
                SetStatus("Found One Pack - Good")
                OverrideMP = PackResults(0)

            Else
                ReportError("Found too many packs, things won't work")
            End If
        Catch ex As Exception
            SetStatus("Failed to Connect to the Management Server")
            SetStatus(ex.Message)
        End Try
    End Sub

    Private Sub SetStatus(ByRef StatusTxt As String)
        ' '' Added pause for fun and dramatic logging in the UI
        'Threading.Thread.Sleep(200)
        'Try
        '    ' add this line at the top of the log
        '    StatusBox.Items.Insert(0, StatusTxt)

        '    ' keep only a few lines in the log
        '    While StatusBox.Items.Count > 100
        '        StatusBox.Items.RemoveAt(StatusBox.Items.Count - 1)
        '    End While
        Try
            EvtLog.WriteEntry(StatusTxt, EventLogEntryType.Information, 100)
        Catch ex As Exception
            MsgBox("Logging Failed in the Override Class")
        End Try

    End Sub
    Private Sub ReportError(ByRef ErrorText As String, Optional ByRef ErrorID As Integer = 200)
        EvtLog.WriteEntry(ErrorText, EventLogEntryType.Error, ErrorID)
    End Sub

    Sub ModifyChangeControl(AlertOnChangeOnly As Boolean, DeletionAlerts As Boolean, NewMPAlerts As Boolean, VersionAlerts As Boolean, EnableDisableGroup As Boolean, NoChangeMode As Boolean, ClassOverrideMode As Boolean, ManualDeployMode As Boolean, SyncTime As String)
        OverrideMP.RejectChanges()
        If NoChangeMode Then
            'Standard Operations
            EnableNoChangeMode(AlertOnChangeOnly)
        ElseIf ClassOverrideMode Then
            'EnableClassOverrides
            EnableClassOverrideMode(AlertOnChangeOnly)
        ElseIf ManualDeployMode Then
            'Lets Go Manual!
            EnableManualDeploy(DeletionAlerts, NewMPAlerts, VersionAlerts)
            UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.SyncTime", SyncTime)
        Else
            'this isn't good
            SetStatus("We Failed to Determine What Mode to use")
        End If
        If EnableDisableGroup Then
            UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.GroupOverride", "true")
            UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.GroupOverride", "true")
        Else
            UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.GroupOverride", "false")
            UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.GroupOverride", "false")
        End If
        SetStatus("Attempting to Verify MP")
        'UpLevelVersion() 'This is bad for some reason....
        OverrideMP.Verify()
        OverrideMP.AcceptChanges()
        MsgBox("MP Changes Accepted")
    End Sub

    Public Sub UpdateOverride(OverrideName As String, NewValue As String)
        Dim OverrideToWorkWith = OverrideMP.GetOverride(OverrideName)
        Dim OverrideType As String = OverrideToWorkWith.GetType().Name
        If OverrideType = "ManagementPackRulePropertyOverride" Then
            Dim RuleOverrideToWorkWith As ManagementPackRulePropertyOverride = OverrideToWorkWith
            Dim RemadeOverride As New Microsoft.EnterpriseManagement.Configuration.ManagementPackRulePropertyOverride(OverrideMP, OverrideName)
            RemadeOverride.Context = RuleOverrideToWorkWith.Context
            'RemadeOverride.ContextInstance = RuleOverrideToWorkWith.ContextInstance
            RemadeOverride.Description = RuleOverrideToWorkWith.Description
            RemadeOverride.DisplayName = RuleOverrideToWorkWith.DisplayName
            RemadeOverride.Rule = RuleOverrideToWorkWith.Rule
            RemadeOverride.Property = RuleOverrideToWorkWith.Property
            RemadeOverride.Value = NewValue
            'OverrideMP.Verify()
            'OverrideMP.AcceptChanges()
        ElseIf OverrideType = "ManagementPackMonitorPropertyOverride" Then
            Dim MonitorOverrideToWorkWith As ManagementPackMonitorPropertyOverride = OverrideToWorkWith
            Dim RemadeOverride As New Microsoft.EnterpriseManagement.Configuration.ManagementPackMonitorPropertyOverride(OverrideMP, OverrideName)
            RemadeOverride.Context = MonitorOverrideToWorkWith.Context
            'RemadeOverride.ContextInstance = MonitorOverrideToWorkWith.ContextInstance
            RemadeOverride.Description = MonitorOverrideToWorkWith.Description
            RemadeOverride.DisplayName = MonitorOverrideToWorkWith.DisplayName
            RemadeOverride.Monitor = MonitorOverrideToWorkWith.Monitor
            RemadeOverride.Property = MonitorOverrideToWorkWith.Property
            RemadeOverride.Value = NewValue
            'OverrideMP.Verify()
            'OverrideMP.AcceptChanges()
        ElseIf OverrideType = "ManagementPackRuleConfigurationOverride" Then
            Dim RuleConfOverrideToWorkWith As ManagementPackRuleConfigurationOverride = OverrideToWorkWith
            Dim RemadeOverride As New Microsoft.EnterpriseManagement.Configuration.ManagementPackRuleConfigurationOverride(OverrideMP, OverrideName)
            RemadeOverride.Rule = RuleConfOverrideToWorkWith.Rule
            RemadeOverride.Context = RuleConfOverrideToWorkWith.Context
            'RemadeOverride.ContextInstance = RuleConfOverrideToWorkWith.ContextInstance
            RemadeOverride.Description = RuleConfOverrideToWorkWith.Description
            RemadeOverride.DisplayName = RuleConfOverrideToWorkWith.DisplayName
            RemadeOverride.Parameter = RuleConfOverrideToWorkWith.Parameter
            RemadeOverride.Module = RuleConfOverrideToWorkWith.Module
            RemadeOverride.Value = NewValue
            'OverrideMP.Verify()
            'OverrideMP.AcceptChanges()
        ElseIf OverrideType = "ManagementPackMonitorConfigurationOverride" Then
            Dim MonitorOverrideToWorkWith As ManagementPackMonitorConfigurationOverride = OverrideToWorkWith
            Dim RemadeOverride As New Microsoft.EnterpriseManagement.Configuration.ManagementPackMonitorConfigurationOverride(OverrideMP, OverrideName)
            RemadeOverride.Context = MonitorOverrideToWorkWith.Context
            'RemadeOverride.ContextInstance = MonitorOverrideToWorkWith.ContextInstance
            RemadeOverride.Description = MonitorOverrideToWorkWith.Description
            RemadeOverride.DisplayName = MonitorOverrideToWorkWith.DisplayName
            RemadeOverride.Monitor = MonitorOverrideToWorkWith.Monitor
            RemadeOverride.Value = NewValue
            RemadeOverride.Parameter = MonitorOverrideToWorkWith.Parameter
            'OverrideMP.Verify()
            'OverrideMP.AcceptChanges()
        End If
    End Sub

    Private Sub EnableNoChangeMode(AlertOnChangeOnly As Boolean)
        SetStatus("Enabling No Change Control Mode")
        UpdateOverride("P2P.OMSAdministration.AutomatedPack.MPUpdateOverride", "true")
        UpdateOverride("P2P.OMSAdministration.AutomatedPack.GetIntelPackOverride", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.Enabled", "false")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.ClassOverride", "false")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.Enabled", "false")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.ClassOverride", "false")
        UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNeedsDeleted.ForTargetClass.GenerateAlert", "false")
        UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNotFound.ForTargetClass.GenerateAlert", "false")
        UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackVersionCheck.ForTargetClass.GenerateAlert", "false")
        If AlertOnChangeOnly Then
            UpdateOverride("P2P.OMS.Administration.Monitoring.RulesAlertOnMeChanging.ForTargetClass.Enabled", "true")
        Else
            UpdateOverride("P2P.OMS.Administration.Monitoring.RulesAlertOnMeChanging.ForTargetClass.Enabled", "false")
        End If
    End Sub

    Private Sub EnableClassOverrideMode(AlertOnChangeOnly As Boolean)
        SetStatus("Enabling Limited Change Control - Class Overrides")
        UpdateOverride("P2P.OMSAdministration.AutomatedPack.MPUpdateOverride", "true")
        UpdateOverride("P2P.OMSAdministration.AutomatedPack.GetIntelPackOverride", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.Enabled", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.ClassOverride", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.Enabled", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.ClassOverride", "true")
        UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNeedsDeleted.ForTargetClass.GenerateAlert", "false")
        UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNotFound.ForTargetClass.GenerateAlert", "false")
        UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackVersionCheck.ForTargetClass.GenerateAlert", "false")
        If AlertOnChangeOnly Then
            UpdateOverride("P2P.OMS.Administration.Monitoring.RulesAlertOnMeChanging.ForTargetClass.Enabled", "true")
        Else
            UpdateOverride("P2P.OMS.Administration.Monitoring.RulesAlertOnMeChanging.ForTargetClass.Enabled", "false")
        End If
    End Sub

    Private Sub EnableManualDeploy(DeletionAlerts As Boolean, NewMPAlerts As Boolean, VersionAlerts As Boolean)
        SetStatus("Enabling Full Change Control")
        UpdateOverride("P2P.OMSAdministration.AutomatedPack.MPUpdateOverride", "false")
        UpdateOverride("P2P.OMSAdministration.AutomatedPack.GetIntelPackOverride", "false")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.Enabled", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.ClassOverride", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.Enabled", "true")
        UpdateOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParametersEventTriggered.ForTargetClass.ClassOverride", "true")
        UpdateOverride("P2P.OMS.Administration.Monitoring.RulesAlertOnMeChanging.ForTargetClass.Enabled", "false")
        If DeletionAlerts Then
            UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNeedsDeleted.ForTargetClass.GenerateAlert", "true")
        Else
            UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNeedsDeleted.ForTargetClass.GenerateAlert", "false")
        End If
        If NewMPAlerts Then
            UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNotFound.ForTargetClass.GenerateAlert", "true")
        Else
            UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackNotFound.ForTargetClass.GenerateAlert", "false")
        End If
        If VersionAlerts Then
            UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackVersionCheck.ForTargetClass.GenerateAlert", "true")
        Else
            UpdateOverride("P2P.OMS.Administration.Monitoring.ManagementPackVersionCheck.ForTargetClass.GenerateAlert", "false")
        End If
    End Sub

    Function CheckMP_AlertOnChange() As Boolean
        Dim ThisOverride As ManagementPackOverride = Nothing
        ThisOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Monitoring.RulesAlertOnMeChanging.ForTargetClass.Enabled")
        Return Boolean.Parse(ThisOverride.Value)
    End Function

    Function CheckMP_DeletionAlerts() As Boolean
        Dim ThisOverride As ManagementPackOverride = Nothing
        ThisOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Monitoring.ManagementPackNeedsDeleted.ForTargetClass.GenerateAlert")
        Return Boolean.Parse(ThisOverride.Value)
    End Function

    Function CheckMP_NewMPAlert() As Boolean
        Dim ThisOverride As ManagementPackOverride = Nothing
        ThisOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Monitoring.ManagementPackNotFound.ForTargetClass.GenerateAlert")
        Return Boolean.Parse(ThisOverride.Value)
    End Function

    Function CheckMP_VersionAlert() As Boolean
        Dim ThisOverride As ManagementPackOverride = Nothing
        ThisOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Monitoring.ManagementPackVersionCheck.ForTargetClass.GenerateAlert")
        Return Boolean.Parse(ThisOverride.Value)
    End Function

    Function CheckMP_NoChangeMode() As Boolean
        Dim MPUpdateOverride, IntelPackOverride, GenerateOverride As ManagementPackOverride
        MPUpdateOverride = OverrideMP.GetOverride("P2P.OMSAdministration.AutomatedPack.MPUpdateOverride")
        IntelPackOverride = OverrideMP.GetOverride("P2P.OMSAdministration.AutomatedPack.GetIntelPackOverride")
        GenerateOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.Enabled")
        Dim IsStandardFlowAllowed, IsNoChangeMode As Boolean
        IsStandardFlowAllowed = Boolean.Parse(MPUpdateOverride.Value) And Boolean.Parse(IntelPackOverride.Value)
        IsNoChangeMode = IsStandardFlowAllowed And Not Boolean.Parse(GenerateOverride.Value)
        Return IsNoChangeMode
    End Function

    Function CheckMP_ClassOverrideMode() As Boolean
        Dim MPUpdateOverride, IntelPackOverride, GenerateOverride As ManagementPackOverride
        MPUpdateOverride = OverrideMP.GetOverride("P2P.OMSAdministration.AutomatedPack.MPUpdateOverride")
        IntelPackOverride = OverrideMP.GetOverride("P2P.OMSAdministration.AutomatedPack.GetIntelPackOverride")
        GenerateOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.Enabled")
        Dim IsStandardFlowAllowed, IsGroupCreateMode As Boolean
        IsStandardFlowAllowed = Boolean.Parse(MPUpdateOverride.Value) And Boolean.Parse(IntelPackOverride.Value)
        IsGroupCreateMode = IsStandardFlowAllowed And Boolean.Parse(GenerateOverride.Value)
        Return IsGroupCreateMode
    End Function

    Function CheckMP_ManualDeploy() As Boolean
        Dim MPUpdateOverride, IntelPackOverride, GenerateOverride As ManagementPackOverride
        MPUpdateOverride = OverrideMP.GetOverride("P2P.OMSAdministration.AutomatedPack.MPUpdateOverride")
        IntelPackOverride = OverrideMP.GetOverride("P2P.OMSAdministration.AutomatedPack.GetIntelPackOverride")
        GenerateOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.Enabled")
        Dim IsStandardFlowAllowed, IsManualMode As Boolean
        IsStandardFlowAllowed = Boolean.Parse(MPUpdateOverride.Value) And Boolean.Parse(IntelPackOverride.Value)
        IsManualMode = Boolean.Parse(GenerateOverride.Value) And Not IsStandardFlowAllowed
        Return IsManualMode
    End Function

    Function CheckMP_GroupCreation() As Boolean
        Dim ThisOverride As ManagementPackOverride = Nothing
        ThisOverride = OverrideMP.GetOverride("P2P.OMS.Administration.Discoveries.GenerateShellMPWithParameters.ForTargetClass.GroupOverride")
        Return Boolean.Parse(ThisOverride.Value)
    End Function

    Private Sub UpLevelVersion()
        Dim CurrVer As System.Version = OverrideMP.Version
        Dim NewVer As System.Version
        NewVer = New System.Version(CurrVer.Major, CurrVer.Major, CurrVer.Build, (CurrVer.Revision + 1))
        OverrideMP.Version = NewVer
    End Sub

End Class
