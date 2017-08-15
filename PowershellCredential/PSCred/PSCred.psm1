<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.141
	 Created on:   	14/08/2017 8:31 PM
	 Created by:   	weiyentan
	 Organization: 	
	 Filename:     	PSCred.psm1
	-------------------------------------------------------------------------
	 Module Name: PSCred
	===========================================================================
#>

function New-DPAPICredentialFile
{
<#
	.EXTERNALHELP PSCred-Help.xml
		
#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[string]$path,
		[Parameter(Position = 1)]
		[pscredential]$Credential = (Get-Credential)
	)
	Write-Verbose "Creating Credential file to $path"
	$Credential | Export-Clixml $path
}


function New-AESKeyFile
{
<#
	.EXTERNALHELP PSCred-Help.xml
		
#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Position = 0)]
		[string]$Path,
		[ValidateNotNullOrEmpty()]
		[ValidateSet('16', '24', '32')]
		$byte = '32'
	)
	
	$Key = New-Object Byte[] $byte
	[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
	Write-Verbose "Creating AES key using $byte byte encryption to path $Path "
	$Key | out-file $path
}


function New-AESCredentialObject
{
<#
	.EXTERNALHELP PSCred-Help.xml
		
#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[string]$Identity,
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[string]$PasswordPath,
		[Parameter(Mandatory = $true,
				   Position = 2)]
		[string]$AESKeyPath
	)
	
	$User = $Identity
	$PasswordFile = $PasswordPath
	$KeyFile = $AESKeyPath
	$key = Get-Content $KeyFile
	$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential ` -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)
	Write-Output $MyCredential
}

function New-AESPasswordFile
{
<#
	.EXTERNALHELP PSCred-Help.xml
		
#>
	
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[string]$path,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 1)]
		[string]$password,
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 2)]
		[string]$keyfile
	)
	$PasswordFile = $path
	$KeyF = $keyfile
	$Key = Get-Content $Keyf
	Write-Verbose "Creating AES Password File to path $PasswordFile "
	$Password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile
}



Export-ModuleMember -Function New-DPAPICredentialFile,
					New-AESKeyFile,
					New-AESCredentialObject,
					New-AESPasswordFile

New-Alias -Name ndpapi -Value New-DPAPICredentialFile
New-Alias -Name naeskey -Value New-AESKeyFile
New-Alias -Name naespwd -Value New-AESPasswordFile
New-Alias -Name naescredobj -Value New-AESCredentialObject

Export-ModuleMember -Alias ndpapi,
					naeskey,
					naespwd,
					naescredobj
