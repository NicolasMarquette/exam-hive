#!/bin/bash

folder_path="$(dirname "${BASH_SOURCE[0]}")"

# Function to a time counter
time_count() {
    secs=$1
    while [ $secs -gt 0 ]; do
    echo -ne "wait $secs seconds\033[0K\r"
    sleep 1
    : $((secs--))
    done
}

# Create the folder data if not exist.
if [[ ! -d "$folder_path/data" ]]
then
    mkdir $folder_path/data
    echo -e "\nFolder data created."
fi

# Download the docker-compose.yml file if not exist.
if [[ ! -f "$folder_path/docker-compose.yml" ]]
then
    wget -q https://dst-de.s3.eu-west-3.amazonaws.com/hadoop_hive_fr/docker-compose.yml \
    -O $folder_path/docker-compose.yml
    echo -e "\nFile docker-compose.yml downloaded."
fi

# Download the hadoop-hive environment file if not exist.
if [[ ! -f "$folder_path/hadoop-hive.env" ]]
then
    wget -q https://dst-de.s3.eu-west-3.amazonaws.com/hadoop_hive_fr/hadoop-hive.env \
    -O $folder_path/hadoop-hive.env
    echo -e "\nFile hadoop-hive.env downloaded."
fi

# Downloading the data files
for file in $(curl -s https://datasets.imdbws.com/ |
                grep https*[a-zA-Z].*gz\> |
                cut -d '>' -f 3 |
                cut -d '<' -f 1); do
    if [[ ! -f "$folder_path/data/$file" ]]
    then 
        echo -e "\nDownloading files $file..."
        wget -q https://datasets.imdbws.com/$file \
        -O $folder_path/data/$file
        echo "$file download completed."
    fi
done

# Move the sql db script to data.
if [[ -f "$folder_path/hive_db.sql" ]]
then 
    mv $folder_path/hive_db.sql $folder_path/data/
    echo -e "\nhive_db.sql moved in the folder data."
elif [[ -f "$folder_path/data/hive_db.sql" ]]
then 
    echo -e "\nhive_db.sql is already in the folder data."
else
    echo -e "\nError: hive_db.sql don't exist."
    exit
fi

# Move the sql query script to data.
if [[ -f "$folder_path/hive_query.sql" ]]
then 
    mv $folder_path/hive_query.sql $folder_path/data/
    echo -e "\nhive_query.sql moved in the folder data."
elif [[ -f "$folder_path/data/hive_query.sql" ]]
then 
    echo -e "\nhive_query.sql is already in the folder data."
else
    echo -e "\nError: hive_query.sql don't exist."
    exit
fi

# Go to the script folder.
cd $folder_path

# Launch the containers for Hive.
echo -e "\nLaunching the docker-compose..."
docker-compose up -d > /dev/null

echo -e "\nWaiting for the database to launch..."
time_count 40

# Execute the hive db script in the container.
echo -e "\nCreation of the database and tables..."
docker exec hive-server bash -c "hive -f /data/hive_db.sql"
echo -e "\nCreation terminated."

echo -e "\nWait 20 seconds before database queries..."
time_count 20

# Execute the hive query script in the container.
echo -e "\nQueries the database..."
docker exec hive-server bash -c "hive -S -f /data/hive_query.sql"
echo -e "\nQuery done !"
