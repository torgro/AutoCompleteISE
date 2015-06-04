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
    
    if($sender.CaretLineText.TrimStart(" ") -like "``[splat``]")
    { 
        [Int]$ColumnIndex = $Sender.CaretColumn
        [int]$currentLine = $Sender.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 6) 
        $Sender.SelectCaretLine()

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
            [void]$Sender.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$Sender.InsertText($SplatBlock)
        }
        
        Set-CaretPosition -sender $Sender -Line $currentLine -Column 1
        [Int]$IndexOfDollar = $Sender.CaretLineText.IndexOf("$")
        [Int]$IndexOfequal = $Sender.CaretLineText.IndexOf("=")
        Select-CaretLines -sender $Sender -StartLine $currentLine -StartCol ($IndexOfDollar + 2) -EndLine $currentLine -EndCol $IndexOfequal
    }    
}