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
            $f = "Enable-AutoCompleteEvent"
#            Write-Verbose "event $EventName" -Verbose
            
            $script:BackSpaceMode = $false
            if($script:PrevCaretLine -eq $sender.CaretLine)
            {           
                if(($script:PrevLineCursorPosition - $sender.CaretColumn) -ge 1)
                { 
                    $script:BackSpaceMode = $true
                }
            }
            #Write-Verbose -Message "Enable-AutoCompleteEvent -  Backspacemode=$script:BackSpaceMode" -Verbose
            #Write-Verbose -Message "line = $($sender.CaretLineText)" -Verbose
            if($script:BackSpaceMode -eq $false -and $EventName -eq "CaretColumn")
            { 
                [Int]$LastTypedPosition = $sender.CaretColumn - 2
                #Write-Verbose -Message "$f -  lasttyped=$($sender.CaretLineText[$LastTypedPosition])" -Verbose
                switch -Wildcard ($sender.CaretLineText[$LastTypedPosition])
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
                    #Write-Verbose -Message "$f - calling Add-RegularParenthesis"
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

                if($sender.CaretLineText -like "*context " -or $sender.CaretLineText -eq "context ")
                {                     
                    Add-PesterContext -Sender $sender
                }
            }

        $script:PrevCaretLine = $Sender.CaretLine
        $script:PrevLineCursorPosition = $sender.CaretColumn
    }
    
    $script:EventsEnabled.$BaseName = $ObjEvent.id
}