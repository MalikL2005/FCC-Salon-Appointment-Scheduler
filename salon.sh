#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


MAIN_MENU (){
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  else 
    echo -e "\n~~~~~ MY SALON ~~~~~\n"
    echo -e "Welcome to My Salon, how can I help you?\n"
  fi 

  #display list of services 
  DISPLAY_SERVICES=$($PSQL "SELECT name FROM services ORDER BY service_id")
  echo $DISPLAY_SERVICES | while read ONE TWO THREE 
  do
    echo -e "1) $ONE\n2) $TWO\n3) $THREE\n"
  done 

  #prompt user for service_id 
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in 
    1) START_APPOINTMENT ;;
    2) START_APPOINTMENT ;;
    3) START_APPOINTMENT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
    esac
}

START_APPOINTMENT(){
  #get users phonenumber 
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE   

  #does phonenumber already exist?
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then 
    ADD_NEW_CUSTOMER 
  else 
    SET_APPOINTMENT 
  fi
}

ADD_NEW_CUSTOMER (){
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  RESULT_ADD_CUSTOMER=$($PSQL "INSERT INTO customers (phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  SET_APPOINTMENT 
}

SET_APPOINTMENT (){
  echo "What time would you like your cut,$CUSTOMER_NAME?"
  read SERVICE_TIME
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  
  #remove all spaces
  CUSTOMER_NAME=${CUSTOMER_NAME// /}  
  SERVICE_NAME=${SERVICE_NAME// /} 

  #add appointment to DB
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
  ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments (time, customer_id, service_id) VALUES('$SERVICE_TIME', $CUSTOMER_ID ,$SERVICE_ID_SELECTED)")
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}


MAIN_MENU 