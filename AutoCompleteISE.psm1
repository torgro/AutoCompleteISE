function Add-CurlyBracets
{ 
[cmdletbinding()]
Param(
    $Sender
    ,
    [switch]$NoNewLine
)
    if($Sender.CaretLineText[-1] -eq '{')
    {               
        $matchLeft = $sender.text | Select-String -Pattern "{" -AllMatches
        $matchLeftCount = $matchLeft.matches.count
        $matchRight = $sender.text | Select-String -Pattern "}" -AllMatches
        $matchRightCount = $matchRight.matches.count
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
        
        if($matchLeftCount -gt $matchRightCount -and $selectedTextLineCount -eq 1)
        {        
            $psISE.CurrentFile.Editor.InsertText(' }')
            [int]$col = $psISE.CurrentFile.Editor.CaretColumn
            [int]$line = $psISE.CurrentFile.Editor.CaretLine
            if($NoNewLine)
            {                
                Select-CaretLines -StartLine $line -StartCol ($col - 4) -EndLine $line
                $psISE.CurrentFile.Editor.InsertText('{  }')
                Set-CaretPosition -Line $line -Column ($col - 2)
                return $null
            }
            Set-CaretPosition -Line $line -Column ($col -1)

            $psise.CurrentFile.Editor.InsertText([environment]::NewLine)
            $psise.CurrentFile.Editor.InsertText([environment]::NewLine)

            $IndentCount = $Script:tabs.$col
            
            if($IndentCount -gt 0)
            { 
                $indent = $Script:tab * $IndentCount
                $psise.CurrentFile.Editor.InsertText($indent)
            }
            $psISE.CurrentFile.Editor.SelectCaretLine()
            $line = $psISE.CurrentFile.Editor.CaretLine
            
            Set-CaretPosition -Line ($line - 1) -Column 1
            
            $indent = $Script:tab * ($IndentCount + 1)
            $psise.CurrentFile.Editor.InsertText($indent)
        }
    }
}

Function Add-DoubleQuotes
{
[cmdletbinding()]
Param(
    $Sender
)
    if($Sender.CaretLineText[-1] -eq '"')
    { 
        $matchDoubleQuote = $Sender.CaretLineText | Select-String -Pattern '"' -AllMatches
        # Finding odd or even number (even
        $Mod = $matchDoubleQuote.Matches.Count % 2
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count

        if($mod -eq 1 -and $selectedTextLineCount -eq 1)
        { 
            $psISE.CurrentFile.Editor.InsertText('"')
            [int]$col = $psISE.CurrentFile.Editor.CaretColumn
            [int]$line = $psISE.CurrentFile.Editor.CaretLine
            Select-CaretLines -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }
    }
}

function Add-ElseBlock
{ 
Param(
    $Sender
)

$ElseBlock = @' 
else
{ 
    
}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($Sender.CaretLineText -eq "else " -or $sender.CaretLineText -like "*else " -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $psise.CurrentFile.Editor.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($ElseBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($ElseBlock)
        }
        
        Set-CaretPosition -Line ($currentLine + 2)        
    }
    
}

function Add-ForeachBlock
{ 
Param(
    $Sender
)

$ForeachBlock = @' 
Foreach (something)
{ 
    
}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($Sender.CaretLineText -eq 'Foreach ' -or $sender.CaretLineText -like "*Foreach " -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 8) 
        $psise.CurrentFile.Editor.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($ForeachBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($ForeachBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfRight = $psise.CurrentFile.Editor.CaretLineText.IndexOf("(")
        [Int]$IndexOfLeft = $psise.CurrentFile.Editor.CaretLineText.IndexOf(")")
        Select-CaretLines -StartLine $currentLine -StartCol ($IndexOfRight + 2) -EndLine $currentLine -EndCol ($IndexOfLeft + 1)
    }
    
}

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

function Add-IfBlock
{ 
Param(
    $Sender
)

$IfBlock = @' 
if (something)
{ 
    
}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($Sender.CaretLineText -eq 'if ' -or $sender.CaretLineText -like "*if " -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $psise.CurrentFile.Editor.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($IfBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($IfBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfRight = $psise.CurrentFile.Editor.CaretLineText.IndexOf("(")
        [Int]$IndexOfLeft = $psise.CurrentFile.Editor.CaretLineText.IndexOf(")")
        Select-CaretLines -StartLine $currentLine -StartCol ($IndexOfRight + 2) -EndLine $currentLine -EndCol ($IndexOfLeft + 1)
    }
    
}

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

function Add-PesterItBlock
{ 
Param(
    $Sender
)

$PesterItBlock = @' 
It "something" {

}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($Sender.CaretLineText -eq 'it ' -or $sender.CaretLineText -like "*it " -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $psise.CurrentFile.Editor.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($PesterItBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($PesterItBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfRight = $psise.CurrentFile.Editor.CaretLineText.IndexOf('"')
        [Int]$IndexOfLeft = $psise.CurrentFile.Editor.CaretLineText.LastIndexOf('"')
        Select-CaretLines -StartLine $currentLine -StartCol ($IndexOfRight + 2) -EndLine $currentLine -EndCol ($IndexOfLeft + 1)
    }
    
}

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

Function Add-SingleQuotes
{ 
Param(
    $Sender
)
    if($Sender.CaretLineText[-1] -eq "'")
    { 
        $matchDoubleQuote = $Sender.CaretLineText | Select-String -Pattern "'" -AllMatches
        # Finding odd or even number (even
        $Mod = $matchDoubleQuote.Matches.Count % 2
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count

        if($mod -eq 1 -and $selectedTextLineCount -eq 1)
        { 
            $psISE.CurrentFile.Editor.InsertText("'")
            [int]$col = $psISE.CurrentFile.Editor.CaretColumn
            [int]$line = $psISE.CurrentFile.Editor.CaretLine
            Select-CaretLines -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }
    }
}

function Add-SplatBlock
{ 
Param(
    $Sender
)
""
$SplatBlock =  @' 
$SplatObject = @{ 
    Key = "Value"
    newkey = "Value"
}
'@
    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count
    
    if($sender.CaretLineText -like "*``[splat``]")
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 6) 
        $psise.CurrentFile.Editor.SelectCaretLine()

        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($SplatBlock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($SplatBlock)
        }
        
        Set-CaretPosition -Line $currentLine -Column 1
        [Int]$IndexOfDollar = $psise.CurrentFile.Editor.CaretLineText.IndexOf("$")
        [Int]$IndexOfequal = $psise.CurrentFile.Editor.CaretLineText.IndexOf("=")
        Select-CaretLines -StartLine $currentLine -StartCol ($IndexOfDollar + 2) -EndLine $currentLine -EndCol $IndexOfequal
    }
    
}

function Add-SquareParenthesis
{ 
Param(
    $Sender
)
    if($Sender.CaretLineText[-1] -eq '[')
    { 
        $escaped = [regex]::Escape("[")
        $matchLeft = $sender.text | Select-String -Pattern $escaped -AllMatches
        $matchLeftCount = $matchLeft.matches.count
        $escaped = [regex]::Escape("]")
        $matchRight = $sender.text | Select-String -Pattern $escaped -AllMatches
        $matchRightCount = $matchRight.matches.count
        [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count

        if($matchLeftCount -gt $matchRightCount -and $selectedTextLineCount -eq 1)
        { 
            $psISE.CurrentFile.Editor.InsertText(']')
            [int]$col = $psISE.CurrentFile.Editor.CaretColumn
            [int]$line = $psISE.CurrentFile.Editor.CaretLine
            Select-CaretLines -StartLine $line -StartCol ($col -1) -EndLine $line -EndCol ($col -1)            
        }                      
    }
}

Function Add-TryBlock
{ 
[CmdletBinding()]
[OutputType([String])]
Param(
    $Sender
)
$tryblock = @"
Try 
{ 
    
}
Catch
{ 
    
}
Finally
{ 
    
}
"@

    [int]$selectedTextLineCount = ($Sender.SelectedText -split [environment]::NewLine | Measure-Object).count

    if($Sender.CaretLineText -eq 'try' -or $sender.CaretLineText -like "*try" -and $selectedTextLineCount -eq 1)
    { 
        [Int]$ColumnIndex = $psise.CurrentFile.Editor.CaretColumn
        [int]$currentLine = $psise.CurrentFile.Editor.CaretLine
        $tabCount = $Script:tabs.($columnIndex - 3)            
        $psise.CurrentFile.Editor.SelectCaretLine()
        if($tabCount -gt 0)
        { 
            $indent = $Script:tab * $tabCount
            $sb = New-Object System.Text.StringBuilder

            foreach($line in ($tryblock -split [environment]::NewLine))
            { 
                [void]$sb.Append($indent)
                [void]$sb.Append($line)
                [void]$sb.AppendLine()
            }                
            [void]$PSise.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))                
        }
        else
        { 
            [void]$PSise.CurrentFile.Editor.InsertText($tryblock)
        }        
        
        Set-CaretPosition -Line ($currentLine + 2)        
    }
}

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
    [int]$colIndex = $psise.CurrentFile.Editor.CaretLineText.LastIndexOf("[") + 1 #$psise.CurrentFile.Editor.CaretColumn - 3
    [int]$line = $psISE.CurrentFile.Editor.CaretLine 
    
    Select-CaretLines -StartLine $line -StartCol $colIndex -EndLine $line
    $psISE.CurrentFile.Editor.InsertText($InsertTxt)
    [bool]$containsIndent = $psise.CurrentFile.Editor.CaretLineText.Contains($Script:tab)
    $IndentCount = $Script:tabs.$colIndex
    
    if($IndentCount -gt 0 -and $containsIndent -eq $true)
    { 
        $psISE.CurrentFile.Editor.SetCaretPosition($line,1)
        $indent = $Script:tab * $IndentCount
        #$psise.CurrentFile.Editor.InsertText($indent)
    }

    [int]$col = $psise.CurrentFile.Editor.CaretLineText.length
    [int]$indexDollar = $sender.CaretLineText.LastIndexOf('$')

    if($InsertTxt.contains("="))
    { 
        [int]$endCol = $InsertTxt.IndexOf("=") + (4 * $IndentCount)        
        Select-CaretLines -StartLine $line -StartCol ($indexDollar + 2) -EndLine $line -EndCol $endCol
    }
    else
    { 
        Select-CaretLines -StartLine $line -StartCol ($indexDollar + 2) -EndLine $line
    }
}

Function Clear-ISEmenu
{ 
[CmdletBinding()]
[OutputType([String])]
Param(   
    $CurrentEvents
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"

    Foreach ($key in $CurrentEvents)
    { 
        if($CurrentEvents.$key)
        {
            Write-Verbose -Message "$f -  Removing event with id $($CurrentEvents.$key)"
            Unregister-Event -SubscriptionId $CurrentEvents.$key -Verbose:$false -ErrorAction SilentlyContinue
        }
    }

    Write-Verbose -Message "$f -  Removing menu items"

    if($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Enable AutoCompleteEvents")
    { 
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove(($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Enable AutoCompleteEvents"))
    }

    if($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Autocomplete")
    { 
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove(($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Autocomplete"))
    }

    if($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Toggle comment")
    { 
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove(($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Toggle comment"))
    }
    
    Write-Verbose -Message "$f - END"
}

function Enable-AutoCompleteEvent
{    
    [string]$BaseName = ($psISE.CurrentFile.DisplayName.Split("."))[0]
    if($script:EventsEnabled.$BaseName)
    { 
        Write-Verbose "Turning off events for $BaseName" -Verbose        
        Remove-AutoCompeteEvent
        break
    }
    else
    { 
        Write-Verbose "Turn ON events for $BaseName" -Verbose
    }
    
    $ObjEvent = Register-ObjectEvent -Inputobject $psISE.CurrentFile.Editor -EventName PropertyChanged -Action {           
            $EventName = $event.SourceEventArgs.PropertyName

#            Write-Verbose "event $EventName" -Verbose
            
            $script:BackSpaceMode = $false
            if($script:PrevCaretLine -eq $sender.CaretLine)
            {
                if (($script:PrevLineLength -$sender.CaretLineText.length) -eq 1)
                { 
                    $script:BackSpaceMode = $true
                }
            }
            
            if($script:BackSpaceMode -eq $false -and $EventName -eq "CaretColumn")
            {
                switch  -Wildcard ($sender.CaretLineText[-1])
                { 
                "{"
                { 
                    [Int]$LineLength = $sender.CaretLineText.Length
                                        
                    if ($LineLength -ge 2)
                    { 
                        [String]$Name = $sender.CaretLineText[($LineLength - 2)]
                        
                        if ($name -eq "7" -or $name -eq "-")
                        { 
                            Add-CurlyBracets -Sender $sender -NoNewLine
                        }
                        else
                        {                             
                            Add-CurlyBracets -Sender $sender
                        }
                    }
                    else
                    { 
                        Add-CurlyBracets -Sender $sender
                    }                 
                }

                "("
                { 
                    Add-RegularParenthesis -Sender $sender
                }

                '*`['
                { 
                    Add-SquareParenthesis -Sender $sender
                }

                "'"
                { 
                    Add-SingleQuotes -Sender $sender  
                }

                '"'
                { 
                    Add-DoubleQuotes -Sender $sender
                }
                
                default
                { 
                    Write-Verbose "Enable-AutoCompleteEvent - doing nothing"
                }
            }

                if($sender.CaretLineText -eq "param" -or $sender.CaretLineText -like "*param")
                { 
                    Add-ParameterBlock -Sender $sender
                }

                if($sender.CaretLineText -like "*``[st`]")
                { 
                    Add-TypeLine -Type String -Sender $sender
                }
            
                if($sender.CaretLineText -like "*``[in``]")
                { 
                    Add-TypeLine -Type Int -Sender $sender
                }
            
                if($sender.CaretLineText -like "*``[pso``]")
                {                
                    Add-TypeLine -Type PSobject -Sender $sender
                }

                if($sender.CaretLineText -like "*``[pscu``]")
                { 
                    Add-TypeLine -Type PScustomObject -Sender $sender
                }

                if($sender.CaretLineText -like "*``[bo``]")
                { 
                    Add-TypeLine -Type bool -Sender $sender
                }

                if($sender.CaretLineText -like "*``[pscre``]" -or $Sender.CaretLineText -like "*``[cre``]")
                { 
                    Add-TypeLine -Type PScredential -Sender $sender
                }

                if($sender.CaretLineText -like "*``[arr``]")
                { 
                    Add-TypeLine -Type Array -Sender $sender
                }

                if($sender.CaretLineText -like "*``[lista``]")
                { 
                    Add-TypeLine -Type ListArray -Sender $sender
                }

                if($sender.CaretLineText -like "*``[swi``]")
                { 
                    Add-TypeLine -Type Switch -Sender $sender
                }

                if($sender.CaretLineText -like "*``[splat``]")
                { 
                    Add-SplatBlock -Sender $sender
                }

                if($sender.CaretLineText -eq "try" -or $Sender.CaretLineText -like "*try")
                { 
                    Add-TryBlock -Sender $sender
                }

                if($sender.CaretLineText -like "*``[here``]")
                {                 
                    Add-HereString -Sender $sender
                }

                if($sender.CaretLineText -like "*If " -or $sender.CaretLineText -eq "if ")
                { 
                    Add-IfBlock -Sender $sender
                }           
            
                if($sender.CaretLineText -like "*else " -or $sender.CaretLineText -eq "else ")
                { 
                    Add-ElseBlock -Sender $sender
                }

                if($sender.CaretLineText -like "*foreach " -or $sender.CaretLineText -eq "foreach ")
                { 
                    Add-ForeachBlock -Sender $sender
                }

                if($sender.CaretLineText -like "*it " -or $sender.CaretLineText -eq "it ")
                { 
                    Add-PesterItBlock -Sender $sender
                }
            }

        $script:PrevCaretLine = $Sender.CaretLine
        $script:PrevLineLength = $psISE.CurrentFile.Editor.CaretLineText.Length
    }
    
    $script:EventsEnabled.$BaseName = $ObjEvent.id
}

function Get-Scriptlevel
{ 
    return $Script:EventsEnabled
}

function Remove-AutoCompeteEvent
{ 
    [string]$BaseName = ($psISE.CurrentFile.DisplayName.Split("."))[0]
    $id = $script:EventsEnabled.$BaseName
    if($id)
    { 
        Write-Verbose "unregister id $id" -Verbose
        Unregister-Event -SubscriptionId $id
        [void]$script:EventsEnabled.Remove($BaseName)
    }
    else
    { 
        Write-Verbose "ID $ID was not found"
    }
}

function Select-CaretLines
{ 
[cmdletbinding()]
Param(
    [int]$StartLine
    ,
    [Int]$StartCol
    ,
    [Int]$EndLine
    ,
    [Int]$EndCol
)
    [Int]$StartLineLength = $psISE.CurrentFile.Editor.GetLineLength($StartLine) + 1
    [Int]$EndLineLength = $psISE.CurrentFile.Editor.GetLineLength($EndLine) + 1
    [bool]$Return = $false

    if(-not $EndCol)
    {
        $EndCol = $EndLineLength
    }

    if($StartLineLength -ge $StartCol -and $EndLineLength -ge $EndCol)
    { 
        Write-Verbose -Message "Setting selection startline=$StartLine, startcol=$StartCol, endline=$EndLine, EndCol=$EndCol"
        $psISE.CurrentFile.Editor.Select($StartLine,$StartCol,$EndLine,$EndCol)
        $Return = $true
    }
    else
    { 
        Write-Warning "Unable to set selection, startline=$StartLine, startcol=$StartCol, endline=$EndLine, EndCol=$EndCol"
    }

    return $Return
}

function Set-CaretPosition
{ 
[cmdletbinding()]
Param(
    [int]$Line
    ,
    [Int]$Column
)
    [String]$f = $MyInvocation.InvocationName
    [int]$Length = $psISE.CurrentFile.Editor.GetLineLength($line) + 1
    [bool]$Return = $false

    if(-not $Column)
    {
        $Column = $Length
    }

    if($Length -ge $Column)
    { 
        Write-Verbose "$f - Setting position for line $Line, wanted column was $Column, length is $Length for line $Line"
        $psise.CurrentFile.Editor.SetCaretPosition($Line,$Column)
        $Return = $true
    }
    else
    { 
        Write-Warning "$f - Unable to set pos, wanted column was $Column, length was $Length for line $Line"
    }

    return $Return
}

function Switch-Comment
{ 
    [string]$selected = $psISE.CurrentFile.Editor.SelectedText

    $LineCount = ($selected -split [environment]::NewLine | Measure-Object).Count
    
    if($LineCount -eq 1)
    { 
        [void]$psISE.CurrentFile.Editor.SelectCaretLine()
        $selected = $psISE.CurrentFile.Editor.SelectedText
        
        if($selected.Contains("#") -eq $true)
        { 
            $selected = $selected.Replace("#","")
        }
        else
        { 
            $selected = "#$selected"
        }
        [void]$psISE.CurrentFile.Editor.InsertText($selected)
    }
    else
    { 
        if($selected.Contains("#") -eq $true)
        { 
            $selected = $selected.Replace("#","")
            [void]$psISE.CurrentFile.Editor.InsertText($selected)
        }
        else
        { 
            $sb = New-Object System.Text.StringBuilder
            foreach($line in ($selected -split [environment]::NewLine))
            { 
                [void]$sb.Append("#$line")
                [void]$sb.AppendLine()
            }
            
            [void]$psISE.CurrentFile.Editor.InsertText($sb.ToString().TrimEnd([environment]::NewLine))
        }
    }
}

$currentPath = ($psISE.CurrentFile.FullPath | Split-Path -ErrorAction SilentlyContinue)

if(-not $currentPath)
{ 
    $currentPath = "C:\Users\Tore\Dropbox\SourceTreeRepros\"
    cd $currentPath -ErrorAction SilentlyContinue
}

[int]$PrevCaretLine = 1
[int]$PrevLineLength = 1
[bool]$BackSpaceMode = $false

$EventsEnabled = @{}

$tab = @"
    
"@

$tabs = @{ 
    1 = 0
    2 = 0
    3 = 0
    4 = 0
    5 = 1
    6 = 1
    7 = 1
    8 = 1
    9 = 2
    10 = 2
    11 = 2
    12 = 2
    13 = 3
    14 = 3
    15 = 3
    16 = 3
    17 = 4
    18 = 4
    19 = 4
    20 = 4
    21 = 5
    22 = 5
    23 = 5
    24 = 5
    25 = 6
    26 = 6
    27 = 6
    28 = 6
    29 = 7
}

$Splat = @'
$SplatObject = @{ 
    Key = "Value"
    Key = "Value"
}
'@
                            
$if = @"
if(aaaaaa)
{ 
    
}
else
{ 
    
}
"@

$foreach = @'
foreach($a in $collection)
{ 
    
}
'@

$func = @'
Function NameMe
{ 
[CmdletBinding()]
[OutputType([String])]
Param(
    [Parameter( Mandatory=$true, 
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true, 
                ValueFromRemainingArguments=$false, 
                Position=0,
                ParameterSetName='Parameter Set 1')]
   [string]$Dummy
)
    $f = $MyInvocation.InvocationName
    Write-Verbose -Message "$f - START"



    Write-Verbose -Message "$f - END"
}
'@

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { 
    Clear-ISEmenu -CurrentEvents $Script:EventsEnabled -Verbose
 }

$AutoCompleteAction = { 
    Get-AutoComplete -keyWord $psise.CurrentFile.Editor.CaretLineText -columnIndex $psise.CurrentFile.Editor.CaretColumn
}

$AutoCompleteKey =  new-object System.Windows.Input.KeyGesture([windows.input.key]::d1,[windows.input.modifierkeys]::Alt)
$ToggleCommentKey =  new-object System.Windows.Input.KeyGesture([windows.input.key]::d3,[windows.input.modifierkeys]::Alt)

$commentAction = { 
    Switch-Comment
}

if(-not ($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Enable AutoCompleteEvents"))
{ 
    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Enable AutoCompleteEvents", { Enable-AutoCompleteEvent },"F2")
}

#if(-not ($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Autocomplete"))
#{ 
#    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Autocomplete", $AutoCompleteAction, $AutoCompleteKey)
#}

if(-not ($psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | where DisplayName -eq "Toggle comment"))
{ 
    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Toggle comment", $commentAction, $ToggleCommentKey)
}





