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

sub time_ago {
    my ( $self ) = @_;

    my $delta = time - $self->created_at->epoch;

    return "less than a minute ago"           if $delta < 60;           # 1 Minute
    return "about a minute ago"               if $delta < 120;          # 2 minute
    return int($delta / 60) . " minutes ago"  if $delta < 45 * 60;      # 45 minutes
    return "about an hour ago"                if $delta < 60 * 60 * 2;  # 2 hours
    return int($delta / 3600) . " hours ago"  if $delta < 60 * 60 * 18; # 18 hours
    return "about an day ago"                 if $delta < 60 * 60 * 36; # 36 Hours
    return int($delta / (3600*24)) . " days ago";
}

sub comment_count {
    my ( $self ) = @_;

    return $self->_count_children( $self->id );

}

sub _count_children {
    my ( $self, $id ) = @_;

    my $count = 0;

    my $rs = $self->result_source->schema->resultset('Message')->search( { parent_id => $id } );
    while ( my $result = $rs->next ) {
        $count += 1;
        $count += $self->_count_children( $result->id );
    }

    return $count;
}

sub slug {
    my ( $self ) = @_;

    my $slug = $self->title || 'permlink';
    
    $slug =~ s/[^a-zA-Z0-9`]+/-/g;
    $slug =~ s/-$//;
    $slug =~ s/^-//;

    return $slug;
}

1;
