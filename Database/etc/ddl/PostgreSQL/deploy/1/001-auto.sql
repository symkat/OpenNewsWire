--
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sun Sep 19 11:29:43 2021
--
;
--
-- Table: person
--
CREATE TABLE "person" (
  "id" serial NOT NULL,
  "name" citext NOT NULL,
  "email" citext,
  "is_enabled" boolean DEFAULT true NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "person_email_key" UNIQUE ("email"),
  CONSTRAINT "person_name_key" UNIQUE ("name")
);

;
--
-- Table: auth_password
--
CREATE TABLE "auth_password" (
  "person_id" integer NOT NULL,
  "password" text NOT NULL,
  "salt" text NOT NULL,
  "updated_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  CONSTRAINT "auth_password_person_id_key" UNIQUE ("person_id")
);
CREATE INDEX "auth_password_idx_person_id" on "auth_password" ("person_id");

;
--
-- Table: channel
--
CREATE TABLE "channel" (
  "id" serial NOT NULL,
  "owner_id" integer NOT NULL,
  "name" text NOT NULL,
  "is_enabled" boolean DEFAULT true NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "channel_idx_owner_id" on "channel" ("owner_id");

;
--
-- Table: message
--
CREATE TABLE "message" (
  "id" serial NOT NULL,
  "author_id" integer NOT NULL,
  "parent_id" integer,
  "title" text,
  "content" text,
  "url" text,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "message_idx_author_id" on "message" ("author_id");
CREATE INDEX "message_idx_parent_id" on "message" ("parent_id");

;
--
-- Table: person_settings
--
CREATE TABLE "person_settings" (
  "id" serial NOT NULL,
  "person_id" integer NOT NULL,
  "name" text NOT NULL,
  "value" json DEFAULT '{}' NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "unq_person_id_name" UNIQUE ("person_id", "name")
);
CREATE INDEX "person_settings_idx_person_id" on "person_settings" ("person_id");

;
--
-- Table: topic_channel
--
CREATE TABLE "topic_channel" (
  "id" serial NOT NULL,
  "owner_id" integer NOT NULL,
  "name" text NOT NULL,
  "is_enabled" boolean DEFAULT true NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "topic_channel_idx_owner_id" on "topic_channel" ("owner_id");

;
--
-- Table: channel_settings
--
CREATE TABLE "channel_settings" (
  "id" serial NOT NULL,
  "channel_id" integer NOT NULL,
  "name" text NOT NULL,
  "value" json DEFAULT '{}' NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "unq_channel_id_name" UNIQUE ("channel_id", "name")
);
CREATE INDEX "channel_settings_idx_channel_id" on "channel_settings" ("channel_id");

;
--
-- Table: message_read
--
CREATE TABLE "message_read" (
  "message_id" integer NOT NULL,
  "person_id" integer NOT NULL,
  "is_read" boolean DEFAULT true NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("message_id", "person_id")
);
CREATE INDEX "message_read_idx_message_id" on "message_read" ("message_id");
CREATE INDEX "message_read_idx_person_id" on "message_read" ("person_id");

;
--
-- Table: person_message
--
CREATE TABLE "person_message" (
  "id" serial NOT NULL,
  "person_id" integer NOT NULL,
  "message_id" integer NOT NULL,
  "is_read" boolean DEFAULT false NOT NULL,
  "is_archived" boolean DEFAULT false NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "person_message_idx_message_id" on "person_message" ("message_id");
CREATE INDEX "person_message_idx_person_id" on "person_message" ("person_id");

;
--
-- Table: private_message
--
CREATE TABLE "private_message" (
  "id" serial NOT NULL,
  "to_person_id" integer NOT NULL,
  "from_person_id" integer NOT NULL,
  "message_id" integer NOT NULL,
  "is_read" boolean DEFAULT false NOT NULL,
  "is_archived" boolean DEFAULT false NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "private_message_idx_from_person_id" on "private_message" ("from_person_id");
CREATE INDEX "private_message_idx_message_id" on "private_message" ("message_id");
CREATE INDEX "private_message_idx_to_person_id" on "private_message" ("to_person_id");

;
--
-- Table: topic_channel_settings
--
CREATE TABLE "topic_channel_settings" (
  "id" serial NOT NULL,
  "topic_channel_id" integer NOT NULL,
  "name" text NOT NULL,
  "value" json DEFAULT '{}' NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "unq_channel_id_name" UNIQUE ("topic_channel_id", "name")
);
CREATE INDEX "topic_channel_settings_idx_topic_channel_id" on "topic_channel_settings" ("topic_channel_id");

;
--
-- Table: user_channel_message
--
CREATE TABLE "user_channel_message" (
  "id" serial NOT NULL,
  "author_id" integer NOT NULL,
  "message_id" integer NOT NULL,
  "is_archived" boolean DEFAULT false NOT NULL,
  "is_stickied" boolean DEFAULT false NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "user_channel_message_idx_author_id" on "user_channel_message" ("author_id");
CREATE INDEX "user_channel_message_idx_message_id" on "user_channel_message" ("message_id");

;
--
-- Table: channel_message
--
CREATE TABLE "channel_message" (
  "id" serial NOT NULL,
  "person_id" integer NOT NULL,
  "channel_id" integer NOT NULL,
  "message_id" integer NOT NULL,
  "is_read" boolean DEFAULT false NOT NULL,
  "is_archived" boolean DEFAULT false NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "channel_message_idx_channel_id" on "channel_message" ("channel_id");
CREATE INDEX "channel_message_idx_message_id" on "channel_message" ("message_id");
CREATE INDEX "channel_message_idx_person_id" on "channel_message" ("person_id");

;
--
-- Table: topic_channel_message
--
CREATE TABLE "topic_channel_message" (
  "id" serial NOT NULL,
  "author_id" integer NOT NULL,
  "channel_id" integer NOT NULL,
  "message_id" integer NOT NULL,
  "is_archived" boolean DEFAULT false NOT NULL,
  "is_stickied" boolean DEFAULT false NOT NULL,
  "created_at" timestamp with time zone DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY ("id")
);
CREATE INDEX "topic_channel_message_idx_author_id" on "topic_channel_message" ("author_id");
CREATE INDEX "topic_channel_message_idx_channel_id" on "topic_channel_message" ("channel_id");
CREATE INDEX "topic_channel_message_idx_message_id" on "topic_channel_message" ("message_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "auth_password" ADD CONSTRAINT "auth_password_fk_person_id" FOREIGN KEY ("person_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "channel" ADD CONSTRAINT "channel_fk_owner_id" FOREIGN KEY ("owner_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "message" ADD CONSTRAINT "message_fk_author_id" FOREIGN KEY ("author_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "message" ADD CONSTRAINT "message_fk_parent_id" FOREIGN KEY ("parent_id")
  REFERENCES "message" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "person_settings" ADD CONSTRAINT "person_settings_fk_person_id" FOREIGN KEY ("person_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "topic_channel" ADD CONSTRAINT "topic_channel_fk_owner_id" FOREIGN KEY ("owner_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "channel_settings" ADD CONSTRAINT "channel_settings_fk_channel_id" FOREIGN KEY ("channel_id")
  REFERENCES "channel" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "message_read" ADD CONSTRAINT "message_read_fk_message_id" FOREIGN KEY ("message_id")
  REFERENCES "message" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "message_read" ADD CONSTRAINT "message_read_fk_person_id" FOREIGN KEY ("person_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "person_message" ADD CONSTRAINT "person_message_fk_message_id" FOREIGN KEY ("message_id")
  REFERENCES "message" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "person_message" ADD CONSTRAINT "person_message_fk_person_id" FOREIGN KEY ("person_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "private_message" ADD CONSTRAINT "private_message_fk_from_person_id" FOREIGN KEY ("from_person_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "private_message" ADD CONSTRAINT "private_message_fk_message_id" FOREIGN KEY ("message_id")
  REFERENCES "message" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "private_message" ADD CONSTRAINT "private_message_fk_to_person_id" FOREIGN KEY ("to_person_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "topic_channel_settings" ADD CONSTRAINT "topic_channel_settings_fk_topic_channel_id" FOREIGN KEY ("topic_channel_id")
  REFERENCES "topic_channel" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "user_channel_message" ADD CONSTRAINT "user_channel_message_fk_author_id" FOREIGN KEY ("author_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "user_channel_message" ADD CONSTRAINT "user_channel_message_fk_message_id" FOREIGN KEY ("message_id")
  REFERENCES "message" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "channel_message" ADD CONSTRAINT "channel_message_fk_channel_id" FOREIGN KEY ("channel_id")
  REFERENCES "channel" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "channel_message" ADD CONSTRAINT "channel_message_fk_message_id" FOREIGN KEY ("message_id")
  REFERENCES "message" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "channel_message" ADD CONSTRAINT "channel_message_fk_person_id" FOREIGN KEY ("person_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "topic_channel_message" ADD CONSTRAINT "topic_channel_message_fk_author_id" FOREIGN KEY ("author_id")
  REFERENCES "person" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "topic_channel_message" ADD CONSTRAINT "topic_channel_message_fk_channel_id" FOREIGN KEY ("channel_id")
  REFERENCES "topic_channel" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
ALTER TABLE "topic_channel_message" ADD CONSTRAINT "topic_channel_message_fk_message_id" FOREIGN KEY ("message_id")
  REFERENCES "message" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

;
