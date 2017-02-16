#
# Original Author: Lee Holmes, http://www.leeholmes.com/blog/MorePowerShellSyntaxHighlighting.aspx
#
# Modified by: Helge Klein, http://blogs.sepago.de/helge/
#

#
# Syntax highlights a PowerShell script.
#
# Usage: Supply the script to syntax hightligh as first and only parameter
#
# Output: Copy of original script with extension ".html"
#
# Example: .\Highlight-Syntax.ps1 .\Get-AppVPackageDependencies.ps1
#
# Version history:
#
# 1.1:
#
#		- Loading the required assembly System.Web now. This was missing earlier.
#
# 1.0: Initial version
#

[CmdletBinding()]
param($path)

# Load required assemblies
[void] [System.Reflection.Assembly]::Load("System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")

$tokenColours = @{
    'Attribute' = '#FFADD8E6'
    'Command' = '#FF0000FF'
    'CommandArgument' = '#FF8A2BE2'
    'CommandParameter' = '#FF000080'
    'Comment' = '#FF006400'
    'GroupEnd' = '#FF000000'
    'GroupStart' = '#FF000000'
    'Keyword' = '#FF00008B'
    'LineContinuation' = '#FF000000'
    'LoopLabel' = '#FF00008B'
    'Member' = '#FF000000'
    'NewLine' = '#FF000000'
    'Number' = '#FF800080'
    'Operator' = '#FFA9A9A9'
    'Position' = '#FF000000'
    'StatementSeparator' = '#FF000000'
    'String' = '#FF8B0000'
    'Type' = '#FF008080'
    'Unknown' = '#FF000000'
    'Variable' = '#FFFF4500'
}

# Generate an HTML span and append it to HTML string builder
$currentLine = 1
function Append-HtmlSpan ($block, $tokenColor)
{
	if (($tokenColor -eq 'NewLine') -or ($tokenColor -eq 'LineContinuation'))
	{
		if($tokenColor -eq 'LineContinuation')
		{
			$null = $codeBuilder.Append('`')
		}

		$null = $codeBuilder.Append("<br />`r`n")
	}
	else
	{
		$block = [System.Web.HttpUtility]::HtmlEncode($block)
		if (-not $block.Trim())
		{
			$block = $block.Replace(' ', '&nbsp;')
		}

		$htmlColor = $tokenColours[$tokenColor].ToString().Replace('#FF', '#')

		if($tokenColor -eq 'String')
		{
			$lines = $block -split "`r`n"
			$block = ""

			$multipleLines = $false
			foreach($line in $lines)
			{
				if($multipleLines)
				{
					$block += "<BR />`r`n"
				}

				$newText = $line.TrimStart()
				$newText = "&nbsp;" * ($line.Length - $newText.Length) + $newText
				$block += $newText
				$multipleLines = $true
			}
		}

		$null = $codeBuilder.Append("<span style='color:$htmlColor'>$block</span>")
	}
}

function Main
{
	$text = $null

	if($path)
	{
		$text = (Get-Content $path) -join "`r`n"
	}
	else
	{
		Write-Error 'Please supply the path to the PowerShell script to syntax highlight as first (and only) parameter.'
		return
	}

	trap { break }

	# Do syntax parsing.
	$errors = $null
	$tokens = [system.management.automation.psparser]::Tokenize($Text, [ref] $errors)

	# Initialize HTML builder.
	$codeBuilder = new-object system.text.stringbuilder

	# Iterate over the tokens and set the colors appropriately.
	$position = 0
	foreach ($token in $tokens)
	{
		if ($position -lt $token.Start)
		{
			$block = $text.Substring($position, ($token.Start - $position))
			$tokenColor = 'Unknown'
			Append-HtmlSpan $block $tokenColor
		}

		$block = $text.Substring($token.Start, $token.Length)
		$tokenColor = $token.Type.ToString()
		Append-HtmlSpan $block $tokenColor

		$position = $token.Start + $token.Length
	}

	# Build the entire syntax-highlighted script
	$code = $codeBuilder.ToString()
	
	# Replace tabs with three blanks
	$code	= $code -replace "\t","   "

	# Write the HTML to a file
	$code | set-content -path "$path.html"
}

. Main
# SIG # Begin signature block
# MIIJqAYJKoZIhvcNAQcCoIIJmTCCCZUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUoVpYzSFqopu1c0vCm4Zok+mq
# xpigggcIMIIDTjCCAregAwIBAgIBCjANBgkqhkiG9w0BAQUFADCBzjELMAkGA1UE
# BhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3du
# MR0wGwYDVQQKExRUaGF3dGUgQ29uc3VsdGluZyBjYzEoMCYGA1UECxMfQ2VydGlm
# aWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEhMB8GA1UEAxMYVGhhd3RlIFByZW1p
# dW0gU2VydmVyIENBMSgwJgYJKoZIhvcNAQkBFhlwcmVtaXVtLXNlcnZlckB0aGF3
# dGUuY29tMB4XDTAzMDgwNjAwMDAwMFoXDTEzMDgwNTIzNTk1OVowVTELMAkGA1UE
# BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xHzAd
# BgNVBAMTFlRoYXd0ZSBDb2RlIFNpZ25pbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQAD
# gY0AMIGJAoGBAMa4uSdgrwvjkWll236N7ZHmqvG+1e3+bdQsf9Fwd/smmVe03T8w
# uNwh6miNgZL8LkuRNYQg8tpKurT85tqI8iDFIZIJR5WgCRymeb6xTB388YpuVNJp
# ofFMkzpB/n3UZHtjRfdgYB0xHaTp0w+L+24mJLOo/+XlkNS0wtxQYK5ZAgMBAAGj
# gbMwgbAwEgYDVR0TAQH/BAgwBgEB/wIBADBABgNVHR8EOTA3MDWgM6Axhi9odHRw
# Oi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUHJlbWl1bVNlcnZlckNBLmNybDAdBgNV
# HSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQDAgEGMCkGA1Ud
# EQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTE0NDANBgkqhkiG9w0B
# AQUFAAOBgQB2spzuE58b9i00kpRFczTcjmsuXPxMfYnrw2jx15kPLh0XyLUWi77N
# igUG8hlJOgNbBckgjm1S4XaBoMNliiJn5BxTUzdGv7zXL+t7ntAURWxAIQjiXXV2
# ZjAe9N+Cii+986IMvx3bnxSimnI3TbB3SOhKPwnOVRks7+YHJOGv7DCCA7IwggMb
# oAMCAQICEHNhhue4uU1+s8A9GgnRvq8wDQYJKoZIhvcNAQEFBQAwVTELMAkGA1UE
# BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xHzAd
# BgNVBAMTFlRoYXd0ZSBDb2RlIFNpZ25pbmcgQ0EwHhcNMDgwNjA0MDAwMDAwWhcN
# MTAwNzIyMjM1OTU5WjB7MQswCQYDVQQGEwJERTEMMAoGA1UECAwDTlJXMRAwDgYD
# VQQHDAdDb2xvZ25lMRQwEgYDVQQKDAtzZXBhZ28gR21iSDEgMB4GA1UECwwXVEVD
# SE5PTE9HWSAmIElOTk9WQVRJT04xFDASBgNVBAMMC3NlcGFnbyBHbWJIMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0fjJSiGCir24lmFkRxGLtUbPjv1J
# kAKEryh2SOIVkpvGNtBN12XcL01f6RwhqDCIl50W6edJtl4FuduZyBT/vumWwwwF
# lsVjryh1/yHoNjWwzPrQhKwEUyZ4oDvd5H1Bu3V73ZRm5MCFPH6i79sRY95g0YXL
# gLvhwHR0VRk1jBD6YMnbL2g+j4rpWQDrnbK/umzPatj4kHJtOU7GpzUUD6omi2Vp
# D+lxDpFIkpLyUWcxqW+Uqm3J+ALOn0bPLQxTpPusxAUuPB4JWQEBmHjOgUcbbMZI
# bRe9l2xJgfiCf9WsqbyqbmzAGhEPbqk1Mpefvfu10pPIIsM+y4KQMdQ/owIDAQAB
# o4HYMIHVMAwGA1UdEwEB/wQCMAAwPgYDVR0fBDcwNTAzoDGgL4YtaHR0cDovL2Ny
# bC50aGF3dGUuY29tL1RoYXd0ZUNvZGVTaWduaW5nQ0EuY3JsMB8GA1UdJQQYMBYG
# CCsGAQUFBwMDBgorBgEEAYI3AgEWMB0GA1UdBAQWMBQwDjAMBgorBgEEAYI3AgEW
# AwIHgDAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLnRo
# YXd0ZS5jb20wEQYJYIZIAYb4QgEBBAQDAgQQMA0GCSqGSIb3DQEBBQUAA4GBAAig
# eVC+/msgnaskTzEyzMlzjol+W6t8cEXQiOozPFvGR7ocMz9epqU1khfeapOoJYiI
# yJqJb7fJJ4Y1xtLK2hqGu0CxjYgPj2bybRIV6CP/P5iIzgZ7NbrdvU/Kjm+ZFs1f
# 4TEBW610OXtSzPc0y4KbdEHXSU+9qEQAqkFtBt01MYICCjCCAgYCAQEwaTBVMQsw
# CQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRk
# LjEfMB0GA1UEAxMWVGhhd3RlIENvZGUgU2lnbmluZyBDQQIQc2GG57i5TX6zwD0a
# CdG+rzAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkq
# hkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGC
# NwIBFjAjBgkqhkiG9w0BCQQxFgQUAhvHdQnrUb8mhOJTZPVIOYhO5eowDQYJKoZI
# hvcNAQEBBQAEggEAGcyxErAmZn9dw9Wz8XTiK7MCgR0iUwSwyTc43p1Zq/aBdo4t
# tVJ02lo4SyuEVkPUsfTccJfDGZsNWQa+nVqpRnmBHv8Bvm6bKQHgSPggkV+uU2qa
# vQ3hzc/xJwWhufo/1xR+d8/QtZ91bJ+B7NPP4v0KSCnTeSJf5kxxdlpm7DmcBPwD
# ClnfoOuOwF1WKveZOwZblD65LGpv+Pn1NiSjFOqnnfcFT/kvQSwd7aOsAkJu5fvs
# XwB9x5hf+okHk8V+TrLFw4mmzjPP6ysoKZUCrAOq4oZOP/ApfDDqSeFfdJkhrzov
# 3FA1rQTQn2psxkJAu5Ssl6Kxoal97N9/XR3uAQ==
# SIG # End signature block
