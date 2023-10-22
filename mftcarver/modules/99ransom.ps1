	
	#GET INPUT PARAMETER VALUE

		param(
			[Parameter(Mandatory=$true)]
			[string]$inputFile,
			[switch]$s,
            [string]$d
			 )
		 
	#------------------------------------------------------------

	#SET MODULE VARIABLES

	$modulename = "99ransom"
	$regex = "\\Users\\.*\\(Desktop|Downloads|Documents|Music|Pictures|Videos)\\(ransom|ranson|How_To_Decrypt|How_To_Restore_Files|How_To_Restore_Data|How_To_Get_Back_Your_Files|How_To_Get_Back_Your_Data|How_To_Decrypt_Files|How_To_Recover_Data|How_To_Recover_Files|how_recover|Recover_Files|Recover_Data|How_To_Restore|decrypt|RESTORE|Recover|how_to_decrypt|Decrypt|Instructions|Read_First|Unlock|Your_Files|Your_Data|YourDocuments|HELP|RECOVERY|RETURN|RECOVERED|RECOVER|DECRYPT|RESTORE|RESTORE_FILES|RESTORE_DATA|RESTORE_ALL_DATA|RESTORE_MY_FILES|DECRYPT_MY_FILES|HOW_TO_RESTORE|HOW_TO_RECOVER|HOW_TO_DECRYPT|HOW_TO_RESTORE_FILES|HOW_TO_RESTORE_DATA|HOW_TO_RESTORE_YOUR_FILES|HOW_TO_DECRYPT_FILES|HOW_TO_DECRYPT_YOUR_FILES|HOW_TO_GET_BACK_YOUR_FILES|HOW_TO_GET_BACK_YOUR_DATA|HOW_TO_GET_YOUR_FILES_BACK|HOW_TO_GET_YOUR_DATA_BACK|YOUR_FILES_ARE_ENCRYPTED|YOUR_DATA_ARE_ENCRYPTED|HELP_DECRYPT|RECOVER_FILE|RETURN_FILES)\.(txt|html|url|bmp|gif|png|jpg|jpeg|doc|docx|xls|xlsx|ppt|pptx|pdf|zip|rar|7z|tar|gz|sql|bak|crypt|encrypted|enc|cry|lock|kraken|micro|tron|xrtn|mira|r5a|r5|crypto|crinf|peta|grt|npsk|repl|jdyi|pomik|kvag|bkpx|mkos|dalle|kvag|domn|weui|brrr|rxx|nlah|crypted|mo7n|kratos|bboo|gero|hese|mosk|ooss|hros|lisp|mydoom|wantsum|better_call_saul|barak|davda|gerber|vesad|proden|poret|bip|balbaz|domino|masok|tron|kodg|kjh|hese|mogranos|skymap|notopen|raas|mbed|mogranos|z9|aleta|prandel|weapologize|forcemajeure|cammora|dbger|dip|encrypts|jigsaw|moka|snc|thanos|toska|tfudet|wasted|wholocked|zobm)"
		 
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
		Write-Output "RANSOM MODULE RESULTS" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "==========================================" | Tee-Object -FilePath "$d/report.txt" -Append
		Write-Output "" | Tee-Object -FilePath "$d/report.txt" -Append
		
		if ($results.Count -gt 0) {
		$results | Select-Object *,@{Label="CleanedUsername"; Expression={($_.FullPath -replace "\\Users\\(.*)\\.*\\.*",'$1')} } | Sort-Object -Property CleanedUsername,"fnModTime (UTC)" | Format-Table -Wrap -AutoSize -Property @{Label="MFT Entry"; Expression={$_.RecNo}}, @{Label="Deleted?"; Expression={$_.Deleted}}, @{Label="Username"; Expression={($_.FullPath -replace "\\Users\\(.*)\\.*\\.*",'$1')}}, @{Label="File Location"; Expression={($_.FullPath -replace "\\.*\\(.*)\\(.*)$",'$1\$2')}}, @{Label="fnCreateTime"; Expression={$_."fnCreateTime (UTC)"}}, @{Label="fnModTime"; Expression={$_."fnModTime (UTC)"}} | Tee-Object -Variable result | Out-File -FilePath "$d/report.txt" -Append -Width ([int]::MaxValue) ; $result
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
