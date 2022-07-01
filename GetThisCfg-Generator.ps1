<#
.SYNOPSIS
	DFIR-Orc GetThis config file generator.
.DESCRIPTION
	.
.PARAMETER FileName
	Required. The name of the newly created configuration file.
.PARAMETER Lim
	Switch parameter. Used to indicate if sample size limitations are to be set.
.EXAMPLE
    C:\PS> ./GetThis_gen.ps1 -FileName <Name of the output file>
		Creates a configuration file without specifying any size limits.

.EXAMPLE
    C:\PS> ./GetThis_gen.ps1 -FileName <Name of the output file> -Lim
		Creates a configuration file with size limits. Limits are to be specified at runtime.

.NOTES
    Author: Accipiter13
    Date:   30-06-2022
#>

#
	
	[CmdletBinding()]
	param (
		[Parameter(Position=0, Mandatory=$true)]
		[string] $FileName,
		[Parameter(Position=1, Mandatory=$false)]
		[switch] $Lim
	)

	if ($PSBoundParameters.Count -lt 1 -or $FileName -eq $null) {
		Get-Help $MyInvocation.MyCommand.Definition -Detailed
		return
	}
	If (Test-Path $FileName -PathType Leaf) {
		$tmp = Read-Host "$FileName already exists, do you want to continue (y/N)"
		if ($tmp -eq 'y' -or $tmp -eq 'Y') {New-Item -Path $FileName -ItemType File -Force}
		else {return} 
	}
	"<?xml version='1.0'?>" | Out-File -FilePath $FileName -Append
	if ($Lim) {
		"Insert limits :`r"
		$MaxSampleBt = Read-Host "$FileName MaxPerSampleBytes "
		$MaxTotalBt = Read-Host "$FileName MaxTotalBytes "
		$MaxSampleCount = Read-Host "$FileName MaxSampleCount "
		"<getthis reportall=''>`r  <location>%SystemDrive%\</location>" | Out-File -FilePath $FileName -Append
		"  <samples MaxPerSampleBytes='$MaxSampleBt' MaxTotalBytes='$MaxTotalBt' MaxSampleCount='$MaxSampleCount'>" | Out-File -FilePath $FileName -Append
	} else {
		"<getthis reportall='' nolimits=''>`r  <location>%SystemDrive%\</location>`r  <samples>" | Out-File -FilePath $FileName -Append
	}
	while ($true) {
		$SmplName = Read-Host "Sample name (leave empty to stop) "
		if ($SmplName) {
			"    <sample name='$SmplName'>" | Out-File -FilePath $FileName -Append
			while ($true) {
				$Type = Read-Host "Match type (default path_match, 'stop' to stop) "
				if ($Type -eq "") {
					$Type = "path_match"
				} elseif ($Type -eq "stop") {
					break
				}
				$SmplPath = Read-Host "Sample path "
				"      <ntfs_find $Type='$SmplPath' />" | Out-File -FilePath $FileName -Append
			}
			"    </sample>" | Out-File -FilePath $FileName -Append
		} else {break};
	}
	"  </samples>`r</getthis>" | Out-File -FilePath $FileName -Append
	return
