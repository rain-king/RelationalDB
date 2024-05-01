#!/bin/bash

PSQL="psql -U $USER --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

PLAYER_ID=$($PSQL "select player_id from players where username = '$USERNAME';")

if [[ -z $PLAYER_ID ]]
then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USERNAME_RESULT="$($PSQL "insert into players (username) values ('$USERNAME');")"
    PLAYER_ID=$($PSQL "select player_id from players where username = '$USERNAME';")
else
    GAMES_PLAYED=$($PSQL "select count(*) from games where player_id = $PLAYER_ID;")
    BEST_GAME=$($PSQL "select min(guesses) from games where player_id = $PLAYER_ID;")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RND_NUMBER=$(( RANDOM % 1000 + 1 ))

echo "Guess the secret number between 1 and 1000:"
read GUESS
if [[ $GUESS =~ ^[0-9]+$ ]]
then
    GUESSES=1
else
    GUESSES=0
fi

until [[ $GUESS == $RND_NUMBER ]]
do
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
        let GUESSES++
        if [[ $GUESS -gt $RND_NUMBER ]]
        then
            echo "It's lower than that, guess again:"
        else
            echo "It's higher than that, guess again:"
        fi
    else
        echo "That is not an integer, guess again:"
    fi
    read GUESS
done

INSERT_GAME_RESULT="$($PSQL "insert into games (guesses, player_id) values ($GUESSES, $PLAYER_ID);")"

echo "You guessed it in $GUESSES tries. The secret number was $RND_NUMBER. Nice job!"
