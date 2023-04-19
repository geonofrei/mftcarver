	
	
	#GET INPUT PARAMETER VALUE

		param(
			[Parameter(Mandatory=$true)]
			[string]$inputFile,
			[switch]$s
			 )
		 
	#------------------------------------------------------------

	#USE REGEX VERSUS RAW MFT CSV & EXPORT TO TEMPORAL CSV

		 $raw_content = Get-Content -First 1 $inputfile | Out-File ./temp.csv; Select-String -Pattern '(\\Users\\.*\\(Recent)\\.*)' $inputfile | ForEach-Object {$_.Line} | Out-File ./temp.csv -Append

	#------------------------------------------------------------

	#SET SOURCE CSV

		$importdata = Import-Csv -Delimiter "`t" -Path ./temp.csv

	#-------------------------------------------------------------

	#SET OUTPUT COLUMNS

		$results = $importData | Select-Object RecNo, Deleted, FullPath, "fnModTime (UTC)", "fnCreateTime (UTC)"  | ForEach-Object {
			$_
		}

	#------------------------------------------------------------

	#STDOUT OUTPUT
		
		Write-Output "" | Tee-Object -FilePath "./report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "./report.txt" -Append
		Write-Output "USERACTIVITY MODULE RESULTS" | Tee-Object -FilePath "./report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "./report.txt" -Append
		Write-Output "" | Tee-Object -FilePath "./report.txt" -Append
		
		if ($results.Count -gt 0) {
		$results | Sort-Object -Property FullPath,"fnModTime (UTC)" | Format-Table -AutoSize -Property @{Label="MFT Entry"; Expression={$_.RecNo}}, @{Label="Deleted?"; Expression={$_.Deleted}}, @{Label="File Path"; Expression={$_.FullPath}}, @{Label="fnModTime"; Expression={$_."fnModTime (UTC)"}}, @{Label="fnCreateTime"; Expression={$_."fnCreateTime (UTC)"}} | Tee-Object -Variable result | Out-File -FilePath "./report.txt" -Append -Width ([int]::MaxValue) ; $result
		} else {
			Write-Output "No entries found matching criteria"
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
