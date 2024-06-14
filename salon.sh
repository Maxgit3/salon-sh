#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Super Salon Shop ~~~~~\n"



MAIN_MENU() {

if [[ $1 ]]
  then
    echo -e "\nI could not find that service.\n"
fi

echo "How may I help your hair?" 

SALON_SERVICES=$($PSQL "SELECT * FROM services")

echo "$SALON_SERVICES" | while read SERVICE_ID PIPE SERVICE_NAME

do

echo -e "$SERVICE_ID) $SERVICE_NAME"

done

read SERVICE_ID_SELECTED 

SALON_SERVICES=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

# is it a valid services
if [[ -z $SALON_SERVICES ]]
  then
    MAIN_MENU "I could not find that service."
  else
    echo -e "\nYou want a $SALON_SERVICES"
    echo -e "\nWhat is your phone number?"

    read CUSTOMER_PHONE  
    CUSTOMER=$($PSQL "SELECT name from customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER ]]
      then
        echo "Customer not found. What is your Name?"
        read  CUSTOMER_NAME
        INSERT_INTO=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

        echo "What time would you like to schedule?"
        read SERVICE_TIME 

        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
        INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')") 

      else
        echo "What time would you like to schedule?"
        read SERVICE_TIME
        
        CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
        INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')") 
    fi
  APPOINTMENT_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  APPOINTMENT_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID'")
  # echo $APPOINTMENT_SERVICE
  # echo $SERVICE_TIME
  # echo $APPOINTMENT_NAME

  echo "I have put you down for a$APPOINTMENT_SERVICE at $SERVICE_TIME,$APPOINTMENT_NAME."
fi


}

MAIN_MENU
