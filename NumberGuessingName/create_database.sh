#!/bin/bash
RESET="psql --username=$USER --dbname=postgres -t --no-align -c"
PSQL="psql -U $USER --dbname=number_guess -t --no-align -c"

echo $($RESET "drop database if exists number_guess;")
echo $($RESET "create database number_guess;")

echo $($PSQL "create table players();")
echo $($PSQL "create table games();")

echo $($PSQL "alter table players add column player_id serial primary key;")
echo $($PSQL "alter table players add column username varchar(22) unique;")

echo $($PSQL "alter table games add column game_id serial primary key;")
echo $($PSQL "alter table games add column guesses int;")
echo $($PSQL "alter table games add column player_id int;")
echo $($PSQL "alter table games add foreign key (player_id) references players (player_id);")
