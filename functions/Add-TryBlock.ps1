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

    if($Sender.CaretLineText -eq 'try' -or $sender.CaretLineText -like "*try" -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $psise.CurrentFile.Editor.SelectCaretLine()
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
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($tryblock)
        }        
        
        Set-CaretPosition -Line ($currentLine + 2)        
    }
}