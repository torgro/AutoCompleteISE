function Add-RegularParenthesis
{ 
Param(
    $Sender
)
    $f = $MyInvocation.InvocationName
    #Write-Verbose -Message "$f - START"
    [Int]$LastTypedPosition = $sender.CaretColumn - 2
 
    if ($LastTypedPosition -lt 0)
    {    
        break
    }

    if($Sender.CaretLineText[$LastTypedPosition] -eq '(')
    { 
        $escaped = [regex]::Escape("(")
        $matchLeft = $sender.CaretLineText | Select-String -Pattern $escaped -AllMatches
        $matchLeftCount = $matchLeft.matches.count

        $matchLeftAllText = $Sender.Text | Select-String -Pattern $escaped -AllMatches
        $matchLeftAllTextCount = $matchLeftAllText.Matches.Count

        $escaped = [regex]::Escape(")")
        $matchRight = $sender.CaretLineText | Select-String -Pattern $escaped -AllMatches
        $matchRightCount = $matchRight.matches.count

        $matchRightAllText = $Sender.Text | Select-String -Pattern $escaped -AllMatches
        $matchRightAllTextCount = $matchRightAllText.Matches.Count

        $AllTextMatchDiff = $matchLeftAllTextCount - $matchRightAllTextCount

        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
        
        if($matchLeftCount -gt $matchRightCount -and $selectedTextLineCount -eq 1 -and $AllTextMatchDiff -ne 0)
        {             
            $Sender.InsertText(')')
            [int]$col = $Sender.CaretColumn
            [int]$line = $Sender.CaretLine
            Select-CaretLines -sender $Sender -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }             
    }
}