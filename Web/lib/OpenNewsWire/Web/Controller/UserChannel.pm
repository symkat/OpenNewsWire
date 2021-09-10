package OpenNewsWire::Web::Controller::UserChannel;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub base :Chained('/base') PathPart('u') CaptureArgs(1) {
    my ( $self, $c, $profile_name ) = @_;
    
    # Is there a valid user logged in?  - If not, send them to the login page.
    if ( ! $c->stash->{user} ) {
        $c->res->redirect( $c->uri_for_action('/get_login') );
        $c->detach;
    }
    
    my $user = $c->model('DB')->resultset('Person')->search({ name => $profile_name })->first;

    $c->stash->{user_profile} = $user; 
    # TODO: Throw an error when there is no user.
}

sub get_user :Chained('base') PathPart('') Args(0) Method('GET') {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'user/show_user.tx';

    push @{$c->stash->{messages}},
        $c->model('DB')->resultset('UserChannelMessage')->search({author_id => $c->stash->{user_profile}->id})->all;
}

sub get_user_submissions :Chained('base') PathPart('submissions') Args(0) Method('GET') {
    my ( $self, $c, ) = @_;
    $c->stash->{template} = 'user/show_user_submissions.tx';
    
    push @{$c->stash->{messages}},
        $c->model('DB')->resultset('TopicChannelMessage')->search({author_id => $c->stash->{user_profile}->id})->all;
}

sub get_user_comments :Chained('base') PathPart('comments) Args(0) Method('GET') {
    my ( $self, $c, ) = @_;
    $c->stash->{template} = 'user/show_user_comments.tx';
    
    push @{$c->stash->{messages}},
        $c->model('DB')->resultset('Message')->search({
            author_id => $c->stash->{user_profile}->id,
            parent_id => { '!=' => [ 0, undef ] },
        })->all;
}

sub get_user_message :Chained('base') PathPart('') Args(2) Method('GET') {
    my ( $self, $c, $message_id, $message_slug ) = @_;
    $c->stash->{template} = 'user/show_user_message.tx';
    
    my $message = $c->model('DB')->resultset('Message')->find( $message_id );

    # TODO Check for errors:
    # 1. user_profile.id != message.author_id
    # 2. ! user
    # 3. ! message

    $c->stash->{message}       = $message;
    $c->stash->{comments}      = $self->_get_message_children( $c, $message->id );
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
