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
            $Sender.InsertText(' }')
            [int]$col = $Sender.CaretColumn
            [int]$line = $Sender.CaretLine
            if($NoNewLine)
            {                
                Select-CaretLines -StartLine $line -StartCol ($col - 4) -EndLine $line
                $Sender.InsertText('{  }')
                Set-CaretPosition -Sender $Sender -Line $line -Column ($col - 2)
                return $null
            }
            Set-CaretPosition -Sender $Sender -Line $line -Column ($col -1)

            $Sender.InsertText([environment]::NewLine)
            $Sender.InsertText([environment]::NewLine)

            $IndentCount = $Script:tabs.$col
            
            if($IndentCount -gt 0)
            { 
                $indent = $Script:tab * $IndentCount
                $Sender.InsertText($indent)
            }
            $Sender.SelectCaretLine()
            $line = $Sender.CaretLine
            
            Set-CaretPosition -Sender $Sender -Line ($line - 1) -Column 1
            
            $indent = $Script:tab * ($IndentCount + 1)
            $Sender.InsertText($indent)
        }
    }
}