function Set-CaretPosition
{ 
[cmdletbinding()]
Param(
    [int]$Line
    ,
    [Int]$Column
)
    [String]$f = $MyInvocation.InvocationName
    [int]$Length = $psISE.CurrentFile.Editor.GetLineLength($line) + 1
    [bool]$Return = $false

    if(-not $Column)
    {
        $Column = $Length
    }

    if($Length -ge $Column)
    { 
        Write-Verbose "$f - Setting position for line $Line, wanted column was $Column, length is $Length for line $Line"
        $psise.CurrentFile.Editor.SetCaretPosition($Line,$Column)
        $Return = $true
    }
    else
    { 
        Write-Warning "$f - Unable to set pos, wanted column was $Column, length was $Length for line $Line"
    }

    return $Return
}