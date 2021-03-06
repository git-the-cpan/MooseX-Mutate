package MooseX::Mutate;

use warnings;
use strict;

=head1 NAME

MooseX::Mutate - A convenient way to make many Moose immutable (or mutable) in one shot

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    use MooseX::Mutate;

    ...

    MooseX::Mutate->make_immutable(<<_MANIFEST_)
    My::Moose::Hierarchy::Alpha
    My::Moose::Hierarchy::Bravo
    My::Moose::Hierarchy::Charlie

     # Comments (lines leading with a pound) and blank lines are ignored by the finder
    My::Moose::Hierarchy::Delta::*
        # Not strict about leading/trailing whitespace either
     My::Moose::Hierarchy::Epsilon::+
    _MANIFEST_

    # The above code has the following effects:
    #
    # ::Alpha, ::Bravo, and ::Charlie are now immutable (if they exist)
    #
    # Every Moose::Object under the Delta:: namespace is now immutable
    #   (although ::Delta, if a Moose::Object, IS still mutable)
    #
    # Every Moose::Object under the Epsilon:: namespace, including
    #   ::Epsilon is now mutable

    # You can also use MooseX::Mutate to make something mutable again:
    MooseX::Mutate->make_mutable("My::Moose::Hierarchy::Epsilon::+")

=head1 WARNING - Use MooseX::MakeImmutable instead

I'm changing the name to L<MooseX::MakeImmutable>, as I think MooseX::Mutate is a pretty juicy name AND doesn't really describe this
package accurately. This distribution will be removed from CPAN soon.

=head1 DESCRIPTION

MooseX::Mutate is a tool for loading every Moose::Object within a hierarchy and making each immutable/mutable. It uses L<Module::Pluggable> for searching and will load both inner and .pm packages.

In a nutshell, if you add a Moose-based package to your object hierarchy, then MooseX::Mutate, given a proper manifest, will pick it up and mark it im/mutable (without you having to manually write-out the new package).

=head2 Writing a MooseX::Mutate::Finder manifest

A manifest consists of one package per line

For each line, leading and trailing whitespace is stripped

Lines that are blank or begin with a pound (#) are skipped

A package with a trailing ::* IS NOT made im/mutable, but every package under that namespace is

A package with a trailing ::+ or :: IS made im/mutable, along with every package under that namespace

=head1 METHODS

=head2 MooseX::Mutate->make_immutable( <manifest>, ... )

Create a finder from <manifest> and make each found Moose::Object immutable

Any extra passed-in options will be forwarded to ->meta->make_immutable(...) excepting C<include_inner> and C<exclude>, which are used to configure the finder.

=head2 MooseX::Mutate->make_mutable( <manifest>, ... )

Create a finder from <manifest> and make each found Moose::Object mutable

Any extra passed-in options will be forwarded to ->meta->make_mutable(...) excepting C<include_inner> and C<exclude>, which are used to configure the finder.

=head2 MooseX::Mutate->finder( ... )

Create and return a MooseX::Mutate::Finder object

The returned object uses L<Module::Pluggable> to scan the specified namespace(s) for potential Moose objects. It accepts the following options:

    manifest            The finder manifest, described above

    include_inner       If true, then the finder will "find" inner Moose packages. On by default

    exclude             A list where each item is one of:

                        * A package name to be excluded (string)
                        * A regular expression that matches if a package should be excluded 
                        * A CODE block returning true if a package should be excluded (the package name is passed in as the first argument)

=cut

use MooseX::Mutate::Finder;
use Scalar::Util qw/blessed/;
use Carp;

sub finder {
    my $class = shift;
    my $finder = MooseX::Mutate::Finder->new(@_);
    return $finder;
}

sub _given_finder {
    my $class = shift;
    my $given = shift;

    my %finder;
    exists $given->{$_} and $finder{$_} = delete $given->{$_} for qw/include_inner exclude/;
    my $finder = delete $given->{finder};

    # If finder is already blessed... then just ignore manifest => ... and use the given finder
    $finder = $class->finder((ref $finder eq "HASH" ? %$finder : ()), %finder, @_) unless blessed $finder;

    return $finder;
}

carp <<_END_;

**********************************************************************
* MooseX::Mutate is deprecated... use MooseX::MakeImmutable instead! *
**********************************************************************

_END_

sub make_immutable {
    my $class = shift;
    my $manifest = shift;
    my %given = @_;

    carp <<_END_;

**********************************************************************
* MooseX::Mutate is deprecated... use MooseX::MakeImmutable instead! *
**********************************************************************

_END_

    my $finder = $class->_given_finder(\%given, manifest => $manifest);

    $_->meta->make_immutable(%given) for $finder->found;
}

sub make_mutable {
    my $class = shift;
    my $manifest = shift;
    my %given = @_;

    carp <<_END_;

**********************************************************************
* MooseX::Mutate is deprecated... use MooseX::MakeImmutable instead! *
**********************************************************************

_END_

    my $finder = $class->_given_finder(\%given, manifest => $manifest);

    $_->meta->make_mutable(%given) for $finder->found;
}

=head1 SEE ALSO

L<Moose>

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-mutate at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Mutate>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::Mutate


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Mutate>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Mutate>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Mutate>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-Mutate>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of MooseX::Mutate
