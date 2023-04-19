# mftcarver

The mftcarver tool allows you to extract valuable information from a $MFT file in TSV format in a matter of seconds, saving you the hundreds of thousands of rows that such a file can have to analyze in a forensic procedure. Its design is modular and its use is simple. Over time it will be extended with new functionalities.

It generates a file called "report.txt" in the path where the tool code is located. In this file the results of the daily operations are broken down. This report will be deleted with each start of the tool, and, in addition, when using the option that runs all modules.

At the same time, a "temp.csv" file will be created, which is used for efficiency reasons, since the searches are made on the RAW of a parsed MFT and stored in this file. I have left it in case you want to consult the results obtained in CSV with all the columns of a MFT, as it is obtained by "mftdump".

**USAGE: _./mftcarver ./parsed_mft_file.tsv**_

This is free software and can be redistributed as such.  
