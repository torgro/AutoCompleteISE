Function Add-TryBlock
{ 
[CmdletBinding()]
[OutputType([String])]
Param(
    $Sender
)
$tryblock = @"
Try 
{ 
    
}
Catch
{ 
    
}
Finally
{ 
    
}
"@

    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count

    if($Sender.CaretLineText.TrimStart(" ") -eq 'try' -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $Sender.CaretColumn
        [int]$currentLine = $Sender.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $Sender.SelectCaretLine()
        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($tryblock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$Sender.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$Sender.InsertText($tryblock)
        }        
        
        Set-CaretPosition -sender $Sender -Line ($currentLine + 2)        
    }
}