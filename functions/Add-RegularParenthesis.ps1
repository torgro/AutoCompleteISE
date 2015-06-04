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
            $Sender.InsertText(')')
            [int]$col = $Sender.CaretColumn
            [int]$line = $Sender.CaretLine
            Select-CaretLines -sender $Sender -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }                      
    }
}