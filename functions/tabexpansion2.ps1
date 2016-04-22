function TabExpansion2
{
[CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
Param(
    [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
    [string] $inputScript,
    
    [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 1)]
    [int] $cursorColumn,

    [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
    [System.Management.Automation.Language.Ast] $ast,

    [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
    [System.Management.Automation.Language.Token[]] $tokens,

    [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
    [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,
    
    [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
    [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
    [Hashtable] $options = $null
)

End
{
    if(-not $options) { $options = @{} }

    $options["CustomArgumentCompleters"] = @{
        "Get-ChildItem:Filter" = { "*.ps1","*.txt" }
        "ComputerName" = { "Comp1", "localhost" }
    }

    $options["NativeArgumentCompleters"] = @{
        "attrib" = { "+R", "+H" }
    }

    $quickCompletions = @(
        'Get-Process -Name Powershell | ? Id -ne $pid | Stop-Process',
        'Set-Location $pshome'
    )

    $result = $null

    if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet')
    {
        $result = [System.Management.Automation.CommandCompletion]::CompleteInput(
            <#inputScript#>  $inputScript,
            <#cursorColumn#> $cursorColumn,
            <#options#>      $options
            )
    }
    else
    {
        $result = [System.Management.Automation.CommandCompletion]::CompleteInput(
            <#ast#>              $ast,
            <#tokens#>           $tokens,
            <#positionOfCursor#> $positionOfCursor,
            <#options#>          $options
            )
    }

    if($result.CompletionMatches.Count -eq 0)
    {
        if($psCmdlet.ParameterSetName -eq "ScriptInputSet")
        {
            $ast = [System.Management.Automation.Language.Parser]::ParseInput(
            $inputScript, [ref]$tokens, [ref]$null
            )
        }
        [string]$text = $ast.Extent.Text
        Set-Content -Path c:\temp\ast.txt -Value "$([datetime]::Now.ToLongTimeString()) - asttext=$text"
        if($text.Contains("!!"))
        {
            $currentCompletionText = $Text.Replace("!!","")
            $quickCompletions | where { $_ -like "$currentCompletionText*" } | 
            ForEach-Object { $result.CompletionMatches.Add(
                (New-Object Management.Automation.CompletionResult $_,$_,"Text",$_) )
            }
        }
    }

    return $result
}
}

!!