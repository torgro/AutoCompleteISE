function Add-PesterItBlock
{ 
Param(
    $Sender
)

$PesterItBlock = @' 
It "something" { 

}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($sender.CaretLineText.TrimStart(" ") -like "it " -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $psise.CurrentFile.Editor.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($PesterItBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($PesterItBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfRight = $psise.CurrentFile.Editor.CaretLineText.IndexOf('"')
        [Int]$IndexOfLeft = $psise.CurrentFile.Editor.CaretLineText.LastIndexOf('"')
        Select-CaretLines -StartLine $currentLine -StartCol ($IndexOfRight + 2) -EndLine $currentLine -EndCol ($IndexOfLeft + 1)
    }
}