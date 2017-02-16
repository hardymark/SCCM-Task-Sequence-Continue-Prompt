Script name: SCCM_TaskSeq_Continue.ps1
Script Ver : 1.0

This script is called from an SCCM Task Sequence. It prompts the local 
user with information and the option to continue or cancel.

Add the script file to a package with ServiceUI.exe (Get ServiceUI.exe 
from the latest MDT download, tested with build 8443, http://bit.ly/2kO5Fbv)

Execute within the task sequence as a "Run Command Line"
(NOT "Run Powershell Script"). Check the box to "Use Package" and
select the package that includes this script and ServiceUI.exe.

Command line: 
serviceUI.exe -process:TSProgressUI.exe C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File SCCM_TaskSeq_Continue.ps1 -WindowStyle Minimized


Edit the variables $ContinuePromptTitle and $ContinuePrompt to modify the
message displayed to the user. Use `n to provide line breaks (the simple 
messagebox form we're using does not support much in the way of rich
text). I have included sample text.


Requires: Powershell, ServiceUI.exe

Written by: Mark Hardy
            mark.hardy@compucom.com
            (310) 871-2493
            @hardymark
