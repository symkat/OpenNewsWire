package OpenNewsWire::Web::Controller::TopicChannel;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub base :Chained('/base') PathPart('t') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    # Is there a valid user logged in?  - If not, send them to the login page.
    if ( ! $c->stash->{user} ) {
        $c->res->redirect( $c->uri_for_action('/get_login') );
        $c->detach;
    }
}

sub index :Chained('base') PathPart('') Args(0) Method('GET') {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'topic/index.tx';

    push @{$c->stash->{topics}}, 
        $c->model('DB')->resultset('TopicChannel')->all;
}

sub get_topic :Chained('base') PathPart('') Args(1) Method('GET') {
    my ( $self, $c, $topic_name ) = @_;
    $c->stash->{template} = 'topic/show_topic.tx';
    
    my $topic = $c->model('DB')->resultset('TopicChannel')->search({ name => $topic_name })->first;

    $c->stash->{topic} = $topic; 

    push @{$c->stash->{messages}},
        $c->model('DB')->resultset('TopicChannelMessage')->search({channel_id => $topic->id})->all;
}

sub get_topic_message :Chained('base') PathPart('') Args(3) Method('GET') {
    my ( $self, $c, $topic_name, $message_id, $message_slug ) = @_;
    $c->stash->{template} = 'topic/show_topic_message.tx';
    
    my $channel = $c->model('DB')->resultset('TopicChannel')->search({ name => $topic_name })->first;
    my $message = $c->model('DB')->resultset('Message')->find( $message_id );

    $c->stash->{message}       = $message;
    $c->stash->{channel}       = $channel;
    $c->stash->{topic}         = $channel;
    $c->stash->{comments}      = $self->_get_message_children( $c, $message->id );
    $c->stash->{comment_count} = $self->_count_message_children( $c->stash->{comments} );
}

sub _count_message_children {
    my ( $self, $comments ) = @_;

    my $count = 0;

    foreach my $comment ( @$comments ) {
        $count += 1;
        $count += $self->_count_message_children($comment->{children});
    }

    return $count;
}

sub _get_message_children {
    my ( $self, $c, $parent_id ) = @_;

    my @results;

    my $search_rs = $c->model('DB')->resultset('Message')->search({ parent_id => $parent_id } );
    while (  my $message =  $search_rs->next ) {
        push @results, {
            message => {
                content  => $message->content,
                id       => $message->id,
                created  => $message->created_at->strftime( '%F %T' ),
                time_ago => $message->time_ago,
            },
            author => {
                name  => $message->author->name,
                id    => $message->author->id,
            },
            children  => $self->_get_message_children( $c, $message->id ),
        };
    }

    return [ @results ];
}

__PACKAGE__->meta->make_immutable;
