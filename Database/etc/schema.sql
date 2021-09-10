CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE person (
    id                          serial          PRIMARY KEY,
    name                        text            not null,
    email                       citext          not null unique,
    is_enabled                  boolean         not null default true,
    created_at                  timestamptz     not null default current_timestamp
);

-- Settings for a given user.  | Use with care, add things to the data model when you should.
create TABLE person_settings (
    id                          serial          PRIMARY KEY,
    person_id                   int             not null references person(id),
    name                        text            not null,
    value                       json            not null default '{}',
    created_at                  timestamptz     not null default current_timestamp,

    -- Allow ->find_or_new_related()
    CONSTRAINT unq_person_id_name UNIQUE(person_id, name)
);

CREATE TABLE auth_password (
    person_id                   int             not null unique references person(id),
    password                    text            not null,
    salt                        text            not null,
    updated_at                  timestamptz     not null default current_timestamp,
    created_at                  timestamptz     not null default current_timestamp
);

CREATE TABLE message (
    id                          serial          PRIMARY KEY,
    author_id                   int             not null references person(id),
    parent_id                   int             references message(id),
    title                       text            ,
    content                     text            ,
    url                         text            ,
    created_at                  timestamptz     not null default current_timestamp
);

CREATE TABLE message_read (
    message_id                  int             not null references message(id),
    person_id                   int             not null references person(id),
    is_read                     boolean         not null default true,
    created_at                  timestamptz     not null default current_timestamp,
    PRIMARY KEY (message_id, person_id)    
);

CREATE TABLE topic_channel (
    id                          serial          PRIMARY KEY,
    owner_id                    int             not null references person(id),
    name                        text            not null,
    is_enabled                  boolean         not null default true,
    created_at                  timestamptz     not null default current_timestamp
);

-- Settings for a given channel.  | Use with care, add things to the data model when you should.
create TABLE topic_channel_settings (
    id                          serial          PRIMARY KEY,
    topic_channel_id            int             not null references topic_channel(id),
    name                        text            not null,
    value                       json            not null default '{}',
    created_at                  timestamptz     not null default current_timestamp,

    -- Allow ->find_or_new_related()
    CONSTRAINT unq_channel_id_name UNIQUE(topic_channel_id, name)
);

create TABLE topic_channel_message (
    id                          serial          PRIMARY KEY,
    author_id                   int             not null references person(id),
    channel_id                  int             not null references topic_channel(id),
    message_id                  int             not null references message(id),
    is_archived                 boolean         not null default false,
    is_stickied                 boolean         not null default false,
    created_at                  timestamptz     not null default current_timestamp
);

create TABLE user_channel_message (
    id                          serial          PRIMARY KEY,
    author_id                   int             not null references person(id),
    message_id                  int             not null references message(id),
    is_archived                 boolean         not null default false,
    is_stickied                 boolean         not null default false,
    created_at                  timestamptz     not null default current_timestamp
);
