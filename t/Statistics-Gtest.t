# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Gtest.t'

#########################

use Test::More;
BEGIN { use_ok('Statistics::Gtest') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $s = "90 31 28 11";
my @test_objects = (
	{ 'obj' => $s,                     
	  'exp' => [3, 1, 4, 160, undef, 90, 31, 160, 1, 2, 0, 0.264812933423063,
	  1.00520833333333, 0.266192167451308, 0.133096083725654] }, 
	{ 'obj' => [ [90], [31], [28], [11] ],                     
	  'exp' => [3, 4, 1, 90, 31, 160, undef, 160, 1, 1, 0, 0.264812933423063,
	  1.00520833333333, 0.266192167451308, 0.133096083725654] }, 
	{ 'obj' => [ 90, 31, 28, 11 ],     
	  'exp' => [3, 1, 4, 160, undef, 90, 31, 160, 1, 2, 0, 0.264812933423063,
	  1.00520833333333, 0.266192167451308, 0.133096083725654] },
	{ 'obj' => [ [90, 31], [28, 11] ], 
	  'exp' => [1, 2, 2, 121, 39,   118, 42, 160, 1, 0, 1, 0.0988786097590253,
	  1.01919962010967, 0.100777041503371, 0.0503885207516857] },
	);

plan tests => scalar (@test_objects) * 17;
foreach my $initiator (@test_objects) {
	my $g = new Statistics::Gtest($initiator->{'obj'});
	ok(defined $g, 'Constructor worked');
	ok($g->isa('Statistics::Gtest'), 'Object is correct class');
	is($g->getDF(), $initiator->{'exp'}->[0], 'getDF()');
	is($g->getRowNum(), $initiator->{'exp'}->[1], 'getRowNum()');
	is($g->getColNum(), $initiator->{'exp'}->[2], 'getColNum()');
	is($g->rowSum(0), $initiator->{'exp'}->[3], 'RowSum(0)');
	is($g->rowSum(1), $initiator->{'exp'}->[4], 'RowSum(1)');
	is($g->colSum(0), $initiator->{'exp'}->[5], 'ColSum(0)');
	is($g->colSum(1), $initiator->{'exp'}->[6], 'ColSum(1)');
	is($g->getSumTotal(), $initiator->{'exp'}->[7], 'SumTotal()');
	is($g->{'intrinsic'}, $initiator->{'exp'}->[8], "hypothesis type = 1");
	is($g->{'tabletype'}, $initiator->{'exp'}->[9], "tabletype");

   if ($initiator->{'exp'}->[9] != 0) { 
		$g->setExpected("90 30 30 10");	
	}	
	is($g->{'intrinsic'}, $initiator->{'exp'}->[10], "hypothesis type = 0");
	is($g->getQ(), $initiator->{'exp'}->[12], "Williams Q");
	is($g->getRawG(), $initiator->{'exp'}->[13], "Raw G");
	is($g->getG(), $initiator->{'exp'}->[11], "Corrected G");
	is($g->{'logsum'}, $initiator->{'exp'}->[14], "logsum");
}

