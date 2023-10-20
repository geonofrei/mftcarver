	
	#GET INPUT PARAMETER VALUE

		param(
			[Parameter(Mandatory=$true)]
			[string]$inputFile,
			[switch]$s,
            [string]$d
			 )
		 
	#------------------------------------------------------------

	#SET MODULE VARIABLES

	$modulename = "07passmgr"
	$regex = "\\Users\\.*\\(Desktop|Downloads|Documents|Music|Pictures|Videos)\\.*\.(kdb|kdbx|kbdx|keepassx|keepassxc|pwsafe|psafe3|encrypted|enex|onepif|keychain|lastpass|dashlane|1password|roboform|keepersecurity|bitwarden|keepass|pwmanager|pwman|pwvault|pwdb|passwordsafe|pws|kev|kpl|buttercup|keepasshttp|keepassdroid|keepass2android|strongbox|keepass2|keepasshttpd|keepassium|keepasshttpi|keepassxcproxy|keepasshttpc|keepasshttpcgeneric|myki|pwmgr|pwsdb|pwdsafe|pwman3|pwd|pwman3db|s10wen-password-vault|saferpass|saferpassw|teampass|vpass|yapet|zulipass|authy|lastpass)\t"
		 
	#------------------------------------------------------------

	#USE REGEX VERSUS RAW MFT CSV & EXPORT TO TEMPORAL TSV

		 $raw_content = Get-Content -First 1 $inputfile | Out-File $d/$modulename.tsv; Select-String -Pattern $regex $inputfile | ForEach-Object {$_.Line} | Out-File $d/$modulename.tsv -Append

	#------------------------------------------------------------

	#SET SOURCE CSV

		$importdata = Import-Csv -Delimiter "`t" -Path $d/$modulename.tsv 

	#-------------------------------------------------------------

	#SET OUTPUT COLUMNS

		$results = @( $importData | Select-Object RecNo, Deleted, FullPath, "fnCreateTime (UTC)", "fnModTime (UTC)" | ForEach-Object {
			$_
		})

	#------------------------------------------------------------

	#STDOUT OUTPUT
		
		Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "PASSMGR MODULE RESULTS" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
		
		if ($results.Count -gt 0) {
		$results | Select-Object *,@{Label="CleanedUsername"; Expression={($_.FullPath -replace ".*(\?\\Users\\|\\Users\\)([^\\]*)\\.*",'$2')} } | Sort-Object -Property CleanedUsername,"fnModTime (UTC)" | Format-Table -Wrap -AutoSize -Property @{Label="MFT Entry"; Expression={$_.RecNo}}, @{Label="Deleted?"; Expression={$_.Deleted}}, @{Label="Username"; Expression={($_.FullPath -replace ".*(\?\\Users\\|\\Users\\)([^\\]*)\\.*",'$2')}}, @{Label="File Location"; Expression={($_.FullPath -replace ".*\\Users\\[^\\]+\\(Desktop|Downloads|Documents|Music|Pictures|Videos)\\(.*)\\?.*$",'$1\$2') -replace '(\?+)$',''}}, @{Label="fnCreateTime"; Expression={$_."fnCreateTime (UTC)"}}, @{Label="fnModTime"; Expression={$_."fnModTime (UTC)"}} | Tee-Object -Variable result | Out-File -FilePath "$d/report.txt" -Append -Width ([int]::MaxValue) ; $result
		} else {
			Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
			Write-Output "No entries found matching criteria" | Tee-Object -FilePath "$d/report.txt" -Append
			Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
			Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
		}
		
	#------------------------------------------------------------
	
	#PRESS ANY KEY TO EXIT IF NOT SILENT MODE
	
		function Press-Key {
			Write-Output "Finished! Press any key to exit..."
			$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		}

		if (-not $s) {
		Press-Key
		}
	
	#------------------------------------------------------------
