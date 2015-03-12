function Select-CaretLines
{ 
[cmdletbinding()]
Param(
    [int]$StartLine
    ,
    [Int]$StartCol
    ,
    [Int]$EndLine
    ,
    [Int]$EndCol
)
    [Int]$StartLineLength = $psISE.CurrentFile.Editor.GetLineLength($StartLine) + 1
    [Int]$EndLineLength = $psISE.CurrentFile.Editor.GetLineLength($EndLine) + 1
    [bool]$Return = $false

    if(-not $EndCol)
    {
        $EndCol = $EndLineLength
    }

    if($StartLineLength -ge $StartCol -and $EndLineLength -ge $EndCol)
    { 
        Write-Verbose -Message "Setting selection startline=$StartLine, startcol=$StartCol, endline=$EndLine, EndCol=$EndCol"
        $psISE.CurrentFile.Editor.Select($StartLine,$StartCol,$EndLine,$EndCol)
        $Return = $true
    }
    else
    { 
        Write-Warning "Unable to set selection, startline=$StartLine, startcol=$StartCol, endline=$EndLine, EndCol=$EndCol"
    }

    return $Return
}