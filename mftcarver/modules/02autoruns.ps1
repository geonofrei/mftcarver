	
	#GET INPUT PARAMETER VALUE

		param(
			[Parameter(Mandatory=$true)]
			[string]$inputFile,
			[switch]$s,
            [string]$d
			 )
		 
	#------------------------------------------------------------

	#SET MODULE VARIABLES

	$modulename = "02autoruns"
	$regex = "\\Start Menu\\Programs\\Startup\\.*\.(exe|bat|cmd|sh|dll|vbs|ps1|psm1|jar|py|rb|pl|msi|scr|hta|com|pif|reg|js|jse|lnk|vb|vbe|wsh|wsf|hta|sys|ade|adp|bas|chm|cpl|crt|csh|fxp|hlp|inf|ins|isp|js|jse|lnk|mdb|mde|mdt|mdw|mda|mdz|mht|mhtml|msc|msi|msp|mst|nws|ocx|pcd|pif|prf|prg|pst|reg|scf|scr|sct|shb|shs|tmp|url|vb|vbe|vbs|ws|wsc|wsf|wsh|xhtm|xhtml|xl|xls|xlt|xlm|xml|xq|xquery|xqy|xsl|xslt)"
		 
	#------------------------------------------------------------

	#USE REGEX VERSUS RAW MFT CSV & EXPORT TO TEMPORAL TSV

		 $raw_content = Get-Content -First 1 $inputfile | Out-File $d/$modulename.tsv; Select-String -Pattern $regex $inputfile | ForEach-Object {$_.Line} | Out-File $d/$modulename.tsv -Append

	#------------------------------------------------------------

	#SET SOURCE CSV

		$importdata = Import-Csv -Delimiter "`t" -Path $d/$modulename.tsv 

	#-------------------------------------------------------------

	#SET OUTPUT COLUMNS

		$results = @( $importData | Select-Object RecNo, Deleted, FullPath, "fnModTime (UTC)", "fnCreateTime (UTC)" | ForEach-Object {
			$_
		})


	#------------------------------------------------------------

	#STDOUT OUTPUT
		
		Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "AUTORUNS MODULE RESULTS" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
		
		if ($results.Count -gt 0) {
		$results | Sort-Object -Property "fnModTime (UTC)" | Format-Table -Wrap -AutoSize -Property @{Label="MFT Entry"; Expression={$_.RecNo}}, @{Label="Deleted?"; Expression={$_.Deleted}}, @{Label="File Location"; Expression={($_.FullPath)}}, @{Label="fnModTime"; Expression={$_."fnModTime (UTC)"}}, @{Label="fnCreateTime"; Expression={$_."fnCreateTime (UTC)"}} | Tee-Object -Variable result | Out-File -FilePath "$d/report.txt" -Append -Width ([int]::MaxValue) ; $result
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
