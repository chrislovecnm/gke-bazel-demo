#! /usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z "$1" ]; then
  HOST=localhost:8080
else
  HOST=$1
fi

echo "Testing Java Todo API endpoint on $HOST"

# listing none works
  RESPONSE="$(curl -s "$HOST/api/todos")"

  if [ "$RESPONSE" == "[]" ]; then
    echo "Empty index works"
  else
    echo "EMPTY INDEX BROKEN; RESPONSE = $RESPONSE"
  fi


# creating a todo works
  TODO_ID="$(curl -sX POST -H 'Content-Type: application/json' \
        --data '{"title": "Change Laundry"}' \
        "$HOST"/api/todos | awk -F'\"' '{print $4}')"

  if [[ "$TODO_ID" =~ ^\{?[A-F0-9a-f]{8}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{4}-[A-F0-9a-f]{12}\}?$ ]]; then
    echo "POST todo works"
  else
    echo "POST TODO BROKEN"
  fi


# getting a todo works
  TODO="$(curl -s "$HOST/api/todos/$TODO_ID")"
  TITLE="$( echo "$TODO" | awk -F'\"' '{print $8}' )"
  DONE="$( echo "$TODO" | awk -F':' '{print $4}' | awk -F'}' '{print $1}' )"
# echo "TODO = $TODO; TITLE = $TITLE; DONE = $DONE"

  if [ "$TITLE" == "Change Laundry" ]; then
    if [ "$DONE" == false ]; then
      echo "GET todo works"
    else
      echo "GET BROKEN"
    fi
  else
    echo "GET BROKEN"
  fi


# updating todo title works
  TODO="$(curl -sX PUT -H 'Content-Type: application/json' \
        --data '{"title": "Take out trash"}' \
        "$HOST/api/todos/$TODO_ID")"

  TODO="$(curl -s "$HOST/api/todos/$TODO_ID")"
  TITLE="$( echo "$TODO" | awk -F'\"' '{print $8}' )"
  DONE="$( echo "$TODO" | awk -F':' '{print $4}' | awk -F'}' '{print $1}' )"

  if [ "$TITLE" == "Take out trash" ]; then
    if [ "$DONE" == false ]; then
      echo "PUT todo title works"
    else
      echo "UPDATE title BROKEN"
    fi
  else
    echo "UPDATE title BROKEN"
  fi


# updating todo done works
  TODO="$(curl -sX PUT -H 'Content-Type: application/json' \
        --data '{"done": true}' \
        "$HOST/api/todos/$TODO_ID")"

  TODO="$(curl -s "$HOST/api/todos/$TODO_ID")"
  TITLE="$( echo "$TODO" | awk -F'\"' '{print $8}' )"
  DONE="$( echo "$TODO" | awk -F':' '{print $4}' | awk -F'}' '{print $1}' )"

  if [ "$TITLE" == "Take out trash" ]; then
    if [ "$DONE" == true ]; then
      echo "PUT todo done works"
    else
      echo "UPDATE done BROKEN"
    fi
  else
    echo "UPDATE done BROKEN"
  fi


# deleting a todo works
  curl -sX DELETE "$HOST"/api/todos/"$TODO_ID" > /dev/null

  TODO="$(curl -s "$HOST/api/todos/$TODO_ID")"

  if [[ "$TODO" == *"Not Found"* ]]; then
    echo "DELETE works"
  else
    echo "DELETE; RESPONSE = $TODO"
  fi

