#!/bin/bash

set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE bytesweep;
	CREATE USER bsuser WITH PASSWORD '$DBPASS';
	GRANT ALL PRIVILEGES ON DATABASE bytesweep to bsuser;
EOSQL

set -e
psql -v ON_ERROR_STOP=1 --username bsuser --dbname bytesweep <<-EOSQL
	CREATE TYPE job_status AS ENUM ('queued', 'processing', 'done');
	create table cve (cve_id serial NOT NULL primary key,data jsonb);
	CREATE INDEX idxgin ON cve USING gin (data);
	create table cve_metadata (metadata_id serial NOT NULL primary key,last_modified_date timestamp, last_modified_date_text text);
	create table jobs (job_id serial NOT NULL primary key,job_name varchar(255) NOT NULL unique,job_status job_status NOT NULL,job_project_basedir text NOT NULL, job_filename text NOT NULL,job_filepath text NOT NULL,job_notes text);
	create table data (data_id serial not null primary key,job_id serial references jobs(job_id),data json not null);
	create table users (user_id serial not null primary key, username text not null, siteadmin boolean not null, hash text not null);
	create table groups (group_id serial not null primary key, groupname text not null);
	create table user_group (user_id serial not null references users(user_id), group_id serial not null references groups(group_id), read boolean not null, write boolean not null, admin boolean not null);
	create table watchdog_metadata (id serial NOT NULL primary key,last_modified_date timestamp, last_modified_date_text text);
	create table watchdog_3p_cve (id serial NOT NULL primary key,data_id serial references data(data_id),cve_id serial references cve(cve_id),discover_date timestamp,last_modified_date_text text,new boolean NOT NULL DEFAULT FALSE, rule_matches jsonb,match_id int);
EOSQL

