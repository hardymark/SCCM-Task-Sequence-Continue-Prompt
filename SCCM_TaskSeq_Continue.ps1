<#  
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

#>


$version = "v1.0 MHARDY 20-January-2017"

$Component = "SCCM_TaskSeq_Continue"

$ContinuePrompt = "You are about to experience something fantastic! Probably a Windows Upgrade. `n`nThe upgrade process may take considerable time, up to 2 hours. Your applications and user data will remain intact during the process. When it's complete you will be prompted to log in to Windows 10. `n`n*** Please verify the following before continuing: `n`n  > You can leave this computer running for up to 2 hours`n  > This computer is plugged into AC power`n  > This computer is connected to wired network connection `n`nClick Yes to continue with the upgrade right now. If you click No, you may select and retry this upgrade in Software Center when you are ready to proceed.`n`nAre you ready to continue?"

$ContinuePromptTitle = "  OPERATING SYSTEM DEPLOYMENT" 

$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment 

$logFile = "$($tsenv.Value('_SMSTSLogPath'))\$($Component).log"


Function Create-LogEntry {
	[CmdletBinding()]
	Param(
	  [Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)]
	  $sLogMsg
	)
PROCESS {
	# Populate the variables to log
	$sTime = (Get-Date -Format HH:mm:ss) + ".000+000"
	$sDate = Get-Date -Format MM-dd-yyyy
	$sTempMsg = "<![LOG[$sLogMsg]LOG]!><time=""$sTime"" date=""$sDate"" component=""$Component"" context="""" type="""" thread="""" file=""$Component"">"


	# Create the component log entry

	Write-Output $sTempMsg | Out-File -FilePath $logFile -Encoding "Default" -Append

}
} # End of Create-LogEntry function



# initialize log
Create-LogEntry "START $Component $version"

Create-LogEntry "Attempting to close the TSProgressUI dialog"
$TSProgressUI = new-object -comobject Microsoft.SMS.TSProgressUI
$TSProgressUI.CloseProgressDialog()


Create-LogEntry "Prompting user with upgrade information and option to continue YES/NO..."

Add-Type -AssemblyName System.Windows.Forms
$OUTPUT= [System.Windows.Forms.MessageBox]::Show($ContinuePrompt, $ContinuePromptTitle, 4) 
if ($OUTPUT -eq "YES" ) 
{

Create-LogEntry "   -- User clicked Yes"
Exit 0

} 
else 
{ 
Create-LogEntry "   -- User clicked No"
Exit 9
} 