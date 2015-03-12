# AutoCompleteISE
Autocomplete commands for ISE

## Features

Features currently supported features (| = represent the cursor and _ = space (blank space))

- **(** will produce (|) with the cursor in the middle
- **[** will produce [|] with the cursor in the middle
- **"** will produce "|" with the cursor in the middle
- **'** will produce '|' with the cursor in the middle
- **7{** will produce { | } with the cursor in the middle
- **-{** will produce { | } with the cursor in the middle
- **{** will produce a 3 line block with the cursor in the middle line

- **if_** will produce an if-statement, the condition will be selected
- **else_** will produce an else-statement
- **try_** will produce an full try..catch..finally statement
- **foreach_** will produce a foreach-statement, the condition will be selected
- **Param** will produce a Param-block with one parameter and the name of the parameter will be selected
- **[here]** will produce a here-string variable and place the cursor on the next line
- **[splat]** will produce a splatting (keyValuepair) variable and select the variable name

- **[st]** will produce a string variable [string]$Name where 'Name' will be selected
- **[in]** will produce a INT variable [Int]$Number where 'Number' will be selected
- **[bo]** will produce a bool variable [bool]$Name where 'Name' will be selected
- **[pso]** will produce a PSobject variable [PSobject]$PSobject where 'PSobject' will be selected
- **[pscu]** will produce a PScustomObject variable [PScustomObject]$Object where 'Object' will be selected
- **[swi]** will produce a Switch variable [Switch]$Switch where 'Switch' will be selected
- **[pscre]** will produce a PScredential variable [PScredential]$Credential where 'Credential' will be selected
- **[cre]** will produce a PScredential variable [PScredential]$Credential where 'Credential' will be selected
- **[arr]** will produce a Array variable [Array]$Array where 'Array' will be selected
- **[lista]** will produce a ArrayList variable [ArrayList]$Array = New-Object System.Collections.ArrayList where 'Array' will be selected

The extension also support selection based comment toggling using a single # (not comment-block syntax) using **ALT+3**. There is also 
an menu-item on the Add-Ons-menu that let you comment/uncomment the current selection

The autocomplete features are events driven. You have to enable the event for every powershell script-tab to get autocomplete by
pressing **F2** or selecting **"Enable AutocompleteEvents"** on the Add-Ons-menu.

## How to install

The repro contains everything I used to build the module. You only need the .psd1 and .psm1 files to use the module. Simply import the module in ISE
and turn on autocomplete by pressing **F2** or choosing from the Add-Ons-menu.

## Video

There is a short video on Youtube demonstrating the module [https://www.youtube.com/watch?v=6PSMbDgQOaU!]( https://www.youtube.com/watch?v=6PSMbDgQOaU)