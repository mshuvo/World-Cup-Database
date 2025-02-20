#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != "year" ]]
  then
  #checke for team_id
  team_id_winner=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  team_id_opponent=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  #if not found
  if [[ -z $team_id_winner ]]
      then
        insert_res=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $insert_res == 'INSERT 0 1' ]]
        then
          echo Inserted into teams, $WINNER
        fi
        team_id_winner=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi
  #if not found
  if [[ -z $team_id_opponent ]]
      then
        insert_res=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $insert_res == 'INSERT 0 1' ]]
        then
          echo Inserted into teams, $OPPONENT
        fi
        team_id_opponent=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi
  insert_res=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $team_id_winner, $team_id_opponent, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $insert_res == 'INSERT 0 1' ]]
    then
      echo Inserted into teams, $YEAR $ROUND
    fi
fi
done