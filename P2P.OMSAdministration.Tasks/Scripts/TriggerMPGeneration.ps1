Param([String]$SolutionName)
$EVTMessage = "Generate Admin Pack For $SolutionName"
Write-EventLog -LogName 'OMS Admin Extensions' -Source OMSAdminSetup -EntryType Information -EventId 5105 -Message $EVTMessage
Write-Host "Request has been queued to Generate a Admin Pack for $SolutionName"
