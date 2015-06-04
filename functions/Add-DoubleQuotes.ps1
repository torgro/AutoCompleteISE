﻿Function Add-DoubleQuotes
{
[cmdletbinding()]
Param(
    $Sender
)
    if($Sender.CaretLineText[-1] -eq '"')
    { 
        $matchDoubleQuote = $Sender.CaretLineText | Select-String -Pattern '"' -AllMatches
        # Finding odd or even number (even
        $Mod = $matchDoubleQuote.Matches.Count % 2
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count

        if($mod -eq 1 -and $selectedTextLineCount -eq 1)
        { 
            $Sender.InsertText('"')
            [int]$col = $Sender.CaretColumn
            [int]$line = $Sender.CaretLine
            Select-CaretLines -sender $Sender -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }
    }
}