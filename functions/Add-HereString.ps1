function Add-HereString
{ 
Param(
    $Sender
)
$here = @" 
`$here = @' 
    
'@
"@

    if($Sender.CaretLineText -like "*``[here``]")
    { 
        $psISE.CurrentFile.Editor.SelectCaretLine()
        $psISE.CurrentFile.Editor.InsertText($here)
        $line = $psISE.CurrentFile.Editor.CaretLine + 1
        Set-CaretPosition -Line $line -Column 5
    }
}