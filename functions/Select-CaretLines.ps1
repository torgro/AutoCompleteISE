function Select-CaretLines
{ 
[cmdletbinding()]
Param(
    $sender
    ,
    [int]$StartLine
    ,
    [Int]$StartCol
    ,
    [Int]$EndLine
    ,
    [Int]$EndCol
)
    if (-not $sender)
    { 
        Write-Verbose -Message "$f -  Sender is NULL" -Verbose
        throw "error in $f - Sender is null"
    }
    [Int]$StartLineLength = $sender.GetLineLength($StartLine) + 1
    [Int]$EndLineLength = $sender.GetLineLength($EndLine) + 1
    [bool]$Return = $false

    if(-not $EndCol)
    {
        $EndCol = $EndLineLength
    }

    if($StartLineLength -ge $StartCol -and $EndLineLength -ge $EndCol)
    { 
        Write-Verbose -Message "Setting selection startline=$StartLine, startcol=$StartCol, endline=$EndLine, EndCol=$EndCol"
        $sender.Select($StartLine,$StartCol,$EndLine,$EndCol)
        $Return = $true
    }
    else
    { 
        Write-Warning "Unable to set selection, startline=$StartLine, startcol=$StartCol, endline=$EndLine, EndCol=$EndCol"
    }

    return $Return
}