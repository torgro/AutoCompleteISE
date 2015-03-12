function Add-CurlyBracets
{ 
[cmdletbinding()]
Param(
    $Sender
    ,
    [switch]$NoNewLine
)
    if($Sender.CaretLineText[-1] -eq '{')
    {               
        $matchLeft = $sender.text | Select-String -Pattern "{" -AllMatches
        $matchLeftCount = $matchLeft.matches.count
        $matchRight = $sender.text | Select-String -Pattern "}" -AllMatches
        $matchRightCount = $matchRight.matches.count
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
        
        if($matchLeftCount -gt $matchRightCount -and $selectedTextLineCount -eq 1)
        {        
            $psISE.CurrentFile.Editor.InsertText(' }')
            [int]$col = $psISE.CurrentFile.Editor.CaretColumn
            [int]$line = $psISE.CurrentFile.Editor.CaretLine
            if($NoNewLine)
            {                
                Select-CaretLines -StartLine $line -StartCol ($col - 4) -EndLine $line
                $psISE.CurrentFile.Editor.InsertText('{  }')
                Set-CaretPosition -Line $line -Column ($col - 2)
                return $null
            }
            Set-CaretPosition -Line $line -Column ($col -1)

            $psise.CurrentFile.Editor.InsertText([environment]::NewLine)
            $psise.CurrentFile.Editor.InsertText([environment]::NewLine)

            $IndentCount = $Script:tabs.$col
            
            if($IndentCount -gt 0)
            { 
                $indent = $Script:tab * $IndentCount
                $psise.CurrentFile.Editor.InsertText($indent)
            }
            $psISE.CurrentFile.Editor.SelectCaretLine()
            $line = $psISE.CurrentFile.Editor.CaretLine
            
            Set-CaretPosition -Line ($line - 1) -Column 1
            
            $indent = $Script:tab * ($IndentCount + 1)
            $psise.CurrentFile.Editor.InsertText($indent)
        }
    }
}