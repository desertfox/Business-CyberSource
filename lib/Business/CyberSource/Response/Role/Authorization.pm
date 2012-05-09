package Business::CyberSource::Response::Role::Authorization;
use 5.008;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose::Role;
with qw(
	Business::CyberSource::Response::Role::ProcessorResponse
	Business::CyberSource::Response::Role::AVS
	Business::CyberSource::Response::Role::CVN
);

use MooseX::Types::Moose   qw( Str     );
use MooseX::Types::CyberSource qw( _VarcharSeven );

has auth_code => (
	required  => 0,
	predicate => 'has_auth_code',
	is        => 'ro',
	isa       => _VarcharSeven,
);

has auth_record => (
	required  => 0,
	predicate => 'has_auth_record',
	is        => 'ro',
	isa       => Str,
);

1;

# ABSTRACT: CyberSource Authorization Response only attributes

=head1 DESCRIPTION

If the transaction did Authorization then this role is applied

=head2 composes

=over

=item L<Business::CyberSource::Response::Role::ProcessorResponse>

=item L<Business::CyberSource::Response::Role::AVS>

=item L<Business::CyberSource::Response::Role::CVN>

=back

=attr auth_code

=attr auth_record

=cut
