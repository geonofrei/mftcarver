  param (
    [string]$mftfile,
    [string]$output="./reports"
)

clear

#CHECKS IF PARSED-MFT TSV FILE IS PROVIDED

if (-not $mftfile) {
	Write-Output ""
    Write-Output "You need to provide MFT file in TSV format as parameter!! (mftdump tool) Usage: .\mftcarver.ps1 .\lamft.tsv .\output"
	Write-Output ""
    exit
}

#--------------------------------------------

#cHECKS IF MFT FILE EXISTS

if (-not (Test-Path $mftfile)) {
	Write-Output ""
    Write-Output "File $mftfile does not exist!!"
	Write-Output ""
    exit
}

#--------------------------------------------	

do {

if (Test-Path $output) {
 
	Remove-Item $output/* -Force

} else {
    mkdir $output
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

$ScriptDirectorio = $PSScriptRoot
$ModulesDirectorio = Join-Path $ScriptDirectorio "modules"

Get-ChildItem -Path $ModulesDirectorio/ -Filter *.ps1 | ForEach-Object { & $_.FullName $mftfile -s $output}
			
function Press-Key {
			Write-Output "Finished! Press any key to exit..."
			$x = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
		}

Press-Key

Write-Output ""

break
    
} while ($true)