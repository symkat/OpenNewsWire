use utf8;
package OpenNewsWire::DB::Result::TopicChannel;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpenNewsWire::DB::Result::TopicChannel

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

=head1 TABLE: C<topic_channel>

=cut

__PACKAGE__->table("topic_channel");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'topic_channel_id_seq'

=head2 owner_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 is_enabled

  data_type: 'boolean'
  default_value: true
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
    sequence          => "topic_channel_id_seq",
  },
  "owner_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "is_enabled",
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

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 owner

Type: belongs_to

Related object: L<OpenNewsWire::DB::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "OpenNewsWire::DB::Result::Person",
  { id => "owner_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 topic_channel_messages

Type: has_many

Related object: L<OpenNewsWire::DB::Result::TopicChannelMessage>

=cut

__PACKAGE__->has_many(
  "topic_channel_messages",
  "OpenNewsWire::DB::Result::TopicChannelMessage",
  { "foreign.channel_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 topic_channel_settings

Type: has_many

Related object: L<OpenNewsWire::DB::Result::TopicChannelSetting>

=cut

__PACKAGE__->has_many(
  "topic_channel_settings",
  "OpenNewsWire::DB::Result::TopicChannelSetting",
  { "foreign.topic_channel_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-09-08 14:30:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RvVaTUvL9AJnqVI5zAYK2Q


1;
