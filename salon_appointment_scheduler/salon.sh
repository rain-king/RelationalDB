#!/bin/bash

PSQL="psql --username=$USER --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"

echo "1) cut"
echo "2) color"
echo "3) perm"
echo "4) style"
echo "5) trim"

read SERVICE_ID_SELECTED

until [[ $SERVICE_ID_SELECTED == 1 ||
         $SERVICE_ID_SELECTED == 2 ||
         $SERVICE_ID_SELECTED == 3 ||
         $SERVICE_ID_SELECTED == 4 ||
         $SERVICE_ID_SELECTED == 5 ]]
do
    echo -e "\nI could not find that service. What would you like today?"
    echo "1) cut"
    echo "2) color"
    echo "3) perm"
    echo "4) style"
    echo "5) trim"

    read SERVICE_ID_SELECTED
done

SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED;")

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

while [[ -z $CUSTOMER_PHONE ]]
do
    echo -e "\nEnter a phone number:"
    read CUSTOMER_PHONE
done

CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE';")

if [[ -z $CUSTOMER_NAME ]]
then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    while [[ -z $CUSTOMER_NAME ]]
    do
        echo -e "\nPlease enter a name:"
        read CUSTOMER_NAME
    done

    INSERT_PHONE_RESULT=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
fi

CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")

echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

while [[ -z $SERVICE_TIME ]]
do
    echo -e "\nPlease enter a time for your $SERVICE_NAME:"
    read SERVICE_TIME
done

INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments (time, customer_id, service_id) values ('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED);")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."