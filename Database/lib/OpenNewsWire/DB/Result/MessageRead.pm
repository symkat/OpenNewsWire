use utf8;
package OpenNewsWire::DB::Result::MessageRead;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpenNewsWire::DB::Result::MessageRead

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::InflateColumn::Serializer>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "InflateColumn::Serializer");

=head1 TABLE: C<message_read>

=cut

__PACKAGE__->table("message_read");

=head1 ACCESSORS

=head2 message_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 person_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 is_read

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "message_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "person_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "is_read",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "created_at",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</message_id>

=item * L</person_id>

=back

=cut

__PACKAGE__->set_primary_key("message_id", "person_id");

=head1 RELATIONS

=head2 message

Type: belongs_to

Related object: L<OpenNewsWire::DB::Result::Message>

=cut

__PACKAGE__->belongs_to(
  "message",
  "OpenNewsWire::DB::Result::Message",
  { id => "message_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 person

Type: belongs_to

Related object: L<OpenNewsWire::DB::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "person",
  "OpenNewsWire::DB::Result::Person",
  { id => "person_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-09-06 15:34:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gg35TWsshmej8z36q7TnFw




# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
