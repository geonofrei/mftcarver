	
	#GET INPUT PARAMETER VALUE

		param(
			[Parameter(Mandatory=$true)]
			[string]$inputFile,
			[switch]$s,
            [string]$d
			 )
		 
	#------------------------------------------------------------

	#SET MODULE VARIABLES

	$modulename = "08browseractivity"
	$regex = "\\Users\\.*\\(AppData\\Local\\Google\\Chrome\\User Data\\.*\\(History|Cookies)|AppData\\Local\\Microsoft\\Edge\\User Data\\.*\\(History|Cookies)|AppData\\Local\\Mozilla\\Firefox\\Profiles\\.*\\(places|cookies|cache2)\\)|\\Users\\.*\\(AppData\\Roaming\\Opera Software\\Opera Stable\\.*(History|Cookies)|AppData\\Roaming\\Microsoft\\Windows\\Cookies|AppData\\Local\\Microsoft\\Windows\\INetCache)\\.*"
		 
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
		Write-Output "BROWSERACTIVITY MODULE RESULTS" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
		
		if ($results.Count -gt 0) {
		$results | Select-Object *,@{Label="CleanedUsername"; Expression={($_.FullPath -replace ".*(\?\\Users\\|\\Users\\)([^\\]*)\\.*",'$2') -replace '^\?'} } | Sort-Object -Property CleanedUsername,"fnModTime (UTC)" | Format-Table -Wrap -AutoSize -Property @{Label="MFT Entry"; Expression={$_.RecNo}}, @{Label="Deleted?"; Expression={$_.Deleted}}, @{Label="Username"; Expression={($_.FullPath -replace ".*(\?\\Users\\|\\Users\\)([^\\]*)\\.*",'$2')}}, @{Label="Browser"; Expression={if($_.FullPath -match ".*Chrome.*"){"Chrome"}elseif($_.FullPath -match ".*Edge.*"){"Edge"}elseif($_.FullPath -match ".*Firefox.*"){"Firefox"}elseif($_.FullPath -match ".*Opera.*"){"Opera"}elseif($_.FullPath -match ".*\\Microsoft\\Windows.*"){"IExplorer"}else{"Unknown"}}}, @{Label="File Location"; Expression={($_.FullPath -replace '.*Users\\.*\\(Local|Roaming)\\','')}}, @{Label="fnCreateTime"; Expression={$_."fnCreateTime (UTC)"}}, @{Label="fnModTime"; Expression={$_."fnModTime (UTC)"}} | Tee-Object -Variable result | Out-File -FilePath "$d/report.txt" -Append -Width ([int]::MaxValue) ; $result
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
