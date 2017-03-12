#!/usr/bin/perl

use warnings;
use strict;
use Cache::FastMmap::Tie;

$|++;
 
=item defer
 
A simple script to use with postfix to act like a lookup table.

It will respond DEFER to any given address 3 times before respond DUNNO
 
=cut

tie my %cache, 'Cache::FastMmap::Tie', (
                share_file => "/var/tmp/defer.cache",
                cache_size => "10m",
                expire_time=> "24h",
        );
use constant MAX_DEFERS => 3;

while (<>) {
	chomp;
	if ((/^get\s(.+)$/i)  && ($cache{$1}++ < MAX_DEFERS)) {
		print 'DEFER', $1,' , please wait ( warn',$cache{$1},"\n";
	} else {
		print "DUNNO\n"
	}
}

