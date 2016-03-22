#Create the Event Log we will use
function SetupOMSAdminLog()
    {
        New-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript
        New-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup
        New-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminConsole
        Limit-EventLog -OverflowAction OverWriteAsNeeded -MaximumSize 4096KB -LogName 'OMS Admin Extensions'
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -EntryType Information -EventId 1002 -Message "OMS Admin EventLog, Source OMSAdminScript has been configured!" -Category 100
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 1003 -Message "OMS Admin EventLog, Source OMSAdminSetup has been configured!" -Category 100
        Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminConsole -EntryType Information -EventId 1004 -Message "OMS Admin EventLog, Source OMSAdminConsole has been configured!" -Category 100
    }

Try
    {
        $OMSLog = Get-EventLog -LogName 'OMS Admin Extensions' -Newest 1 -ErrorAction SilentlyContinue
    }
Catch
    {
        SetupOMSAdminLog
    }

If ($OMSLog -eq $null)
    {
        Try
            {
                SetupOMSAdminLog
            }
        Catch
            {
                #If we get here we've got issues, not sure which ones though.
            }
    }