package Business::CyberSource::RequestPart::InvoiceHeader;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::MessagePart';
with 'MooseX::RemoteHelper::CompositeSerialization';

use MooseX::Types::CyberSource qw(
  _VarcharThirteen
  _VarcharFifteen
  _VarcharTwentyFive
);

has 'purchaser_vat_registration_number' => (
    isa         => _VarcharThirteen,
    is          => 'ro',
    remote_name => 'purchaserVATRegistrationNumber',
);

has 'user_po' => (
    isa         => _VarcharTwentyFive,
    is          => 'ro',
    remote_name => 'userPO',
);

has 'vat_invoice_reference_number' => (
    isa         => _VarcharFifteen,
    is          => 'ro',
    remote_name => 'vatInvoiceReferenceNumber',
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: InvoiceHeader information

=head1 EXTENDS

L<Business::CyberSource::MessagePart>

=attr purchaser_vat_registration_number

Identification number assigned to the purchasing company by the tax
authorities .

=attr user_po 

Value used by your customer to identify the order. This value is typically a purchase order number. 

=attr vat_invoice_reference_number 

VAT invoice number associated with the transaction.

=for Pod::Coverage BUILD

=cut;
