Function Clear-ISEmenu
{ 
[CmdletBinding()]
[OutputType([String])]
Param(   
    $CurrentEvents
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    Foreach ($key in $CurrentEvents)
    { 
        if($CurrentEvents.$key)
        {
            Write-Verbose -Message "$f -  Removing event with id $($CurrentEvents.$key)"
            Unregister-Event -SubscriptionId $CurrentEvents.$key -Verbose:$false -ErrorAction SilentlyContinue
        }
    }

    Write-Verbose -Message "$f -  Removing menu items"

    if($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Enable AutoCompleteEvents")
    { 
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove(($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Enable AutoCompleteEvents"))
    }

    if($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Autocomplete")
    { 
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove(($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Autocomplete"))
    }

    if($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Toggle comment")
    { 
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove(($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Toggle comment"))
    }
    
    Write-Verbose -Message "$f - END"
}