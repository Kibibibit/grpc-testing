#!/bin/bash


## Get Parameters
MESSAGE=$1
DELIM=$2
FIELDS=$3

## Define the filename
FILE_NAME="./protos/$MESSAGE.proto"

## Will write to FILE_NAME
function write {
    echo $1 >> "$FILE_NAME"
}

## Adds a blank newline to FILE_NAME
function newline {
    write ""
}

function writeFields {

    IFS=',' read -ra FIELD_ARR <<< $1
    for field in ${FIELD_ARR[@]}
    do
        IFS=$DELIM read -ra ADDR <<< $field
        VAR=${ADDR[0]}
        SQL_TYPE=${ADDR[1]}

        echo $VAR, $SQL_TYPE

    done
}


## Make the protos folder if it does not exist
mkdir -p "./protos/"

## Delete the previous version of this file if it exists
rm -f $FILE_NAME
## Create the file
touch $FILE_NAME

CLASS_NAME=${MESSAGE^}

write "//--AUTOGENERATED PROTOFILE $FILENAME FOR $MESSAGE--"
newline
newline
write "syntax = \"proto3\";"
newline
write "option java_multiple_files = true;"
write "option java_package = \"life.genny.model.grpc\";"
write "option java_outer_classname = \"${CLASS_NAME}Proto\";"
newline
write "package $MESSAGE;"
newline
newline
write "message $MESSAGE {"
writeFields $FIELDS
write "}"


