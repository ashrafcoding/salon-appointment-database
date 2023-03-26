#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SERVICES=$($PSQL "SELECT * FROM services")
 
  echo -e "How may I help you? Choose from our services !\n" 

  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    [1-5]) SCHEDULE $SERVICE_ID_SELECTED ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac

  # if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  #   then
  #     MAIN_MENU "That is not a valid service."
  # fi
  # SERVICE_NUMBERS=$($PSQL "SELECT service_id FROM services where service_id = $SERVICE_ID_SELECTED ")
    
  # if [[ -z $SERVICE_NUMBERS ]]
  #   then
  #     MAIN_MENU "please choose the correct number"
  #   else
  #     SCHEDULE $SERVICE_ID_SELECTED   
  # fi  
 
}

SCHEDULE(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $NAME ]]
    then
      # get new customer name
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME
      # insert new customer
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name from customers where phone ='$CUSTOMER_PHONE'")
       
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nWhen you prefere your service?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SELECTED_SERVICES=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED ")
  echo -e "\nI have put you down for a $SELECTED_SERVICES at $SERVICE_TIME, $CUSTOMER_NAME."

}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU

