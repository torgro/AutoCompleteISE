Function Add-TypeLine
{ 
Param(
    [ValidateSet("String","Int","PSobject","PScustomObject","bool","PScredential", "Array", "ListArray","Switch")]
    [string]$Type
    ,
    $sender
)
    $Types = @{ 
        String         = '[String]$Name'
        Int            = '[Int]$Number'
        PSobject       = '[PSobject]$PSobject'
        PScustomObject = '[PScustomObject]$Object'
        bool           = '[bool]$Name'
        PScredential   = '[PScredential]$Credential'
        Array          = '[Array]$Array'
        ListArray      = '[ArrayList]$Array = New-Object System.Collections.ArrayList'
        Switch         = '[Switch]$Switch'
    }

    [string]$InsertTxt = $Types["$Type"]
    [int]$colIndex = $sender.CaretLineText.LastIndexOf("[") + 1 #$psise.CurrentFile.Editor.CaretColumn - 3
    [int]$line = $sender.CaretLine 
    
    Select-CaretLines -sender $sender -StartLine $line -StartCol $colIndex -EndLine $line
    $sender.InsertText($InsertTxt)
    [bool]$containsIndent = $sender.CaretLineText.Contains($Script:tab)
    $IndentCount = $Script:tabs.$colIndex
    
    if($IndentCount -gt 0 -and $containsIndent -eq $true)
    { 
        $sender.SetCaretPosition($line,1)
        $indent = $Script:tab * $IndentCount
        #$psise.CurrentFile.Editor.InsertText($indent)
    }

    [int]$col = $sender.CaretLineText.length
    [int]$indexDollar = $sender.CaretLineText.LastIndexOf('$')

    if($InsertTxt.contains("="))
    { 
        [int]$endCol = $InsertTxt.IndexOf("=") + (4 * $IndentCount)        
        Select-CaretLines -sender $sender -StartLine $line -StartCol ($indexDollar + 2) -EndLine $line -EndCol $endCol
    }
    else
    { 
        Select-CaretLines -sender $sender -StartLine $line -StartCol ($indexDollar + 2) -EndLine $line
    }
}