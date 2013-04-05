@echo off

:: Author: Christoffer Lilja, http://liljaonline.se/en/
:: Description: Script to start sharded mongodb environment on localhost
:: Credits: Based on bash script from Andrew Erlichson from 10gen during
::          mongo for java developers course hosted by the same company

:: Notes:
:: I couldn't find an equivalent to embedding multiline strings into this
:: so I put the configutation sent to mongo in separate .js files. Download
:: all files and put them into the same directory and just run this .bat file

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
start mongod --replSet s0 --logpath "c:/data/logs/rsdb7.log" --dbpath c:/data/shard/shard0/dbrs7 --port 37017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s0 --logpath "c:/data/logs/rsdb8.log" --dbpath c:/data/shard/shard0/dbrs8 --port 37018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s0 --logpath "c:/data/logs/rsdb9.log" --dbpath c:/data/shard/shard0/dbrs9 --port 37019 --shardsvr --logappend --smallfiles --oplogSize 100

:: Pause for 5 seconds (5+1 pings because the first return is immediate)
ping 127.0.0.1 -n 6 > nul 

mongo --port 37017 < init_shard_0.js

echo.
echo Start a replica set and tell it that it will be a shard1
start mongod --replSet s1 --logpath "c:/data/logs/rsdb10.log" --dbpath c:/data/shard/shard1/dbrs10 --port 47017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s1 --logpath "c:/data/logs/rsdb11.log" --dbpath c:/data/shard/shard1/dbrs11 --port 47018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s1 --logpath "c:/data/logs/rsdb12.log" --dbpath c:/data/shard/shard1/dbrs12 --port 47019 --shardsvr --logappend --smallfiles --oplogSize 100

:: Pause for 5 seconds (5+1 pings because the first return is immediate)
ping 127.0.0.1 -n 6 > nul

mongo --port 47017 < init_shard_1.js

echo.
echo Start a replica set and tell it that it will be a shard2
start mongod --replSet s2 --logpath "c:/data/logs/rsdb13.log" --dbpath c:/data/shard/shard2/dbrs13 --port 57017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s2 --logpath "c:/data/logs/rsdb14.log" --dbpath c:/data/shard/shard2/dbrs14 --port 57018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s2 --logpath "c:/data/logs/rsdb15.log" --dbpath c:/data/shard/shard2/dbrs15 --port 57019 --shardsvr --logappend --smallfiles --oplogSize 100

:: Pause for 5 seconds (5+1 pings because the first return is immediate)
ping 127.0.0.1 -n 6 > nul

mongo --port 57017 < init_shard_2.js

:: Create shard config servers
echo.
echo Creating or starting 3 config servers for the shard
start mongod --logpath "c:/data/logs/cfg-a.log" --dbpath c:/data/config/config-a --port 57040 --configsvr --logappend --smallfiles --oplogSize 100
start mongod --logpath "c:/data/logs/cfg-b.log" --dbpath c:/data/config/config-b --port 57041 --configsvr --logappend --smallfiles --oplogSize 100
start mongod --logpath "c:/data/logs/cfg-c.log" --dbpath c:/data/config/config-c --port 57042 --configsvr --logappend --smallfiles --oplogSize 100

:: Start mongos
echo.
echo Starting the mongos process
start mongos --logpath "c:/data/logs/mongos-1.log" --configdb localhost:57040,localhost:57041,localhost:57042 --logappend

:: Configure the shard and initiate a grades collection with shard key on student_id
echo.
echo Waiting 60 seconds for the replica sets to fully come online
ping 127.0.0.1 -n 61 > nul

mongo init_shard_config.js
