#!/bin/bash
PSQL="psql --username=gus --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
    echo Please provide an element as an argument.
    exit 0
fi

# try to get atomic_number from name
ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where name = '$1';")

# try to get atomic number from symbol
if [[ -z $ATOMIC_NUMBER ]]
then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$1';")
fi

# try to get atomic number directly
# since numbers can't be passed enclosed by quotes have to be careful
# that the input is not a column name
if [[ $1 != atomic_number && $1 != symbol && $1 != name && -z $ATOMIC_NUMBER ]]
then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1;" 2> /dev/null)
fi

# if all fail, user prompted invalid input
if [[ -z $ATOMIC_NUMBER ]]
then
    echo I could not find that element in the database.
    exit 0
else
    SYMBOL=$($PSQL "select symbol from elements where atomic_number=$ATOMIC_NUMBER;")
    NAME=$($PSQL "select name from elements where atomic_number=$ATOMIC_NUMBER;")
    ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER;")
    MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
    BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
    TYPE=$($PSQL "select t.type from properties p inner join types t on p.type_id = t.type_id where p.atomic_number=$ATOMIC_NUMBER;")
fi

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."