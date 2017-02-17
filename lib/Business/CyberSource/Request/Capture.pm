package Business::CyberSource::Request::Capture;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;
extends 'Business::CyberSource::Request';
with qw(
  Business::CyberSource::Request::Role::DCC
  Business::CyberSource::Request::Role::TaxService
);

use MooseX::Types::CyberSource qw( CaptureService  InvoiceHeader );

has '+service' => (
    isa         => CaptureService,
    remote_name => 'ccCaptureService',
    lazy_build  => 0,
);

has 'invoice_header' => (
    isa         => InvoiceHeader,
    remote_name => 'invoiceHeader',
    is          => 'ro',
    required    => 0,
    coerce      => 1
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: CyberSource Capture Request Object

=head1 SYNOPSIS

	use Business::CyberSource::Request::Capture;

	my $capture = Business::CyberSource::Request::Capture->new({
		reference_code => 'merchant reference code',
		service => {
			request_id => 'authorization response request_id',
		},
		purchase_totals => {
			total    => 5.01,  # same amount as in authorization
			currency => 'USD', # same currency as in authorization
		},
        invoice_header => {
            purchaser_vat_registration_number => 'ATU99999999',
            user_po => '123456',
            vat_invoice_reference_number => '1234',
        },
	});

=head1 DESCRIPTION

This object allows you to create a request for a capture.

=head1 EXTENDS

L<Business::CyberSource::Request>

=head1 WITH

=over

=item L<Business::CyberSource::Request::Role::DCC>

=back

=cut
