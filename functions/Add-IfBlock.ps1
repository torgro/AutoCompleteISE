function Add-IfBlock
{ 
Param(
    $Sender
)

$IfBlock = @' 
if (something)
{ 
    
}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($Sender.CaretLineText.TrimStart(" ") -eq 'if ' -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $Sender.CaretColumn
        [int]$currentLine = $Sender.CaretLine 
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $Sender.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($IfBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                             
            $Sender.InsertText($sb.ToString().TrimEnd([environment]::NewLine))        
        }
        else
        {             
            $Sender.InsertText($IfBlock)
        }
        
        Set-CaretPosition -sender $Sender -Line $currentLine -Column 1        
        [Int]$IndexOfRight = $Sender.CaretLineText.IndexOf("(")
        [Int]$IndexOfLeft = $Sender.CaretLineText.IndexOf(")")
        Select-CaretLines -Sender $Sender -StartLine $currentLine -StartCol ($IndexOfRight + 2) -EndLine $currentLine -EndCol ($IndexOfLeft + 1)
    }    
}