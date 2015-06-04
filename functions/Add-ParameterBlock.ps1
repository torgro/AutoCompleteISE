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
    if($sender.CaretLineText.TrimStart(" ") -eq "Param")
    { 
        $Sender.SelectCaretLine()
        $Sender.InsertText($param)
        $line = $Sender.CaretLine + 1
        Select-CaretLines -sender $Sender -StartLine $line -StartCol 14 -EndLine $line -EndCol 19        
    }
}