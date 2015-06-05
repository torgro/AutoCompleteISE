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