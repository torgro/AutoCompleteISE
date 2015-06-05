function Add-RegularParenthesis
{ 
Param(
    $Sender
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"
    [Int]$LastTypedPosition = $sender.CaretColumn - 2
    if($Sender.CaretLineText[$LastTypedPosition] -eq '(')
    { 
        $escaped = [regex]::Escape("(")
        $matchLeft = $sender.CaretLineText | Select-String -Pattern $escaped -AllMatches
        $matchLeftCount = $matchLeft.matches.count
        $escaped = [regex]::Escape(")")
        $matchRight = $sender.CaretLineText | Select-String -Pattern $escaped -AllMatches
        $matchRightCount = $matchRight.matches.count
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
        Write-Verbose -Message "$f - matchright=$matchRightCount" #-Verbose
        Write-Verbose -Message "$f - matchLeft=$matchLeftCount" #-Verbose
        if($matchLeftCount -gt $matchRightCount -and $selectedTextLineCount -eq 1)
        { 
            Write-Verbose -Message "$f -  Inserting )" #-Verbose
            $Sender.InsertText(')')
            [int]$col = $Sender.CaretColumn
            [int]$line = $Sender.CaretLine
            Select-CaretLines -sender $Sender -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }
        else
        {
            
        }   
        Write-Verbose -Message "$f -  matchleft=$matchLeftCount matchright=$matchRightCount linecount=$selectedTextLineCount" #-Verbose                  
    }
}