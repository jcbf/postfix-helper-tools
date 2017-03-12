use Test::More tests => 3;
use Test::Script;
   
use_ok('Cache::FastMmap::Tie');
script_compiles('./defer.pl');
script_runs(['./defer.pl']);
