@echo off

:: Author:      Christoffer Lilja, http://liljaonline.se/en/
:: Description: Script to start sharded mongodb environment on localhost
:: Credits:     Based on bash script from Andrew Erlichson from 10gen during mongo for java developers course
::              hosted by the same company.
::              Thanks to the tutor Jai Hirsch the script now uses --eval instead of external javascript files.
::              You can find his version at
::              https://github.com/JaiHirsch/mongodb-java-examples/blob/master/mongodb-java-examples/init_sharded_env.bat
:: Created:     2013-04-04
:: Modified:    2013-04-07 Now uses --eval instead of external .js files and changed log file names

:: Clean everything up
echo Killing mongod and mongos processes
taskkill /IM mongod.exe
taskkill /IM mongos.exe

echo.
echo Removing data files
rd /s /q c:\data\config
rd /s /q c:\data\shard

echo.
echo Creating db paths to dbs in the shard
mkdir c:\data\shard\shard0\dbrs7
mkdir c:\data\shard\shard0\dbrs8
mkdir c:\data\shard\shard0\dbrs9
mkdir c:\data\shard\shard1\dbrs10
mkdir c:\data\shard\shard1\dbrs11
mkdir c:\data\shard\shard1\dbrs12
mkdir c:\data\shard\shard2\dbrs13
mkdir c:\data\shard\shard2\dbrs14
mkdir c:\data\shard\shard2\dbrs15
mkdir c:\data\config\config-a
mkdir c:\data\config\config-b
mkdir c:\data\config\config-c

:: Start the shard

echo.
echo Start a replica set and tell it that it will be a shard0
start mongod --replSet s0 --logpath "c:/data/logs/dbrs7.log" --dbpath c:/data/shard/shard0/dbrs7 --port 37017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s0 --logpath "c:/data/logs/dbrs8.log" --dbpath c:/data/shard/shard0/dbrs8 --port 37018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s0 --logpath "c:/data/logs/dbrs9.log" --dbpath c:/data/shard/shard0/dbrs9 --port 37019 --shardsvr --logappend --smallfiles --oplogSize 100

:: Pause for 5 seconds (5+1 pings because the first return is immediate)
ping 127.0.0.1 -n 6 > nul 

mongo --port 37017 --eval "config = { _id: 's0', members:[{ _id : 0, host : 'localhost:37017' },{ _id : 1, host : 'localhost:37018' },{ _id : 2, host : 'localhost:37019' }]};rs.initiate(config);"

echo.
echo Start a replica set and tell it that it will be a shard1
start mongod --replSet s1 --logpath "c:/data/logs/dbrs10.log" --dbpath c:/data/shard/shard1/dbrs10 --port 47017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s1 --logpath "c:/data/logs/dbrs11.log" --dbpath c:/data/shard/shard1/dbrs11 --port 47018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s1 --logpath "c:/data/logs/dbrs12.log" --dbpath c:/data/shard/shard1/dbrs12 --port 47019 --shardsvr --logappend --smallfiles --oplogSize 100

:: Pause for 5 seconds (5+1 pings because the first return is immediate)
ping 127.0.0.1 -n 6 > nul

mongo --port 47017 --eval "config = { _id: 's1', members:[{ _id : 0, host : 'localhost:47017' },{ _id : 1, host : 'localhost:47018' },{ _id : 2, host : 'localhost:47019' }]};rs.initiate(config);"

echo.
echo Start a replica set and tell it that it will be a shard2
start mongod --replSet s2 --logpath "c:/data/logs/dbrs13.log" --dbpath c:/data/shard/shard2/dbrs13 --port 57017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s2 --logpath "c:/data/logs/dbrs14.log" --dbpath c:/data/shard/shard2/dbrs14 --port 57018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s2 --logpath "c:/data/logs/dbrs15.log" --dbpath c:/data/shard/shard2/dbrs15 --port 57019 --shardsvr --logappend --smallfiles --oplogSize 100

:: Pause for 5 seconds (5+1 pings because the first return is immediate)
ping 127.0.0.1 -n 6 > nul

mongo --port 57017 --eval "config = { _id: 's2', members:[{ _id : 0, host : 'localhost:57017' },{ _id : 1, host : 'localhost:57018' },{ _id : 2, host : 'localhost:57019' }]};rs.initiate(config);"

:: Create shard config servers
echo.
echo Creating or starting 3 config servers for the shard
start mongod --logpath "c:/data/logs/config-a.log" --dbpath c:/data/config/config-a --port 57040 --configsvr --logappend --smallfiles --oplogSize 100
start mongod --logpath "c:/data/logs/config-b.log" --dbpath c:/data/config/config-b --port 57041 --configsvr --logappend --smallfiles --oplogSize 100
start mongod --logpath "c:/data/logs/config-c.log" --dbpath c:/data/config/config-c --port 57042 --configsvr --logappend --smallfiles --oplogSize 100

:: Start mongos
echo.
echo Starting the mongos process
start mongos --logpath "c:/data/logs/mongos-1.log" --configdb localhost:57040,localhost:57041,localhost:57042 --logappend

:: Configure the shard and initiate a grades collection with shard key on student_id
echo.
echo Waiting 60 seconds for the replica sets to fully come online
ping 127.0.0.1 -n 61 > nul

mongo init_shard_config.js --eval "db.adminCommand( { addshard : 's0/'+'localhost:37017' } ); db.adminCommand( { addshard : 's1/'+'localhost:47017' } ); db.adminCommand( { addshard : 's2/'+'localhost:57017' } ); db.adminCommand({enableSharding: 'test'}); db.adminCommand({shardCollection: 'test.grades', key: {student_id:1}});"
