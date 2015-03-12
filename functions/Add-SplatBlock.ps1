function Add-SplatBlock
{ 
Param(
    $Sender
)
""
$SplatBlock =  @' 
$SplatObject = @{ 
    Key = "Value"
    newkey = "Value"
}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($sender.CaretLineText -like "*``[splat``]")
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 6) 
        $psise.CurrentFile.Editor.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($SplatBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($SplatBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfDollar = $psise.CurrentFile.Editor.CaretLineText.IndexOf("$")
        [Int]$IndexOfequal = $psise.CurrentFile.Editor.CaretLineText.IndexOf("=")
        Select-CaretLines -StartLine $currentLine -StartCol ($IndexOfDollar + 2) -EndLine $currentLine -EndCol $IndexOfequal
    }
    
}