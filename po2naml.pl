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

open(POFILE, "<$infile") or die "Could not open $infile for reading! ($!)\n";
open(NAMLFILE, ">$outfile") or die "Could not open $outfile for writing! ($!)\n";

my $from = "";
my $InMsgId = 0;
my $to = "";
my $InMsgStr = 0;
while( <POFILE>) {
    chomp( $_);

    #create NAML format again: <translation><from>Source</from><to>Translation</to></translation>
    if( m'^$' ) {
        # new entity
        if( "" ne $from) {
            $to =~ s/<t\./<n\./g;   # replace <t.var/> with <n.var/> in $to string
            my $translation = "<translation><from>".$from."</from><to>".$to."</to></translation>";
            $translation =~ s/\\\"/\"/g;
            print NAMLFILE $translation.$eol;
        }
        
        $from = "";
        $InMsgId = 0;
        $to = "";
        $InMsgStr = 0;
    }
    elsif( m'^#\.'i or m'^#:'i ) {
        # ignore it
    }
    elsif( m'^\"(.*)\"'i ) {
        # concatenate multi line entities
        if( $InMsgId) {
            $from .= $1;
        }
        elsif( $InMsgStr) {
            $to .= $1;
        }
    }
    elsif( m'^msgid \"\"'i ) {
        # multi line from string
        $from = "";
        $InMsgId = 1;
        $InMsgStr = 0;
    }
    elsif( m'^msgstr \"\"'i ) {
        # multi line to string
        $to = "";
        $InMsgId = 0;
        $InMsgStr = 1;
    }
    elsif( m'^msgid \"(.*)\"'i ) {
        # single line from string
        $from = $1;
    }
    elsif( m'^msgstr \"(.*)\"'i ) {
        # single line to string
        $to = $1;
    }
    elsif( m'^# Newline'i ) {
        print NAMLFILE $eol;
    }
    elsif( m'^# Comment:(.*)$'i ) {
        print NAMLFILE '#'.$1.$eol;
    }
    elsif( m'^# Comment-Tag:(.*)$'i ) {
        print NAMLFILE $1.$eol;
    }
}
close(POFILE);
close(NAMLFILE);

exit 0;

sub help()
{
    print "\n$0, recreate the nabble.com NAML file from translated gettext PO file\n\n";
    print "Usage: $0 [options] -i POFILE -o NAMLFILE\n";
    print "    options: -h    this help message\n";
    print "             -i    path/name of the PO file (input)\n";
    print "             -o    path/name of the NAML file (output)\n\n";
    exit -1;
}

