$Settings = @{
	BracketOnNewLine = $true
	AutoIndent       = $true
}

function Get-AutoCompleteSettings
{ 
    return $Script:Settings
}