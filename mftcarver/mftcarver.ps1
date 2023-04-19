clear

if ($args.Count -lt 1) {
	Write-Output ""
    Write-Output "You need to provide MFT file in TSV format as parameter!! (mftdump tool) Usage: .\mftcarver.ps1 .\lamft.tsv"
	Write-Output ""
    exit
}

$mftfile = $args[0]

if (-not (Test-Path $mftfile)) {
	Write-Output ""
    Write-Output "File $mftfile does not exist!!"
	Write-Output ""
    exit
}

if (Test-Path "./report.txt") {
 
				Remove-Item "./report.txt" -Force
			}	

do {
	
	
clear

Write-Output ""

Write-Output "

@@@@@@@@@@   @@@@@@@@  @@@@@@@   @@@@@@@   @@@@@@   @@@@@@@   @@@  @@@  @@@@@@@@  @@@@@@@   
@@@@@@@@@@@  @@@@@@@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@@  
@@! @@! @@!  @@!         @@!    !@@       @@!  @@@  @@!  @@@  @@!  @@@  @@!       @@!  @@@  
!@! !@! !@!  !@!         !@!    !@!       !@!  @!@  !@!  @!@  !@!  @!@  !@!       !@!  @!@  
@!! !!@ @!@  @!!!:!      @!!    !@!       @!@!@!@!  @!@!!@!   @!@  !@!  @!!!:!    @!@!!@!   
!@!   ! !@!  !!!!!:      !!!    !!!       !!!@!!!!  !!@!@!    !@!  !!!  !!!!!:    !!@!@!    
!!:     !!:  !!:         !!:    :!!       !!:  !!!  !!: :!!   :!:  !!:  !!:       !!: :!!   
:!:     :!:  :!:         :!:    :!:       :!:  !:!  :!:  !:!   ::!!:!   :!:       :!:  !:!  
:::     ::    ::          ::     ::: :::  ::   :::  ::   :::    ::::     :: ::::  ::   :::  
 :      :     :           :      :: :: :   :   : :   :   : :     :      : :: ::    :   : :  

"

Write-Output ""
Write-Output "This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation" | Out-Host
Write-Output ""
Write-Output "Author: George-Emilian Onofrei, 2023"
Write-Output ""

    Write-Output ""
	Write-Output "=========================================="
	Write-Output ""
    Write-Output "1. User Information"
    Write-Output "2. User Files"
	Write-Output "3. User Activity"
	Write-OUtput "4. Execute ALL (silent)"
    Write-Output "5. Exit"
	
	Write-Output ""
	Write-Output "=========================================="
	Write-Output ""
	Write-Output ""
    
    $opcion = Read-Host "Select Option"
    
    switch ($opcion) {
        "1" {
            # Script 1
			clear
            ./modules/1userinfo.ps1 $mftfile
        }
        "2" {
            # Script 2
			clear
            ./modules/userfiles.ps1 $mftfile
		}
		"3" {
            # Script 2
			clear
            ./modules/useractivity.ps1 $mftfile
		}
        "4" {
            # Execute ALL
            clear
			
			if (Test-Path "./report.txt") {
 
				Remove-Item "./report.txt" -Force
			}
			
			Get-ChildItem -Path ./modules/ -Filter *.ps1 | ForEach-Object { & $_.FullName $mftfile -s}
			
        }
		"5" {
            # Exit menu
            clear
			exit
        }
        default {
            # Invalid option
            Write-Output "Invalid Option Selected!!"
        }
    }
} while ($true)
