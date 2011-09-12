package Business::CyberSource::Response::Role::CVN;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

our $VERSION = 'v0.2.8'; # VERSION

use Moose::Role;

use MooseX::Types::Varchar qw( Varchar );

has cv_code => (
	required  => 0,
	predicate => 'has_cv_code',
	is        => 'ro',
	isa       => Varchar[1],
);

has cv_code_raw => (
	required  => 0,
	predicate => 'has_cv_code_raw',
	is        => 'ro',
	isa       => Varchar[10],
);

1;

# ABSTRACT: CVN Role

__END__
=pod

=head1 NAME

Business::CyberSource::Response::Role::CVN - CVN Role

=head1 VERSION

version v0.2.8

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/xenoterracide/Business-CyberSource/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Caleb Cushing <xenoterracide@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by Caleb Cushing.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
