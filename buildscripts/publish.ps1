## Ensure all errors are terminating errors to catch
$ErrorActionPreference = 'Stop'

try {

	## Don't upload the build scripts and other artifacts when uploading to the PowerShell Gallery
	$tempmoduleFolderPath = "$env:Temp\PSAdSyncTool"
	$null = mkdir $tempmoduleFolderPath

	## Remove all of the files/folders to exclude out of the main folder
	$excludeFromPublish = @(
		'PSAdSyncTool\\buildscripts'
		'PSAdSyncTool\\appveyor\.yml'
		'PSAdSyncTool\\\.git'
		'PSAdSyncTool\\\.nuspec'
		'PSAdSyncTool\\README\.md'
		'PSAdSyncTool\\TestResults\.xml'

	)
	$exclude = $excludeFromPublish -join '|'
	Get-ChildItem -Path $env:APPVEYOR_BUILD_FOLDER -Recurse | where { $_.FullName -match $exclude } | Remove-Item -Force -Recurse

	## Publish module to PowerShell Gallery
	$publishParams = @{
		Path        = $env:APPVEYOR_BUILD_FOLDER
		NuGetApiKey = $env:nuget_apikey
	}
	Publish-PMModule @publishParams

} catch {
	Write-Error -Message $_.Exception.Message
	$host.SetShouldExit($LastExitCode)
}