use Test::More tests => 3;
use Test::Script;
   
my $email = 'jose@example.net';
use_ok('Cache::FastMmap::Tie');
script_compiles('./defer.pl');
script_runs(['./defer.pl'], { stdin => \$email}, "Run Script");
