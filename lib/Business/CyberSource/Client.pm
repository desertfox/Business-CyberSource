package Business::CyberSource::Client;
use 5.010;
use strict;
use warnings;
use namespace::autoclean;

# VERSION

use Moose;

use Moose::Util::TypeConstraints;

use MooseX::StrictConstructor;

use MooseX::Types::Moose   qw( HashRef Str );
use MooseX::Types::Path::Class qw( File Dir );
use MooseX::Types::Common::String qw( NonEmptyStr NonEmptySimpleStr );

use File::ShareDir qw( dist_file );
use Config;
use Module::Runtime qw( use_module );
use Module::Load    qw( load );

use XML::Compile::SOAP::WSS 0.12;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Transport::SOAPHTTP;

sub run_transaction {
	my ( $self, $dto ) = @_;

	confess 'Not a Business::CyberSource::Request'
		unless defined $dto
			&& blessed $dto
			&& $dto->isa('Business::CyberSource::Request')
			;

	if ( $dto->is_skipable && ! $self->ignore_skipable ) {
		return $self->_response_factory->create( $dto );
	}

	my $wss = XML::Compile::SOAP::WSS->new( version => '1.1' );

	my $wsdl = XML::Compile::WSDL11->new( $self->cybs_wsdl->stringify );
	$wsdl->importDefinitions( $self->cybs_xsd->stringify );

	my $call = $wsdl->compileClient('runTransaction');

	my $security = $wss->wsseBasicAuth( $self->_username, $self->_password );

	my %request = (
		wsse_Security         => $security,
		merchantID            => $self->_username,
		clientEnvironment     => $self->env,
		clientLibrary         => $self->name,
		clientLibraryVersion  => $self->version,
		merchantReferenceCode => $dto->reference_code,
		%{ $dto->serialize },
	);

	if ( $self->_debug ) {
		load 'Carp';
		load $self->_dumper_package, 'Dumper';

		Carp::carp( 'REQUEST HASH: ' . Dumper( \%request ) );
	}

	my ( $answer, $trace ) = $call->( %request );

	if ( $self->_debug ) {
		Carp::carp "\n> " . $trace->request->as_string;
		Carp::carp "\n< " . $trace->response->as_string;
	}

	$dto->_trace( $trace );

	if ( $answer->{Fault} ) {
		confess 'SOAP Fault: ' . $answer->{Fault}->{faultstring};
	}

	return $self->_response_factory->create( $dto, $answer );
}

sub _build_cybs_wsdl {
	my $self = shift;

	my $dir = $self->_production ? 'production' : 'test';

	return use_module('Path::Class::File')->new(
			dist_file(
				'Business-CyberSource',
				$dir
				. '/'
				. 'CyberSourceTransaction_'
				. $self->cybs_api_version
				. '.wsdl'
			)
		);
}

sub _build_cybs_xsd {
	my $self = shift;

	my $dir = $self->_production ? 'production' : 'test';

	return use_module('Path::Class::File')->new(
			dist_file(
				'Business-CyberSource',
				$dir
				. '/'
				. 'CyberSourceTransaction_'
				. $self->cybs_api_version
				. '.xsd'
			)
		);
}

has _response_factory => (
	isa      => 'Business::CyberSource::Factory::Response',
	is       => 'ro',
	lazy     => 1,
	writer   => undef,
	init_arg => undef,
	default  => sub {
		return use_module('Business::CyberSource::Factory::Response')->new;
	},
);

has ignore_skipable => (
	isa     => 'Bool',
	is      => 'rw',
	lazy    => 1,
	default => sub { return 0 },
);

has debug => (
	isa     => 'Bool',
	reader  => '_debug',
	is      => 'ro',
	lazy    => 1,
	default => sub {
		return $ENV{PERL_BUSINESS_CYBERSOURCE_DEBUG} ? 1 : 0;
	},
);

has dumper_package => (
	isa     => NonEmptySimpleStr,
	reader  => '_dumper_package',
	is      => 'ro',
	lazy    => 1,
	default => sub { return 'Data::Dumper'; },
);

has production => (
	isa      => 'Bool',
	reader   => '_production',
	is       => 'ro',
	required => 1,
);

has username => (
	isa      => subtype( NonEmptySimpleStr, where { length $_ <= 30 }),
	reader   => '_username',
	is       => 'ro',
	required => 1,
);

has password => (
	isa      => NonEmptyStr,
	reader   => '_password',
	is       => 'ro',
	required => 1,
);

has version => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		my $version
			= $Business::CyberSource::VERSION ? $Business::CyberSource::VERSION
			                                  : '0'
			;
		return $version;
	},
);

has name => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub { return 'Business::CyberSource' },
);

has env => (
	required => 0,
	lazy     => 1,
	init_arg => undef,
	is       => 'ro',
	isa      => Str,
	default  => sub {
		return "Perl $Config{version} $Config{osname} $Config{osvers} $Config{archname}";
	},
);

has cybs_api_version => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => Str,
	default  => '1.71',
);

has cybs_wsdl => (
	required  => 0,
	lazy      => 1,
	is        => 'ro',
	isa       => File,
	builder   => '_build_cybs_wsdl',
);

has cybs_xsd => (
	required => 0,
	lazy     => 1,
	is       => 'ro',
	isa      => File,
	builder  => '_build_cybs_xsd',
);


__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: User Agent Responsible for transmitting the Response

=head1 SYNOPSIS

	use Business::CyberSource::Client;

	my $request = 'Some Business::CyberSource::Request Object';

	my $client = Business::CyberSource::Request->new({
		username   => 'Merchant ID',
		password   => 'API KEY',
		production => 0,
	});

	my $response = $client->run_transaction( $request );

=head1 DESCRIPTION

A service object that is meant to provide a way to run the requested
transactions.

=method run_transaction

	my $response = $client->run_transaction( $request );

Takes a L<Business::CyberSource::Request> subclass as a parameter and returns
a L<Business::CyberSource::Response>

=attr username

CyberSource Merchant ID

=attr password

CyberSource API KEY

=attr production

Boolean value when true your requests will go to the production server, when
false they will go to the testing server

=attr debug

Boolean value that causes the HTTP request/response to be output to STDOUT
when a transaction is run. defaults to value of the environment variable
C<PERL_BUSINESS_CYBERSOURCE_DEBUG>

=attr dumper_package

Package name for dumping the request hash if doing a L<debug|/"debug">. Package
must have a C<Dumper> function.

=attr ignore_skipable

requests with expired credit cards are currently "skip-able" and will not be
sent by default, instead you will get a response object that has filled out the
most important parts of a REJECT response and mocked other required fields. If
you want to send these requests always set this in the client.

=attr name

Client Name defaults to L<Business::CyberSource>

=attr version

Client Version defaults to the version of this library

=attr env

defaults to specific parts of perl's config hash

=attr cybs_wsdl

A L<Path::Class::File> to the WSDL definition file

=attr cybs_xsd

A L<Path::Class::File> to the XSD definition file

=attr cybs_api_version

CyberSource API version, currently 1.71

=cut
