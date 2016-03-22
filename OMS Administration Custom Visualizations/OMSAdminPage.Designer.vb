<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OMSAdminPage
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.TextBox_ManagementServer = New System.Windows.Forms.TextBox()
        Me.Label_ManagementServer = New System.Windows.Forms.Label()
        Me.Button_Connect = New System.Windows.Forms.Button()
        Me.GroupBox_ChangeControl = New System.Windows.Forms.GroupBox()
        Me.CheckBox_AlertOnChangeOnly = New System.Windows.Forms.CheckBox()
        Me.CheckBox_DeletionAlerts = New System.Windows.Forms.CheckBox()
        Me.CheckBox_NewMPAlert = New System.Windows.Forms.CheckBox()
        Me.CheckBox_VersionAlert = New System.Windows.Forms.CheckBox()
        Me.RadioButton_ManualDeploy = New System.Windows.Forms.RadioButton()
        Me.RadioButton_ClassOverride = New System.Windows.Forms.RadioButton()
        Me.RadioButton_NoChange = New System.Windows.Forms.RadioButton()
        Me.Button_ApplyChangeControl = New System.Windows.Forms.Button()
        Me.GroupBox_Groups = New System.Windows.Forms.GroupBox()
        Me.CheckBox_EnableLinuxGroupMgmt = New System.Windows.Forms.CheckBox()
        Me.CheckBox_EnableDisableGroups = New System.Windows.Forms.CheckBox()
        Me.TextBox_SyncTime = New System.Windows.Forms.TextBox()
        Me.LabelOverrideSyncTime = New System.Windows.Forms.Label()
        Me.GroupBox_ChangeControl.SuspendLayout()
        Me.GroupBox_Groups.SuspendLayout()
        Me.SuspendLayout()
        '
        'TextBox_ManagementServer
        '
        Me.TextBox_ManagementServer.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TextBox_ManagementServer.Location = New System.Drawing.Point(19, 29)
        Me.TextBox_ManagementServer.Name = "TextBox_ManagementServer"
        Me.TextBox_ManagementServer.Size = New System.Drawing.Size(163, 22)
        Me.TextBox_ManagementServer.TabIndex = 1
        Me.TextBox_ManagementServer.Text = "localhost"
        '
        'Label_ManagementServer
        '
        Me.Label_ManagementServer.AutoSize = True
        Me.Label_ManagementServer.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label_ManagementServer.Location = New System.Drawing.Point(16, 10)
        Me.Label_ManagementServer.Name = "Label_ManagementServer"
        Me.Label_ManagementServer.Size = New System.Drawing.Size(127, 16)
        Me.Label_ManagementServer.TabIndex = 2
        Me.Label_ManagementServer.Text = "ManagementServer"
        '
        'Button_Connect
        '
        Me.Button_Connect.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Button_Connect.Location = New System.Drawing.Point(19, 57)
        Me.Button_Connect.Name = "Button_Connect"
        Me.Button_Connect.Size = New System.Drawing.Size(124, 34)
        Me.Button_Connect.TabIndex = 5
        Me.Button_Connect.Text = "Connect"
        Me.Button_Connect.UseVisualStyleBackColor = True
        '
        'GroupBox_ChangeControl
        '
        Me.GroupBox_ChangeControl.Controls.Add(Me.LabelOverrideSyncTime)
        Me.GroupBox_ChangeControl.Controls.Add(Me.TextBox_SyncTime)
        Me.GroupBox_ChangeControl.Controls.Add(Me.CheckBox_AlertOnChangeOnly)
        Me.GroupBox_ChangeControl.Controls.Add(Me.CheckBox_DeletionAlerts)
        Me.GroupBox_ChangeControl.Controls.Add(Me.CheckBox_NewMPAlert)
        Me.GroupBox_ChangeControl.Controls.Add(Me.CheckBox_VersionAlert)
        Me.GroupBox_ChangeControl.Controls.Add(Me.RadioButton_ManualDeploy)
        Me.GroupBox_ChangeControl.Controls.Add(Me.RadioButton_ClassOverride)
        Me.GroupBox_ChangeControl.Controls.Add(Me.RadioButton_NoChange)
        Me.GroupBox_ChangeControl.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox_ChangeControl.Location = New System.Drawing.Point(19, 97)
        Me.GroupBox_ChangeControl.Name = "GroupBox_ChangeControl"
        Me.GroupBox_ChangeControl.Size = New System.Drawing.Size(388, 242)
        Me.GroupBox_ChangeControl.TabIndex = 6
        Me.GroupBox_ChangeControl.TabStop = False
        Me.GroupBox_ChangeControl.Text = "Change Control"
        '
        'CheckBox_AlertOnChangeOnly
        '
        Me.CheckBox_AlertOnChangeOnly.AutoSize = True
        Me.CheckBox_AlertOnChangeOnly.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CheckBox_AlertOnChangeOnly.Location = New System.Drawing.Point(6, 219)
        Me.CheckBox_AlertOnChangeOnly.Name = "CheckBox_AlertOnChangeOnly"
        Me.CheckBox_AlertOnChangeOnly.Size = New System.Drawing.Size(182, 20)
        Me.CheckBox_AlertOnChangeOnly.TabIndex = 6
        Me.CheckBox_AlertOnChangeOnly.Text = "Alert on MP Changes Only"
        Me.CheckBox_AlertOnChangeOnly.UseVisualStyleBackColor = True
        '
        'CheckBox_DeletionAlerts
        '
        Me.CheckBox_DeletionAlerts.AutoSize = True
        Me.CheckBox_DeletionAlerts.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CheckBox_DeletionAlerts.Location = New System.Drawing.Point(6, 195)
        Me.CheckBox_DeletionAlerts.Name = "CheckBox_DeletionAlerts"
        Me.CheckBox_DeletionAlerts.Size = New System.Drawing.Size(222, 20)
        Me.CheckBox_DeletionAlerts.TabIndex = 5
        Me.CheckBox_DeletionAlerts.Text = "Alert on MPBs that need Deletion"
        Me.CheckBox_DeletionAlerts.UseVisualStyleBackColor = True
        '
        'CheckBox_NewMPAlert
        '
        Me.CheckBox_NewMPAlert.AutoSize = True
        Me.CheckBox_NewMPAlert.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CheckBox_NewMPAlert.Location = New System.Drawing.Point(6, 171)
        Me.CheckBox_NewMPAlert.Name = "CheckBox_NewMPAlert"
        Me.CheckBox_NewMPAlert.Size = New System.Drawing.Size(219, 20)
        Me.CheckBox_NewMPAlert.TabIndex = 4
        Me.CheckBox_NewMPAlert.Text = "Alert on New MPBs to Download"
        Me.CheckBox_NewMPAlert.UseVisualStyleBackColor = True
        '
        'CheckBox_VersionAlert
        '
        Me.CheckBox_VersionAlert.AutoSize = True
        Me.CheckBox_VersionAlert.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CheckBox_VersionAlert.Location = New System.Drawing.Point(6, 147)
        Me.CheckBox_VersionAlert.Name = "CheckBox_VersionAlert"
        Me.CheckBox_VersionAlert.Size = New System.Drawing.Size(208, 20)
        Me.CheckBox_VersionAlert.TabIndex = 3
        Me.CheckBox_VersionAlert.Text = "Alert on MP Version Mis-Match"
        Me.CheckBox_VersionAlert.UseVisualStyleBackColor = True
        '
        'RadioButton_ManualDeploy
        '
        Me.RadioButton_ManualDeploy.AutoSize = True
        Me.RadioButton_ManualDeploy.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.RadioButton_ManualDeploy.Location = New System.Drawing.Point(10, 66)
        Me.RadioButton_ManualDeploy.Name = "RadioButton_ManualDeploy"
        Me.RadioButton_ManualDeploy.Size = New System.Drawing.Size(252, 20)
        Me.RadioButton_ManualDeploy.TabIndex = 2
        Me.RadioButton_ManualDeploy.TabStop = True
        Me.RadioButton_ManualDeploy.Text = "Manual Deployment - Via SCOM Task"
        Me.RadioButton_ManualDeploy.UseVisualStyleBackColor = True
        '
        'RadioButton_ClassOverride
        '
        Me.RadioButton_ClassOverride.AutoSize = True
        Me.RadioButton_ClassOverride.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.RadioButton_ClassOverride.Location = New System.Drawing.Point(10, 43)
        Me.RadioButton_ClassOverride.Name = "RadioButton_ClassOverride"
        Me.RadioButton_ClassOverride.Size = New System.Drawing.Size(337, 20)
        Me.RadioButton_ClassOverride.TabIndex = 1
        Me.RadioButton_ClassOverride.TabStop = True
        Me.RadioButton_ClassOverride.Text = "Standard Deployment - Apply Class Level Overrides"
        Me.RadioButton_ClassOverride.UseVisualStyleBackColor = True
        '
        'RadioButton_NoChange
        '
        Me.RadioButton_NoChange.AutoSize = True
        Me.RadioButton_NoChange.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.RadioButton_NoChange.Location = New System.Drawing.Point(10, 19)
        Me.RadioButton_NoChange.Name = "RadioButton_NoChange"
        Me.RadioButton_NoChange.Size = New System.Drawing.Size(166, 20)
        Me.RadioButton_NoChange.TabIndex = 0
        Me.RadioButton_NoChange.TabStop = True
        Me.RadioButton_NoChange.Text = "Standard - No Changes"
        Me.RadioButton_NoChange.UseVisualStyleBackColor = True
        '
        'Button_ApplyChangeControl
        '
        Me.Button_ApplyChangeControl.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Button_ApplyChangeControl.Location = New System.Drawing.Point(631, 23)
        Me.Button_ApplyChangeControl.Name = "Button_ApplyChangeControl"
        Me.Button_ApplyChangeControl.Size = New System.Drawing.Size(136, 68)
        Me.Button_ApplyChangeControl.TabIndex = 7
        Me.Button_ApplyChangeControl.Text = "Apply" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "OMS Control" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10) & "Settings"
        Me.Button_ApplyChangeControl.UseVisualStyleBackColor = True
        '
        'GroupBox_Groups
        '
        Me.GroupBox_Groups.Controls.Add(Me.CheckBox_EnableLinuxGroupMgmt)
        Me.GroupBox_Groups.Controls.Add(Me.CheckBox_EnableDisableGroups)
        Me.GroupBox_Groups.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox_Groups.Location = New System.Drawing.Point(433, 97)
        Me.GroupBox_Groups.Name = "GroupBox_Groups"
        Me.GroupBox_Groups.Size = New System.Drawing.Size(334, 206)
        Me.GroupBox_Groups.TabIndex = 7
        Me.GroupBox_Groups.TabStop = False
        Me.GroupBox_Groups.Text = "Group Control"
        '
        'CheckBox_EnableLinuxGroupMgmt
        '
        Me.CheckBox_EnableLinuxGroupMgmt.AutoSize = True
        Me.CheckBox_EnableLinuxGroupMgmt.Enabled = False
        Me.CheckBox_EnableLinuxGroupMgmt.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Strikeout, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CheckBox_EnableLinuxGroupMgmt.Location = New System.Drawing.Point(7, 45)
        Me.CheckBox_EnableLinuxGroupMgmt.Name = "CheckBox_EnableLinuxGroupMgmt"
        Me.CheckBox_EnableLinuxGroupMgmt.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.CheckBox_EnableLinuxGroupMgmt.Size = New System.Drawing.Size(226, 20)
        Me.CheckBox_EnableLinuxGroupMgmt.TabIndex = 1
        Me.CheckBox_EnableLinuxGroupMgmt.Text = "Manage Linux Inclusion via Group"
        Me.CheckBox_EnableLinuxGroupMgmt.UseVisualStyleBackColor = True
        '
        'CheckBox_EnableDisableGroups
        '
        Me.CheckBox_EnableDisableGroups.AutoSize = True
        Me.CheckBox_EnableDisableGroups.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CheckBox_EnableDisableGroups.Location = New System.Drawing.Point(7, 22)
        Me.CheckBox_EnableDisableGroups.Name = "CheckBox_EnableDisableGroups"
        Me.CheckBox_EnableDisableGroups.Size = New System.Drawing.Size(286, 20)
        Me.CheckBox_EnableDisableGroups.TabIndex = 0
        Me.CheckBox_EnableDisableGroups.Text = "Create Enable/Disable Groups Per Solution"
        Me.CheckBox_EnableDisableGroups.UseVisualStyleBackColor = True
        '
        'TextBox_SyncTime
        '
        Me.TextBox_SyncTime.Enabled = False
        Me.TextBox_SyncTime.Location = New System.Drawing.Point(24, 119)
        Me.TextBox_SyncTime.Name = "TextBox_SyncTime"
        Me.TextBox_SyncTime.Size = New System.Drawing.Size(124, 22)
        Me.TextBox_SyncTime.TabIndex = 7
        Me.TextBox_SyncTime.Text = "3:00"
        '
        'LabelOverrideSyncTime
        '
        Me.LabelOverrideSyncTime.AutoSize = True
        Me.LabelOverrideSyncTime.Enabled = False
        Me.LabelOverrideSyncTime.Location = New System.Drawing.Point(24, 93)
        Me.LabelOverrideSyncTime.Name = "LabelOverrideSyncTime"
        Me.LabelOverrideSyncTime.Size = New System.Drawing.Size(277, 16)
        Me.LabelOverrideSyncTime.TabIndex = 8
        Me.LabelOverrideSyncTime.Text = "Override MP Creation and Update Sync Time"
        '
        'OMSAdminPage
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.SystemColors.InactiveBorder
        Me.Controls.Add(Me.Button_ApplyChangeControl)
        Me.Controls.Add(Me.Label_ManagementServer)
        Me.Controls.Add(Me.GroupBox_Groups)
        Me.Controls.Add(Me.GroupBox_ChangeControl)
        Me.Controls.Add(Me.Button_Connect)
        Me.Controls.Add(Me.TextBox_ManagementServer)
        Me.Name = "OMSAdminPage"
        Me.Size = New System.Drawing.Size(898, 442)
        Me.GroupBox_ChangeControl.ResumeLayout(False)
        Me.GroupBox_ChangeControl.PerformLayout()
        Me.GroupBox_Groups.ResumeLayout(False)
        Me.GroupBox_Groups.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TextBox_ManagementServer As System.Windows.Forms.TextBox
    Friend WithEvents Label_ManagementServer As System.Windows.Forms.Label
    Friend WithEvents Button_Connect As System.Windows.Forms.Button
    Friend WithEvents GroupBox_ChangeControl As System.Windows.Forms.GroupBox
    Friend WithEvents CheckBox_AlertOnChangeOnly As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox_DeletionAlerts As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox_NewMPAlert As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox_VersionAlert As System.Windows.Forms.CheckBox
    Friend WithEvents RadioButton_ManualDeploy As System.Windows.Forms.RadioButton
    Friend WithEvents RadioButton_ClassOverride As System.Windows.Forms.RadioButton
    Friend WithEvents RadioButton_NoChange As System.Windows.Forms.RadioButton
    Friend WithEvents Button_ApplyChangeControl As System.Windows.Forms.Button
    Friend WithEvents GroupBox_Groups As System.Windows.Forms.GroupBox
    Friend WithEvents CheckBox_EnableLinuxGroupMgmt As System.Windows.Forms.CheckBox
    Friend WithEvents CheckBox_EnableDisableGroups As System.Windows.Forms.CheckBox
    Friend WithEvents LabelOverrideSyncTime As System.Windows.Forms.Label
    Friend WithEvents TextBox_SyncTime As System.Windows.Forms.TextBox

End Class
