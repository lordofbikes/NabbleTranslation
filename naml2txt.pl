#!/usr/bin/perl
#
# this script is released under the Fair License (see LICENSE)
#
# copyright, 2014, Armin Stebich (github@lordofbikes.de)

use Getopt::Std;

my $eol = "\n";

getopts('hi:o:');
my $help = defined($opt_h) ? 1 : 0;
my $infile = defined($opt_i) ? $opt_i : "";
my $outfile = defined($opt_o) ? $opt_o : "";

help() if( $help or "" eq $infile or "" eq $outfile);

open(TXTFILE, ">$outfile") or die "Could not open $outfile for writing! ($!)\n";
open(NAMLFILE, "<$infile") or die "Could not open $infile for reading! ($!)\n";

while( <NAMLFILE>) {
    chomp( $_);

    # find all lines of this kind:
    # <translation><from>Source</from><to>Translation</to></translation>
    # or commnet lines, starting with #
    if(  m'\s*<translation>\s*<from>.*</from>\s*<to>(.*)</to>\s*</translation>\s*'i
      or m'(#.*)'i) {
        print TXTFILE $1.$eol;
    }
    # add comment tags to txt file
    elsif (m'(\s*<!--.*-->)'i) {
        print TXTFILE '# '.$1.$eol;
    }
    # add newlines to txt file
    elsif (m'^\s*$'i) {
        print TXTFILE $eol;
    }
}

close(NAMLFILE);
close(TXTFILE);

exit 0;

sub help()
{
    print "\n$0, create a text file from nabble.com NAML file to check spellings\n\n";
    print "Usage: $0 [options] -i NAMLFILE -o TXTFILE\n";
    print "    options: -h    this help message\n";
    print "             -i    path/name of the NAML file (input)\n";
    print "             -o    path/name of the TXT file (output)\n\n";
    exit -1;
}

