use utf8;
package OpenNewsWire::DB::Result::Message;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

OpenNewsWire::DB::Result::Message

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

=head1 TABLE: C<message>

=cut

__PACKAGE__->table("message");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'message_id_seq'

=head2 author_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 parent_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 title

  data_type: 'text'
  is_nullable: 1

=head2 content

  data_type: 'text'
  is_nullable: 0

=head2 url

  data_type: 'text'
  is_nullable: 1

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
    sequence          => "message_id_seq",
  },
  "author_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "parent_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "title",
  { data_type => "text", is_nullable => 1 },
  "content",
  { data_type => "text", is_nullable => 0 },
  "url",
  { data_type => "text", is_nullable => 1 },
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

=head2 messages

Type: has_many

Related object: L<OpenNewsWire::DB::Result::Message>

=cut

__PACKAGE__->has_many(
  "messages",
  "OpenNewsWire::DB::Result::Message",
  { "foreign.parent_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 messages_read

Type: has_many

Related object: L<OpenNewsWire::DB::Result::MessageRead>

=cut

__PACKAGE__->has_many(
  "messages_read",
  "OpenNewsWire::DB::Result::MessageRead",
  { "foreign.message_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent

Type: belongs_to

Related object: L<OpenNewsWire::DB::Result::Message>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "OpenNewsWire::DB::Result::Message",
  { id => "parent_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 topic_channel_messages

Type: has_many

Related object: L<OpenNewsWire::DB::Result::TopicChannelMessage>

=cut

__PACKAGE__->has_many(
  "topic_channel_messages",
  "OpenNewsWire::DB::Result::TopicChannelMessage",
  { "foreign.message_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2021-09-08 14:30:18
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UqCL3m0DEMgcjDA73SZk2w




# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
