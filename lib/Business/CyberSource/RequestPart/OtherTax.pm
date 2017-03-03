package Business::CyberSource::RequestPart::OtherTax;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with 'MooseX::RemoteHelper::CompositeSerialization';

use MooseX::Types::Moose qw( Num );

has 'alternate_tax_amount' => (
    isa         => Num,
    is          => 'ro',
    remote_name => 'alternateTaxAmount',
);

has 'alternate_tax_indicator' => (
    isa         => 'Bool',
    is          => 'ro',
    remote_name => 'alternateTaxIndicator',
);

has 'vat_tax_amount' => (
    isa         => Num,
    is          => 'ro',
    remote_name => 'vatTaxAmount',
);

has 'vat_tax_rate' => (
    isa         => Num,
    is          => 'ro',
    remote_name => 'vatTaxRate',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: OtherTax information

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=attr alternate_tax_amount

Amount of all taxes, excluding the local tax and national tax 

=attr alternate_tax_indicator 

Flag that indicates whether the alternate tax amount is included in the request. 

=attr vat_tax_amount

Total amount of VAT or other tax on freight or shipping only

=attr vat_tax_rate

Total amount of VAT or other tax on freight or shipping only

=for Pod::Coverage BUILD

=cut;
