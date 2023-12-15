#!/bin/bash

MAIN_MENU() {

  PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

  echo "Enter your username:"
  read USERNAME
  USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")

  if [[ -z $USER_ID ]]
  then
    INSERT_NEW_USER=$($PSQL "insert into users(username) values('$USERNAME')")
    echo "Welcome, ${USERNAME// /}! It looks like this is your first time here."
  else
    GAMES_PLAYED=$($PSQL "select games_played from users where user_id=$USER_ID")
    BEST_GAME=$($PSQL "select best_game from users where user_id=$USER_ID")
    if [ $GAMES_PLAYED == 1 ] && [ $BEST_GAME == 1 ]
    then
      echo "Welcome back, ${USERNAME// /}! You have played ${GAMES_PLAYED// /} game, and your best game took ${BEST_GAME// /} guess."
    elif [[ $GAMES_PLAYED == 1 ]]
    then
      echo "Welcome back, ${USERNAME// /}! You have played ${GAMES_PLAYED// /} game, and your best game took ${BEST_GAME// /} guesses."
    elif [[ $BEST_GAME == 1 ]]
    then
      echo "Welcome back, ${USERNAME// /}! You have played ${GAMES_PLAYED// /} games, and your best game took ${BEST_GAME// /} guess."
    else
      echo "Welcome back, ${USERNAME// /}! You have played ${GAMES_PLAYED// /} games, and your best game took ${BEST_GAME// /} guesses."
    fi
  fi

  USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
  GAMES_PLAYED=$($PSQL "select games_played from users where user_id=$USER_ID")
  BEST_GAME=$($PSQL "select best_game from users where user_id=$USER_ID")
  SECRET_NUMBER=$(( ( $RANDOM % 999 ) + 2 ))
  NUMBER_OF_TRIES=1

  echo "Guess the secret number between 1 and 1000:"
  read GUESS
  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    ((NUMBER_OF_TRIES++))
    if [[ $GUESS =~ ^[0-9]+$ ]]
    then
      if [[ $GUESS > $SECRET_NUMBER ]]
      then
        echo "It's lower than that, guess again:"
        read GUESS
      elif [[ $GUESS < $SECRET_NUMBER ]]
      then
        echo "It's higher than that, guess again:"
        read GUESS
      fi
    else
      echo "That is not an integer, guess again:"
      read GUESS
    fi
  done

  GAMES_PLAYED=$($PSQL "update users set games_played=($GAMES_PLAYED+1) where user_id=$USER_ID")
  if [[ $NUMBER_OF_TRIES -lt $BEST_GAME ]]
  then
    BEST_GAME=$($PSQL "update users set best_game=$NUMBER_OF_TRIES where user_id=$USER_ID")
  elif [[ -z $BEST_GAME ]]
  then
    BEST_GAME=$($PSQL "update users set best_game=$NUMBER_OF_TRIES where user_id=$USER_ID")
  fi

  if [[ $NUMBER_OF_TRIES == 1 ]]
  then
    echo "You guessed it in ${NUMBER_OF_TRIES/ //} try. The secret number was ${SECRET_NUMBER/ //}. Nice job!"
  else
    echo "You guessed it in ${NUMBER_OF_TRIES/ //} tries. The secret number was ${SECRET_NUMBER/ //}. Nice job!"
  fi

}

MAIN_MENU