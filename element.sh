#!/usr/bin/bash
PATTERN='^[1-9][1-9]*$'

NUMBER=100

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [ $# -eq 0 ]
then
  echo "Please provide an element as an argument."
  exit 0
elif [[ $1 =~ $PATTERN ]] # $1 matches "INT" regex
  then
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")

elif [ ${#1} == 1 ] || [ ${#1} == 2 ] # $1 is SYMBOL
  then
    NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")

else # $1 is NAME
  NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
fi

if [ -n "$NUMBER" ]
then
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$NUMBER")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUMBER")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUMBER")
TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$NUMBER")
TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
else
echo "I could not find that element in the database."
fi