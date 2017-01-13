<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.3.131
	 Created on:   	1/1/2017 3:32 PM
	 Created by:   	Wei-Yen Tan
	 Organization: 	
	 Filename:     	Prodtools.psm1
	-------------------------------------------------------------------------
	 Module Name: Prodtools
	===========================================================================
#>

class WhoisInformation
{
	[string]$as;
	[string]$city;
	[string]$country;
	[string]$countryCode;
	[string]$isp;
	[decimal]$lat;
	[decimal]$lon;
	[string]$org;
	[string]$query;
	[string]$region;
	[string]$regionName;
	[string]$status;
	[string]$timezone;
	[string]$domain;
	[int]$zip;
	
}

Update-TypeData -TypeName WhoisInformation -MemberType ScriptProperty -MemberName Company -Value { $this.org } -Force
Update-TypeData -TypeName WhoisInformation -MemberType ScriptProperty -MemberName ipaddress -Value { $this.query } -Force
Update-TypeData -TypeName WhoisInformation -DefaultDisplayPropertySet ipaddress, Company, Timezone, City -DefaultDisplayProperty ipaddress -DefaultKeyPropertySet ipaddress -Force

function Get-WhoisInformation
{
	#	.EXTERNALHELP Prodtools.psm1-Help.xml
	#		
	
	[CmdletBinding()]
	[OutputType([WhoisInformation])]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1)]
		[Alias('ipaddress')]
		[string[]]$domain
	)
	
	begin { }
	Process
	{
		if (!$domain)
		{
			$object = Invoke-RestMethod -uri http://ip-api.com/json/
		}
		else
		{
			
			foreach ($item in $domain)
			{
				
				$object = Invoke-RestMethod -Uri http://ip-api.com/json/$item
				
			}
		}
		
		# $object |  Add-Member -TypeName WhoisInformation -MemberType NoteProperty -Name Domain -Value $domain
		
		Write-Output ([WhoisInformation]$object)
	}
	
	End { }
}

New-Alias gwhois -Value Get-WhoisInformation
Export-ModuleMember -Function Get-WhoisInformation
Export-ModuleMember -Alias gwhois


