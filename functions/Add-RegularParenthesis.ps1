function Add-RegularParenthesis
{ 
Param(
    $Sender
)
    if($Sender.CaretLineText[-1] -eq '(')
    { 
        $escaped = [regex]::Escape("(")
        $matchLeft = $sender.text | Select-String -Pattern $escaped -AllMatches
        $matchLeftCount = $matchLeft.matches.count
        $escaped = [regex]::Escape(")")
        $matchRight = $sender.text | Select-String -Pattern $escaped -AllMatches
        $matchRightCount = $matchRight.matches.count
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count

        if($matchLeftCount -gt $matchRightCount -and $selectedTextLineCount -eq 1)
        { 
            $psISE.CurrentFile.Editor.InsertText(')')
            [int]$col = $psISE.CurrentFile.Editor.CaretColumn
            [int]$line = $psISE.CurrentFile.Editor.CaretLine
            Select-CaretLines -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }                      
    }
}