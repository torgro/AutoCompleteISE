Function Add-ParameterBlock
{ 
Param(
    $Sender
)
$param = @'
Param(
    [string]$First
)
'@
    if($sender.CaretLineText -eq "Param" -or $Sender.CaretLineText -like "*Param")
    { 
        $psISE.CurrentFile.Editor.SelectCaretLine()
        $psISE.CurrentFile.Editor.InsertText($param)
        $line = $psISE.CurrentFile.Editor.CaretLine + 1
        Select-CaretLines -StartLine $line -StartCol 14 -EndLine $line -EndCol 19        
    }
}