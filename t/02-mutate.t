use Test::More;
use Test::Deep;

plan qw/no_plan/;

use MooseX::Mutate

MooseX::Mutate->make_immutable(<<_END_);
t::Test::Alpha
t::Test::Bravo
t::Test::Charlie
_END_

ok($_->meta->is_immutable) for qw/t::Test::Alpha t::Test::Bravo t::Test::Bravo::Moose t::Test::Charlie/;

MooseX::Mutate->make_mutable(<<_END_);
t::Test::*
_END_

ok(! $_->meta->is_immutable) for qw/t::Test::Alpha t::Test::Bravo t::Test::Bravo::Moose t::Test::Charlie/;
