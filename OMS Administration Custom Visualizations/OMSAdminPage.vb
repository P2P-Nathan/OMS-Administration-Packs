Imports Microsoft.EnterpriseManagement
Imports Microsoft.EnterpriseManagement.Configuration

Public Class OMSAdminPage
    Private OverridePack As OverrideManagementPackControl
    Private EvtLog As New EventLog("OMS Admin Extensions", "Localhost", "OMSAdminSetup")
    Private Sub LoadOverridePack()
        'Connect locally?
        SetStatus("Connecting to Management Server " + TextBox_ManagementServer.Text)
        Try
            Dim MG As New ManagementGroup(TextBox_ManagementServer.Text)

            '    Dim PackCriteria As New ManagementPackCriteria("Name = 'P2P.OMSAdministration.AutomatedPack.DoNotModify'")
            '    SetStatus("Searching for Pack")
            '    Dim PackResults As System.Collections.ObjectModel.ReadOnlyCollection(Of Microsoft.EnterpriseManagement.Configuration.ManagementPack)
            '    PackResults = MG.ManagementPacks.GetManagementPacks(PackCriteria)
            '    If PackResults.Count = 1 Then
            '        'Good news...
            '        SetStatus("Found One Pack - Good")
            OverridePack = New OverrideManagementPackControl(MG)
            '    Else
            '        ReportError("Found too many packs, things won't work")
            '    End If
        Catch ex As Exception
            '    SetStatus("Failed to Connect to the Management Server")
            '    SetStatus(ex.Message)
        End Try

    End Sub

    Private Sub SetStatus(StatusTxt As String)
        Try
            '' add this line at the top of the log
            'ListBox_Status.Items.Insert(0, StatusTxt)

            '' keep only a few lines in the log
            'While ListBox_Status.Items.Count > 100
            '    ListBox_Status.Items.RemoveAt(ListBox_Status.Items.Count - 1)
            'End While

            EvtLog.WriteEntry(StatusTxt, EventLogEntryType.Information, 100)
        Catch ex As Exception
            MsgBox("Logging threw an Exception, Something is Seriously Wrong :-(")
        End Try
    End Sub
    Private Sub SetStatusMilestone(ByRef StatusMsg As String)
        '        SetStatusNoWait("' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ")
        SetStatus(StatusMsg)
        '       SetStatusNoWait("'''''''''''''''''''''''''")
    End Sub
    Private Sub ReportError(ByRef ErrorText As String, Optional ByRef ErrorID As Integer = 200)
        EvtLog.WriteEntry(ErrorText, EventLogEntryType.Error, ErrorID)
    End Sub

    Private Sub Button_Connect_Click(sender As Object, e As EventArgs) Handles Button_Connect.Click
        SetStatusMilestone("Connection Complete")
        TextBox_ManagementServer.Enabled = False
        Button_Connect.Enabled = False
        CheckForInstalledPacks()
    End Sub

    Private Sub RadioButton_Standards_CheckedChanged(sender As Object, e As EventArgs) Handles RadioButton_NoChange.CheckedChanged, RadioButton_ClassOverride.CheckedChanged
        SetStatus("Updating UI to Support Standard Deployment")
        CheckBox_AlertOnChangeOnly.Enabled = True
        CheckBox_DeletionAlerts.Checked = False
        CheckBox_DeletionAlerts.Enabled = False
        CheckBox_NewMPAlert.Checked = False
        CheckBox_NewMPAlert.Enabled = False
        CheckBox_VersionAlert.Checked = False
        CheckBox_VersionAlert.Enabled = False
    End Sub


    Private Sub RadioButton_ManualDeploy_CheckedChanged(sender As Object, e As EventArgs) Handles RadioButton_ManualDeploy.CheckedChanged
        SetStatus("Updating UI to Support Manual Deployment")
        CheckBox_AlertOnChangeOnly.Checked = False
        CheckBox_AlertOnChangeOnly.Enabled = False
        CheckBox_DeletionAlerts.Checked = True
        CheckBox_DeletionAlerts.Enabled = True
        CheckBox_NewMPAlert.Checked = True
        CheckBox_NewMPAlert.Enabled = True
        CheckBox_VersionAlert.Checked = True
        CheckBox_VersionAlert.Enabled = True
        CheckBox_EnableDisableGroups.Checked = True
        TextBox_SyncTime.Enabled = True
        MsgBox("After Enabling these settings you will need to populate the groups that control the solutions." + vbCrLf + "The easiest way to start would be to add the OMS Managed Computers groups to each Enabled Group." + vbCrLf + "Override Pack update/Refresh time can be set via SyncTime.  It can also be disabled for automatic run, opting to update packs manually via TASK or when installed.", MsgBoxStyle.OkOnly, "OMS Admin Message")
    End Sub

    Private Sub Button_ApplyChangeControl_Click(sender As Object, e As EventArgs) Handles Button_ApplyChangeControl.Click
        SetStatus("Updating Change Control Settings")
        OverridePack.ModifyChangeControl(CheckBox_AlertOnChangeOnly.Checked,
                                         CheckBox_DeletionAlerts.Checked,
                                         CheckBox_NewMPAlert.Checked,
                                         CheckBox_VersionAlert.Checked,
                                         CheckBox_EnableDisableGroups.Checked,
                                         RadioButton_NoChange.Checked,
                                         RadioButton_ClassOverride.Checked,
                                         RadioButton_ManualDeploy.Checked,
                                         TextBox_SyncTime.Text)
        SetStatusMilestone("Change Control Updated")
    End Sub



    Private Sub OMSAdminPage_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim SDKMachine As Object
        SDKMachine = My.Computer.Registry.GetValue("HKEY_CURRENT_USER\Software\Microsoft\Microsoft Operations Manager\3.0\User Settings", "SDKServiceMachine", Nothing)
        If SDKMachine IsNot Nothing Then
            Dim ConnectTo As String = SDKMachine.ToString()
            TextBox_ManagementServer.Text = ConnectTo
        Else
            TextBox_ManagementServer.Text = "LocalHost"
        End If

    End Sub

    Private Sub CheckForInstalledPacks()
        OverridePack = Nothing
        LoadOverridePack()
        If OverridePack Is Nothing Then
            MsgBox("Failed to Load Override Pack, Sorry were done here.  Make sure you have the override pack installed")
            TextBox_ManagementServer.Enabled = True
            Button_Connect.Enabled = True
            Exit Sub
        End If
        CheckBox_AlertOnChangeOnly.Checked = OverridePack.CheckMP_AlertOnChange
        CheckBox_DeletionAlerts.Checked = OverridePack.CheckMP_DeletionAlerts
        CheckBox_NewMPAlert.Checked = OverridePack.CheckMP_NewMPAlert
        CheckBox_VersionAlert.Checked = OverridePack.CheckMP_VersionAlert
        RadioButton_NoChange.Checked = OverridePack.CheckMP_NoChangeMode
        RadioButton_ClassOverride.Checked = OverridePack.CheckMP_ClassOverrideMode
        RadioButton_ManualDeploy.Checked = OverridePack.CheckMP_ManualDeploy
        CheckBox_EnableDisableGroups.Checked = OverridePack.CheckMP_GroupCreation


    End Sub


End Class
