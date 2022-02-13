# exam-hive

## Introduction
This repository is a demo example of using Apache Hive to store and query from the <a href="https://datasets.imdbws.com">IMDB dataset</a>

## Setup
- Clone the repository (the files setup.sh, hive_db.sql et hive_query.sql must be in the same folder). 
- Give the rights to the file setup.sh to be able to launch it `$ chmod 777 setup.sh`.
- Launch the file setup.sh.

### setup.sh
The file will : 
- Download the necessassaries files for the containered version of hive (docker-compose.yaml and haddop-hive.env).
- Download the imdb dataset files.
- Create the database and the tables in Hive and populate them.
- Launch two queries on the database.

# Author
Nicolas Marquette