#!/usr/bin/perl
#!/usr/bin/perl
use warnings;
use strict;
use Cache::FastMmap::Tie;
$|++;
=item defer
A simple script to use with postfix to act like a lookup table.
Depending on the query address and number of tries, it will  repond REJECT,DEFER or DUNNO.
Cache file will be created at /var/tmp/defer.cache with a max file size of 10MB and will expire entries in 24 hours.
=cut
tie my %cache, 'Cache::FastMmap::Tie', (
                share_file => "/var/tmp/defer.cache",
                cache_size => "10m",
                expire_time=> "24h",
                unlink_on_exit => 0,
        );
use constant MAX_DEFERS => 3;
my $email = '';
while (<>) {
        chomp;
        if (/^get\s(.+)$/i) {
                $email = $1;
                if ($email =~ /^deferred\b/i ) {
                        print ((++$cache{$email} > MAX_DEFERS) ? "500 DUNNO\n" :  sprintf ("200 DEFER address %s, please wait ( warn %s )\n", $email,$cache{$email}));
                } elsif ($email =~ /^bounce\b/i ) {
                        print ((++$cache{$email} > MAX_DEFERS) ? "200 REJECT\n" :  sprintf ("200 DEFER address %s, please wait ( warn %s )\n", $email,$cache{$email}));
                } elsif ($email =~ /^reject\b/i ) {
                        print "200 REJECT  5.1.1 User not known\n";
			delete $cache{$email}; # Can send emails again
                } else {
                        print "500 DUNNO\n"
                }
        } else {
                print "500 DUNNO\n"
        }
}
