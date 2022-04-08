#!/bin/bash

player_1=X
player_2=O

playing=true
turn=1

moves=("1" "2" "3" "4" "5" "6" "7" "8" "9")

function print_board {
  clear
  echo " ${moves[0]} | ${moves[1]} | ${moves[2]} "
  echo "--- --- ---"
  echo " ${moves[3]} | ${moves[4]} | ${moves[5]} "
  echo "--- --- ---"
  echo " ${moves[6]} | ${moves[7]} | ${moves[8]} "
}

function player_pick {
  current_player=$([[ $(($turn % 2)) == 0 ]] && echo $player_2 || echo $player_1)
  square=0
  if [[ $current_player == $player_1 ]]
  then
    echo -n "PLAYER 1 PICK A SQUARE: "
    read square
  else
    square=$((($RANDOM%9)+1))
    while [ ${moves[($square -1)]} != $square ]
    do
      square=$((($RANDOM%9)+1))
    done
  fi
  space=${moves[($square -1)]} 

  if [[ ! $square =~ ^-?[0-9]+$ ]] || [[ ! $space =~ ^[0-9]+$  ]]
  then 
    echo "Not a valid square."
    player_pick
  else
    moves[($square -1)]=$current_player
    ((turn=turn+1))
  fi
  space=${moves[($square-1)]} 
}

function check_match {
  if  [[ ${moves[$1]} == ${moves[$2]} ]]&&[[ ${moves[$2]} == ${moves[$3]} ]]; then
    playing=false
    if [ ${moves[$1]} == 'X' ];then
      echo "Player one wins!"
      return 
    else
      echo "player two wins!"
      return 
    fi
  fi
}

function check_winner {
  check_match 0 1 2
  if [ $playing == false ]; then return; fi
  check_match 3 4 5
  if [ $playing == false ]; then return; fi
  check_match 6 7 8
  if [ $playing == false ]; then return; fi
  check_match 0 4 8
  if [ $playing == false ]; then return; fi
  check_match 2 4 6
  if [ $playing == false ]; then return; fi
  check_match 0 3 6
  if [ $playing == false ]; then return; fi
  check_match 1 4 7
  if [ $playing == false ]; then return; fi
  check_match 2 5 8
  if [ $playing == false ]; then return; fi

  if [ $turn -gt 9 ]; then 
    playing=false
    echo "Its a draw!"
  fi
}

print_board
while $playing
do
  player_pick
  print_board
  check_winner
done

