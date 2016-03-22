param([String]$WhatAction,[String]$PackName)
#Create the Event Log we will use
function SetupOMSAdminLog()
    {
        New-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminScript -ErrorAction SilentlyContinue
        New-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -ErrorAction SilentlyContinue
        New-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminConsole -ErrorAction SilentlyContinue
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

If ($WhatAction -eq 'Install')
	{
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 7102 -Message "Install $PackName" -Category 60	
		Write-Host "Install Request Queued"
	}
ElseIf ($WhatAction -eq 'Download')
	{
		Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 7103 -Message "Download $PackName" -Category 60	
		Write-Host "Download Request Queued"
		$TempPath =  [System.IO.Path]::GetTempPath() #Its a Surprise!
		[String]$MPLocation = $TempPath + $MPBName
		Write-Host "Your file should be at $MPLocation, on the Management Server hosting this DA Soon."
		#this needs some love
	}