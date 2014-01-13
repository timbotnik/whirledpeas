CREATE TABLE "challenge_data" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "challenges_id" integer, "key" varchar(32), "value" varchar(255));
CREATE TABLE "challenge_responses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "challenges_id" integer, "response" varchar(255), "status" varchar(16) DEFAULT 'pending' NOT NULL, "users_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "challenge_templates" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(64), "format" varchar(255), "type" varchar(16), "query" varchar(255));
CREATE TABLE "challenges" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "challenge_templates_id" integer, "stakes" varchar(255), "users_id" integer, "featured" boolean DEFAULT '0' NOT NULL, "logo_url" varchar(512), "status" varchar(16), "closes_at" datetime, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "challenges_id" integer, "users_id" integer, "comment" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "facebookid" integer, "email" varchar(255), "nickname" varchar(64), "role" varchar(16) DEFAULT 'user' NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE INDEX "email_idx" ON "users" ("email");
CREATE INDEX "fb_id_idx" ON "users" ("facebookid");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20110728175113');