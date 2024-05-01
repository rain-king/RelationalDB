#!/bin/bash
RESET="psql --username=$USER --dbname=postgres -t --no-align -c"
PSQL="psql --username=$USER --dbname=salon -t --no-align -c"

echo "$($RESET "drop database if exists salon;")"
echo "$($RESET "create database salon;")"

echo "$($PSQL "create table customers();")"
echo "$($PSQL "create table appointments();")"
echo "$($PSQL "create table services();")"

echo "$($PSQL "alter table customers add column customer_id serial primary key;")"
echo "$($PSQL "alter table customers add column name varchar(50) not null;")"
echo "$($PSQL "alter table customers add column phone varchar(15) unique not null;")"

echo "$($PSQL "alter table services add column service_id serial primary key;")"
echo "$($PSQL "alter table services add column name varchar(50);")"

echo "$($PSQL "alter table appointments add column appointment_id serial primary key;")"
echo "$($PSQL "alter table appointments add column time varchar(20) not null;")"

echo "$($PSQL "alter table appointments add column customer_id int not null;")"
echo "$($PSQL "alter table appointments add column service_id int not null;")"

echo "$($PSQL "alter table appointments add foreign key (customer_id) references customers (customer_id);")"
echo "$($PSQL "alter table appointments add foreign key (service_id) references services (service_id);")"

echo "$($PSQL "insert into services (name) values ('cut');")"
echo "$($PSQL "insert into services (name) values ('color');")"
echo "$($PSQL "insert into services (name) values ('perm');")"
echo "$($PSQL "insert into services (name) values ('style');")"
echo "$($PSQL "insert into services (name) values ('trim');")"