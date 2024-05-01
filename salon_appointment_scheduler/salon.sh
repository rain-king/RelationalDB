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
# TODO: loop until CUSTOMER_PHONE isn't empty
CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE';")
if [[ -z $CUSTOMER_NAME ]]
then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # TODO: loop until CUSTOMER_NAME isn't empty
    INSERT_PHONE_RESULT=$($PSQL "insert into customers (name, phone) values ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');")
fi

CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE';")

echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
# TODO: loop until SERVICE_TIME isn't empty
INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments (time, customer_id, service_id) values ('$SERVICE_TIME', $CUSTOMER_ID, $SERVICE_ID_SELECTED);")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."