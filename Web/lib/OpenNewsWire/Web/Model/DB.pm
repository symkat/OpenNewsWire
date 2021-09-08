package OpenNewsWire::Web::Model::DB;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'OpenNewsWire::DB',
    connect_info => [ 'HNW_DB' ],
);

__PACKAGE__->meta->make_immutable;
