function Remove-AutoCompeteEvent
{ 
    [string]$BaseName = ($psISE.CurrentFile.DisplayName.Split("."))[0]
    $id = $script:EventsEnabled.$BaseName
    if($id)
    { 
        Write-Verbose "unregister id $id" -Verbose
        Unregister-Event -SubscriptionId $id
        [void]$script:EventsEnabled.Remove($BaseName)
    }
    else
    { 
        Write-Verbose "ID $ID was not found"
    }
}