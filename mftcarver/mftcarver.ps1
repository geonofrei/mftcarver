clear

#CHECKS IF PARSED-MFT TSV FILE IS PROVIDED

if ($args.Count -lt 1) {
	Write-Output ""
    Write-Output "You need to provide MFT file in TSV format as parameter!! (mftdump tool) Usage: .\mftcarver.ps1 .\lamft.tsv"
	Write-Output ""
    exit
}

#--------------------------------------------

#cHECKS IF MFT FILE EXISTS

$mftfile = $args[0]

if (-not (Test-Path $mftfile)) {
	Write-Output ""
    Write-Output "File $mftfile does not exist!!"
	Write-Output ""
    exit
}

#--------------------------------------------	

do {

if (Test-Path "./reports/*") {
 
	Remove-Item "./reports/*" -Force
}

		
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

Get-ChildItem -Path ./modules/ -Filter *.ps1 | ForEach-Object { & $_.FullName $mftfile -s}
			
function Press-Key {
			Write-Output "Finished! Press any key to exit..."
			$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		}

Press-Key

Write-Output ""

break
    
} while ($true)