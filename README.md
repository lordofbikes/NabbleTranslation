NabbleTranslation
=================

Perl scripts to simplify translation of nabble.com NAML localization files.

This couple of scripts are intended to simplify the translation of [nabble.com](http://www.nabble.com/) localization files.
The [nabble.com localization files](http://support.nabble.com/Nabble-Translations-f6669344.html) are in Nabble's NAML format, a XML like format.

To simplify and speed up translation, use the first script **naml2po.pl**. With this script generate a *PO* file for [gettext](http://en.wikipedia.org/wiki/Gettext) tools.
With the Poedit tool of your choise, enjoy translating all the strings from the *NAML* file.
After finishing translation, use the second script **po2naml.pl** and create a *NAML* file again from the translated *PO* file.

One option to check spellings is the third script **naml2txt.pl**, use it to extract a simple *TXT* file with the translated texts only.


naml2po.pl options
------------------

    Usage: naml2po.pl [options] -i NAMLFILE -o POFILE  
        options: -h    this help message  
                 -i    path/name of the NAML file (input)  
                 -o    path/name of the PO file (output)  
                 -c    add a msgctxt line for source context  
                       (not supported by all poedit tools)  
                 -t    add translation from NAML file to PO file  
                       (text within the <to></to> tag)  


po2naml.pl options
------------------

    Usage: po2naml.pl [options] -i POFILE -o NAMLFILE  
        options: -h    this help message  
                 -i    path/name of the PO file (input)  
                 -o    path/name of the NAML file (output)  


naml2txt.pl options
-------------------

    Usage: naml2txt.pl [options] -i POFILE -o NAMLFILE  
        options: -h    this help message  
                 -i    path/name of the NAML file (input)  
                 -o    path/name of the TXT file (output)  

