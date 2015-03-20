
function Set-AutoCompleteSettings
{
[cmdletbinding()]
Param(
    [bool]$BracketOnNewLine
    ,
    [bool]$AutoIndent
)
    $f = $Mycommand.InvokationName
    Write-Verbose -Message “$f - START”
    
    $script:settings.BracketOnNewLine = $BracketOnNewLine
    $script:settings.AutoIndent = $AutoIndent

    Write-Verbose -Message “$f - END”
}