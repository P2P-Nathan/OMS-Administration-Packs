param([DateTime]$InstallDate,[String]$MPName)

[datetime]$run  = [system.Datetime]::Parse($InstallDate)
$expire = $run.AddSeconds(1).ToString('s')
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -command "& {Write-EventLog -LogName ''OMS Admin Extensions'' -Source OMSAdminSetup -EntryType Information -EventId 7102 -Message "Install AntiMalware" -Category 60}"'
$trigger = New-ScheduledTaskTrigger -At $run -Once
$settings = New-ScheduledTaskSettingsSet
$settings.DeleteExpiredTaskAfter = "PT0S"
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Description "This task will install the $MPName at the scheduled time"
$task.Triggers[0].EndBoundary = $expire
Register-ScheduledTask -TaskName "Install $MPName on Schedule" -TaskPath "\" -InputObject $task