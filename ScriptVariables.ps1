$currentPath = ($psISE.CurrentFile.FullPath | Split-Path -ErrorAction SilentlyContinue)

if(-not $currentPath)
{ 
    $currentPath = "C:\Users\Tore\Dropbox\SourceTreeRepros\"
    cd $currentPath -ErrorAction SilentlyContinue
}

[int]$PrevCaretLine = 1
[int]$PrevLineLength = 1
[bool]$BackSpaceMode = $false

$EventsEnabled = @{}

$tab = @"
    
"@

$tabs = @{ 
    1 = 0
    2 = 0
    3 = 0
    4 = 0
    5 = 1
    6 = 1
    7 = 1
    8 = 1
    9 = 2
    10 = 2
    11 = 2
    12 = 2
    13 = 3
    14 = 3
    15 = 3
    16 = 3
    17 = 4
    18 = 4
    19 = 4
    20 = 4
    21 = 5
    22 = 5
    23 = 5
    24 = 5
    25 = 6
    26 = 6
    27 = 6
    28 = 6
    29 = 7
}

$Splat = @'
$SplatObject = @{ 
    Key = "Value"
    Key = "Value"
}
'@
                            
$if = @"
if(aaaaaa)
{ 
    
}
else
{ 
    
}
"@

$foreach = @'
foreach($a in $collection)
{ 
    
}
'@

$func = @'
Function NameMe
{ 
[CmdletBinding()]
[OutputType([String])]
Param(
    [Parameter( Mandatory=$true, 
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true, 
                ValueFromRemainingArguments=$false, 
                Position=0,
                ParameterSetName='Parameter Set 1')]
   [string]$Dummy
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"



    Write-Verbose -Message "$f - END"
}
'@

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { 
    Clear-ISEmenu -CurrentEvents $Script:EventsEnabled -Verbose
 }

$AutoCompleteAction = { 
    Get-AutoComplete -keyWord $psise.CurrentFile.Editor.CaretLineText -columnIndex $psise.CurrentFile.Editor.CaretColumn
}

$AutoCompleteKey =  new-object System.Windows.Input.KeyGesture([windows.input.key]::d1,[windows.input.modifierkeys]::Alt)
$ToggleCommentKey =  new-object System.Windows.Input.KeyGesture([windows.input.key]::d3,[windows.input.modifierkeys]::Alt)

$commentAction = { 
    Switch-Comment
}

if(-not ($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Enable AutoCompleteEvents"))
{ 
    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Enable AutoCompleteEvents", { Enable-AutoCompleteEvent },"F2")
}

#if(-not ($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Autocomplete"))
#{ 
#    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Autocomplete", $AutoCompleteAction, $AutoCompleteKey)
#}

if(-not ($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Toggle comment"))
{ 
    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Toggle comment", $commentAction, $ToggleCommentKey)
}


