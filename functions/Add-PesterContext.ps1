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
    
    if($Sender.CaretLineText -eq "Context " -or $sender.CaretLineText -like "*Context " -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 8)            
        $psise.CurrentFile.Editor.SelectCaretLine()

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
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($PesterContextBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfRight = $psise.CurrentFile.Editor.CaretLineText.IndexOf('"')
        [Int]$IndexOfLeft = $psise.CurrentFile.Editor.CaretLineText.LastIndexOf('"')
        Select-CaretLines -StartLine $currentLine -StartCol ($IndexOfRight + 2) -EndLine $currentLine -EndCol ($IndexOfLeft + 1)
    }
    
}