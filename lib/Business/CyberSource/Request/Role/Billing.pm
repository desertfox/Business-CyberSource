package Business::CyberSource::Request::Role::Billing;
use 5.008;
use strict;
use warnings;
use Carp;
BEGIN {
	our $VERSION = 'v0.1.0'; # VERSION
}
use Moose::Role;
use MooseX::Types::Email qw( EmailAddress );

has first_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has last_name => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has street => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has city => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has state => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has country => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has zip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

has email => (
	required => 1,
	is       => 'ro',
	isa      => EmailAddress,
);

has ip => (
	required => 1,
	is       => 'ro',
	isa      => 'Str',
);

sub _build_bill_to_info {
	my ( $self, $sb ) = @_;

	my $bill_to = $sb->add_elem(
		name => 'billTo',
	);

	$sb->add_elem(
		name   => 'firstName',
		value  => $self->first_name,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'lastName',
		value  => $self->last_name,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'street1',
		value  => $self->street,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'city',
		value  => $self->city,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'state',
		parent => $bill_to,
		value  => $self->state,
	);

	$sb->add_elem(
		name   => 'postalCode',
		parent => $bill_to,
		value  => $self->zip,
	);

	$sb->add_elem(
		name   => 'country',
		parent => $bill_to,
		value  => $self->country,
	);

	$sb->add_elem(
		name   => 'email',
		value  => $self->email,
		parent => $bill_to,
	);

	$sb->add_elem(
		name   => 'ipAddress',
		value  => '192.168.100.2',
		parent => $bill_to,
	);

	return $sb;
}

1;

# ABSTRACT: Role for requests that require "bill to" information

__END__
=pod

=head1 NAME

Business::CyberSource::Request::Role::Billing - Role for requests that require "bill to" information

=head1 VERSION

version v0.1.0

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

