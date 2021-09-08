use utf8;
package OpenNewsWire::DB::Result::TopicChannelMessage;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpenNewsWire::DB::Result::TopicChannelMessage

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

=head1 TABLE: C<topic_channel_message>

=cut

__PACKAGE__->table("topic_channel_message");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'topic_channel_message_id_seq'

=head2 author_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 channel_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 message_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 is_archived

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 is_stickied

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 created_at

  data_type: 'timestamp with time zone'
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "topic_channel_message_id_seq",
  },
  "author_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "channel_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "message_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "is_archived",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "is_stickied",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "created_at",
  {
    data_type     => "timestamp with time zone",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 author

Type: belongs_to

Related object: L<OpenNewsWire::DB::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "author",
  "OpenNewsWire::DB::Result::Person",
  { id => "author_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 channel

Type: belongs_to

Related object: L<OpenNewsWire::DB::Result::TopicChannel>

=cut

__PACKAGE__->belongs_to(
  "channel",
  "OpenNewsWire::DB::Result::TopicChannel",
  { id => "channel_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

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


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-09-08 14:30:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LOfgoF+cx3j2th9wQVSvPQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
