#!/usr/bin/perl
#
# this script is released under the Fair License (see LICENSE)
#
# copyright, 2014, Armin Stebich (github@lordofbikes.de)

use Getopt::Std;
use Time::Piece;

my $eol = "\n";

getopts('chi:o:t');
my $context = defined($opt_c) ? 1 : 0;
my $help = defined($opt_h) ? 1 : 0;
my $infile = defined($opt_i) ? $opt_i : "";
my $outfile = defined($opt_o) ? $opt_o : "";
my $printTo = defined($opt_t) ? 1 : 0;

help() if( $help or "" eq $infile or "" eq $outfile);

open(POFILE, ">$outfile") or die "Could not open $outfile for writing! ($!)\n";
open(NAMLFILE, "<$infile") or die "Could not open $infile for reading! ($!)\n";

PoHeader( POFILE);

my $Id = 1;
my $LineCnt = 1;
while( <NAMLFILE>) {
    chomp( $_);

    # escape quotes for po file
    $_ =~ s/\"/\\\"/g;

    # find all lines of this kind:
    # <translation><from>Source</from><to>Translation</to></translation>
    if( m'\s*<translation>\s*<from>(.*)</from>\s*<to>(.*)</to>\s*</translation>\s*'i) {
        $from = $1;
        $to = $2;
    
        print POFILE '#. type: Plain text, ID:'.$Id++.$eol;
        print POFILE '#: Line:'.$LineCnt.$eol;
        print POFILE '#| msgctxt Line'.$LineCnt.$eol if($context);
        print POFILE 'msgid "'.$from.'"'.$eol;
        print POFILE 'msgstr "'.($printTo ? $to : '').'"'.$eol;
        print POFILE $eol;
    }
    # add comments to po file for later naml generation
    elsif (m'#(.*)'i) {
        print POFILE '# Comment:'.$1.$eol;
    }
    # add comment tags to po file for later naml generation
    elsif (m'(\s*<!--.*-->)'i) {
        print POFILE '# Comment-Tag:'.$1.$eol;
    }
    # add newlines to po file for later naml generation
    elsif (m'^\s*$'i) {
        print POFILE '# Newline'.$eol;
    }

    $LineCnt++;
}

close(NAMLFILE);
close(POFILE);

exit 0;

sub help()
{
    print "\n$0, create a gettext PO file from nabble.com NAML file for easy translation\n\n";
    print "Usage: $0 [options] -i NAMLFILE -o POFILE\n";
    print "    options: -h    this help message\n";
    print "             -i    path/name of the NAML file (input)\n";
    print "             -o    path/name of the PO file (output)\n";
    print "             -c    add a msgctxt line for source context\n";
    print "                   (not supported by all poedit tools)\n";
    print "             -t    add translation from NAML file to PO file\n";
    print "                   (text within the <to></to> tag)\n\n";
    exit -1;
}

sub PoHeader()
{
    # create a valid header for po file
    my $pofile = shift;
    my $year = Time::Piece->new->strftime('%Y');
    my $date = Time::Piece->new->strftime('%Y-%m-%d %H:%M%z');
    print $pofile <<"POHEADER";
# naml2po generated translation file for nabble.com
# This file is distributed under the License of your choice.
#
# Translator <translator\@project.tld>, $year.
msgid ""
msgstr ""
"Project-Id-Version: nabble.com NAML translation file\\n"
"Report-Msgid-Bugs-To: translator\@project.tld\\n"
"POT-Creation-Date: $date\\n"
"PO-Revision-Date: \\n"
"Last-Translator: \\n"
"Language-Team: \\n"
"Language: \\n"
"MIME-Version: 1.0\\n"
"Content-Type: text/plain; charset=UTF-8\\n"
"Content-Transfer-Encoding: 8bit\\n"
"Plural-Forms: nplurals=2; plural=(n!=1);\\n"

POHEADER
}

