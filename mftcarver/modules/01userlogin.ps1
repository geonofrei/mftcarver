	
	#GET INPUT PARAMETER VALUE

		param(
			[Parameter(Mandatory=$true)]
			[string]$inputFile,
			[switch]$s
			 )
			 
	#------------------------------------------------------------

	#SET MODULE VARIABLES

	$modulename = "01userlogin"
	$regex = "\t\\Users\\[^\\]+\\NTUSER\.DAT\t"
		 
	#------------------------------------------------------------

	#USE REGEX VERSUS RAW MFT CSV & EXPORT TO TEMPORAL TSV

		 $raw_content = Get-Content -First 1 $inputfile | Out-File ./reports/$modulename.tsv; Select-String -Pattern $regex $inputfile | Where-Object { $_.Line -notmatch '\\Users\\Default\\NTUSER\.DAT\t' } | ForEach-Object {$_.Line} | Out-File ./reports/$modulename.tsv -Append

	#------------------------------------------------------------

	#SET SOURCE CSV

		$importdata = Import-Csv -Delimiter "`t" -Path ./reports/$modulename.tsv

	#-------------------------------------------------------------

	#SET OUTPUT COLUMNS

		$results = @( $importData | Select-Object RecNo, Deleted, FullPath, "fnCreateTime (UTC)", "siModTime (UTC)" | ForEach-Object {
			$_
		})

	#------------------------------------------------------------

	#STDOUT OUTPUT

		Write-Output "" | Tee-Object -FilePath "./reports/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "./reports/report.txt" -Append
		Write-Output "USERLOGIN MODULE RESULTS" | Tee-Object -FilePath "./reports/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "./reports/report.txt" -Append
		Write-Output "" | Tee-Object -FilePath "./reports/report.txt" -Append
		
		if ($results.Count -gt 0) {
		$results | Select-Object *,@{Label="CleanedUsername"; Expression={($_.FullPath -replace ".*\\Users\\(.*)\\NTUSER\.DAT",'$1')} } | Sort-Object -Property "siModTime (UTC)", CleanedUsername | Format-Table -Wrap -AutoSize -Property @{Label="MFT Entry"; Expression={$_.RecNo}}, @{Label="Deleted?"; Expression={$_."Deleted"}}, @{Label="Username"; Expression={($_.FullPath -replace ".*\\Users\\(.*)\\NTUSER\.DAT",'$1')}}, @{Label="First Login"; Expression={$_."fnCreateTime (UTC)"}}, @{Label="Last Login"; Expression={$_."siModTime (UTC)"}} | Tee-Object -Variable result | Out-File -FilePath "./reports/report.txt" -Append -Width ([int]::MaxValue) ; $result
		} else {
			Write-Output "" | Tee-Object -FilePath "./reports/report.txt" -Append
			Write-Output "No entries found matching criteria" | Tee-Object -FilePath "./reports/report.txt" -Append
			Write-Output "" | Tee-Object -FilePath "./reports/report.txt" -Append
			Write-Output "" | Tee-Object -FilePath "./reports/report.txt" -Append
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
