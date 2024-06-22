#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

clear_tables=$($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $TEAM_ID ]]
  then
    ADD_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  fi

  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $TEAM_ID ]]
  then
    ADD_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi
  
fi
done


cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_INFO=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
fi
done