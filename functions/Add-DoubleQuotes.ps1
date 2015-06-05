Function Add-DoubleQuotes
{
[cmdletbinding()]
Param(
    $Sender
)
    $f = $MyInvocation.InvocationName
    [Int]$LastTypedPosition = $sender.CaretColumn - 2
    if($Sender.CaretLineText[$LastTypedPosition] -eq '"')
    { 
        $matchDoubleQuote = $Sender.CaretLineText | Select-String -Pattern '"' -AllMatches
        # Finding odd or even number (even
        $Mod = $matchDoubleQuote.Matches.Count % 2
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
        #Write-Verbose -Message "$f - Precheck - mod = $mod and selectedTextLineCount = $selectedTextLineCount" -Verbose
        if($mod -eq 1 -and $selectedTextLineCount -eq 1)
        { 
            $Sender.InsertText('"')
            [int]$col = $Sender.CaretColumn
            [int]$line = $Sender.CaretLine
            Select-CaretLines -sender $Sender -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }
        else
        { 
            #Write-Verbose -Message "$f - mod = $mod and selectedTextLineCount = $selectedTextLineCount" -Verbose
        }
    }
    else
    { 
        #Write-Verbose -Message "$f -  CaretLineText - 1 -ne doublequoute" -Verbose
    }
    $var = New-Object -TypeName System.Collections.ArrayList
    
}