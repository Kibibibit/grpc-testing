#!/bin/bash


./clear-protos.sh

PORT=3310
HOST=127.0.0.1
USER=$GENNY_LOCAL_MYSQL_USER
PASSWORD=$GENNY_LOCAL_MYSQL_PASSWORD
DB=$GENNY_LOCAL_MYSQL_DB
DELIM=":"


FILTER=$@

if [ -z "$FILTER" ]
then
  FILTER="baseentity baseentity_attribute"
fi


TABLES=`mysql --port="$PORT" \
      --host="$HOST" \
      --user="$USER" \
      --password="$PASSWORD" \
      --database="$DB" \
      --execute="SHOW TABLES;"`

#Don't want the header table
firstTable=0

for table in $TABLES
do
    if [ $firstTable -eq 1 ]
    then


      if [[ "$FILTER" == *"$table"* ]]
      then

        # Get the fields of each table, grabbing only their name and type
        FIELDS=`mysql --port="$PORT" \
          --host="$HOST" \
          --user="$USER" \
          --password="$PASSWORD" \
          --database="$DB" \
          --execute="SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_NAME = '$table';"`

        # , 

        # We don't want the first two entries as those are just the header names
        count=0
        # I couldn't work out a better way to do this...
        second=0

        
        TABLE_FIELD_SET=""
        TABLE_META_SET=""

        echo --- TABLE: $table ---

        for field in $FIELDS
        do

          if [ $count -gt 0 ]
          then
            TABLE_FIELD_SET="$TABLE_FIELD_SET,$field"
            
            META=`mysql --port="$PORT" \
            --host="$HOST" \
            --user="$USER" \
            --password="$PASSWORD" \
            --database="$DB" \
            --execute="SELECT DATA_TYPE, IS_NULLABLE, COLUMN_KEY FROM information_schema.COLUMNS WHERE TABLE_NAME = '$table' AND COLUMN_NAME = '$field';"`
            META_SET=""
            metacount=0
            for metadata in $META
            do
              if [ $metacount -gt 2 ]
              then
                META_SET="$META_SET$DELIM$metadata"
                
              fi

              metacount=$((metacount+1))
            done
            TABLE_META_SET="$TABLE_META_SET,$META_SET"



          fi

          count=$((count+1))

        done

        ./create-proto.sh $table $DELIM "$TABLE_FIELD_SET" "$TABLE_META_SET"

      fi

    fi
    firstTable=1
    
done
    