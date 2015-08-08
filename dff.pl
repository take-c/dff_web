#!/usr/bin/env perl                                                             
use strict;
use warnings;
use LWP::Simple;
use Digest::MD5 'md5_hex';

my $script_dir = "/Users/xxxx/work/perl/dff";

my $url = 'http://www.yahoo.com/';

my $html = get($url) or die "Couldn't get it!";
my $md5_sum = md5_hex($html);

my $file = $script_dir."/md5_html.txt";
open (my $fh, $file) or die "$!";
my $result_mail = "";
while (my $line = <$fh>) {
    chomp $line;
    $result_mail = sendtomail() if $line ne $md5_sum;
}
close ($fh);

open(my $wfh, ">", $script_dir."/md5_html.txt") or die("error :$!");
print $wfh $md5_sum;

open(my $lfh, ">>", $script_dir."/notice_en.log") or die("error :$!");
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my $now = sprintf("%02d/%02d %02d:%02d:%02d", $mon+1, $mday, $hour, $min, $sec);
print $lfh $now."|".$md5_sum."\n".$result_mail;

sub sendtomail {
    system("/usr/sbin/sendmail -t < ".$script_dir."/mail.txt");
    return "Sent mail.\n";
}
