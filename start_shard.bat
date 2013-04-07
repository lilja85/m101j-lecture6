@echo off

:: Create 3 shard replica sets with --shardsvr
echo.
echo starting the replica set for shard 0
start mongod --replSet s0 --logpath "c:/data/logs/dbrs7.log" --dbpath c:/data/shard/shard0/dbrs7 --port 37017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s0 --logpath "c:/data/logs/dbrs8.log" --dbpath c:/data/shard/shard0/dbrs8 --port 37018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s0 --logpath "c:/data/logs/dbrs9.log" --dbpath c:/data/shard/shard0/dbrs9 --port 37019 --shardsvr --logappend --smallfiles --oplogSize 100

echo.
echo Starting the replica set for shard 1
start mongod --replSet s1 --logpath "c:/data/logs/dbrs10.log" --dbpath c:/data/shard/shard1/dbrs10 --port 47017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s1 --logpath "c:/data/logs/dbrs11.log" --dbpath c:/data/shard/shard1/dbrs11 --port 47018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s1 --logpath "c:/data/logs/dbrs12.log" --dbpath c:/data/shard/shard1/dbrs12 --port 47019 --shardsvr --logappend --smallfiles --oplogSize 100

echo.
echo Starting the replica set for shard 2
start mongod --replSet s2 --logpath "c:/data/logs/dbrs13.log" --dbpath c:/data/shard/shard2/dbrs13 --port 57017 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s2 --logpath "c:/data/logs/dbrs14.log" --dbpath c:/data/shard/shard2/dbrs14 --port 57018 --shardsvr --logappend --smallfiles --oplogSize 100
start mongod --replSet s2 --logpath "c:/data/logs/dbrs15.log" --dbpath c:/data/shard/shard2/dbrs15 --port 57019 --shardsvr --logappend --smallfiles --oplogSize 100

:: Create shard config servers
echo.
echo Starting 3 config servers for the shard
start mongod --logpath "c:/data/logs/config-a.log" --dbpath c:/data/config/config-a --port 57040 --configsvr --logappend --smallfiles --oplogSize 100
start mongod --logpath "c:/data/logs/config-b.log" --dbpath c:/data/config/config-b --port 57041 --configsvr --logappend --smallfiles --oplogSize 100
start mongod --logpath "c:/data/logs/config-c.log" --dbpath c:/data/config/config-c --port 57042 --configsvr --logappend --smallfiles --oplogSize 100

:: Start mongos
echo.
echo Starting the mongos process
start mongos --logpath "c:/data/logs/mongos-1.log" --configdb localhost:57040,localhost:57041,localhost:57042 --logappend
