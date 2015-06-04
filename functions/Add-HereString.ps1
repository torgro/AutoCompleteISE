function Add-HereString
{ 
Param(
    $Sender
)
$here = @" 
`$here = @' 
    
'@
"@

    if($Sender.CaretLineText.TrimStart(" ") -like "``[here``]")
    { 
        $Sender.SelectCaretLine()
        $Sender.InsertText($here)
        $line = $Sender.CaretLine + 1
        Set-CaretPosition -sender $Sender -Line $line -Column 5
    }
}