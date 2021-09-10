package OpenNewsWire::Web::Controller::Create;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub base :Chained('/base') PathPart('create') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    # Is there a valid user logged in?  - If not, send them to the login page.
    if ( ! $c->stash->{user} ) {
        $c->res->redirect( $c->uri_for_action('/get_login') );
        $c->detach;
    }
}

sub show_create_topic :Chained('base') PathPart('topic') Args(0) Method('GET') {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'create/topic.tx';
}

sub create_topic :Chained('base') PathPart('topic') Args(0) Method('POST') {
    my ( $self, $c ) = @_;

    my $name = $c->req->params->{topic_name};

    # TODO: Validate name
    #   * Make sure it follows the rules (what are the rules?)
    #   * Doesn't already exist)

    $c->stash->{user}->create_related( 'topic_channels', {
        name => $name,
    });

    $c->res->redirect( $c->uri_for_action( '/topicchannel/get_topic', [], $name ) );
}

sub show_create_message :Chained('base') PathPart('message') Args(0) Method('GET') {
    my ( $self, $c ) = @_;

    if ( $c->req->params->{topic} ) {
        $c->stash->{form_to} = 't/' . $c->req->params->{topic};
    }
    $c->stash->{template} = 'create/message.tx';
}

sub create_message :Chained('base') PathPart('message') Args(0) Method('POST') {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'create/message.tx';

    my $target    = $c->req->params->{to};
    my $title     = $c->req->params->{title};
    my $url       = $c->req->params->{url};
    my $content   = $c->req->params->{message};
    my $parent    = $c->req->params->{reply_to};
    my $msg_id    = $c->req->params->{message_id};
    my $msg_slug  = $c->req->params->{message_slug};
    my $chan_name = $c->req->params->{channel_name};
    my $self_post = 0;

    $c->stash(
        form_to      => $target,
        form_title   => $title,
        form_message => $content,
    );

    $c->model('DB')->schema->txn_do( sub {
        my $message = $c->stash->{user}->create_related( 'messages', {
            ( $url     ? ( url       => $url     ) : ( ) ),
            ( $title   ? ( title     => $title   ) : ( ) ),
            ( $content ? ( content   => $content ) : ( ) ),
            ( $parent  ? ( parent_id => $parent  ) : ( ) ),
        });

        my ( $mode, $name ) = split( /\//, $target, 2 );

        if ( $mode eq 't' ) {
            my $channel_id = $c->model('DB')->resultset('TopicChannel')->search({ name => $name })->first->id;
            $c->model('DB')->resultset('TopicChannelMessage')->create({
                author_id  => $c->stash->{user}->id,
                message_id => $message->id,
                channel_id => $channel_id,
            });
            # Set the variables so that the user is redirected to the new message post..
            ( $msg_id, $msg_slug, $chan_name ) = ( $message->id, $message->slug, $name );
        } elsif ( $mode eq 'u' ) {
            # Self-Post
            if ( $name eq $c->stash->{user}->name ) {
                $c->model('DB')->resultset('UserChannelMessage')->create({
                    author_id  => $c->stash->{user}->id,
                    message_id => $message->id,
                });
                # Set the variables so that the user is redirected to the new message post..
                ( $msg_id, $msg_slug, $self_post ) = ( $message->id, $message->slug, 1 );
            }
        }
    });

    if ( $self_post ) {
        $c->res->redirect( $c->uri_for_action( '/userchannel/get_user_message', [], $c->stash->{user}->name, $msg_id, $msg_slug ) );
    }

    if ( $msg_id && $msg_slug && $chan_name ) {
        $c->res->redirect( $c->uri_for_action( '/topicchannel/get_topic_message', [], $chan_name, $msg_id, $msg_slug ) );
    }
}

__PACKAGE__->meta->make_immutable;
