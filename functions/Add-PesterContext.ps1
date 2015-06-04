function Add-PesterContext
{ 
Param(
    $Sender
)

$PesterContextBlock = @' 
Context "something" { 

}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($Sender.CaretLineText.TrimStart(" ") -eq "Context " -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $Sender.CaretColumn
        [int]$currentLine = $Sender.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 8)            
        $Sender.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($PesterContextBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$Sender.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$Sender.InsertText($PesterContextBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfRight = $Sender.CaretLineText.IndexOf('"')
        [Int]$IndexOfLeft = $Sender.CaretLineText.LastIndexOf('"')
        Select-CaretLines -sender $Sender -StartLine $currentLine -StartCol ($IndexOfRight + 2) -EndLine $currentLine -EndCol ($IndexOfLeft + 1)
    }
    
}