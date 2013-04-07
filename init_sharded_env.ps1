<#
	Author: Christoffer Lilja, http://liljaonline.se/en/
	Description: Script to start sharded mongodb environment on localhost
	Created: 2013-04-06
	Modified:
		2013-04-07	Replaced md with New-Item.
					Removed some verbose errors like no mongod processes found to kill
					Corrected the folder paths to shard1 and shard2
	Credits: Based on bash script from Andrew Erlichson from 10gen during
	         mongo for java developers course hosted by the same company

	Notes:
	This is pretty much the same script as provided by the tutor but I print
	the commands used to start all mongod and the mongos. If you don't wan't
	them just replace the "Select-Object Command" with "Out-Null"
	
	If you have not run any powershell script before you will most likely have
	to allow them. I did it by entering "Set-ExecutionPolicy  Unrestricted" in
	a powershell console run as an administrator.
#>

# clean everything up
Write-Host "Killing mongod and mongos processes"
Get-Process mongod -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process mongos -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "Removing data files"
Remove-Item "c:\data\config" -Recurse -Force -ErrorAction SilentlyContinue 
Remove-Item "c:\data\shard" -Recurse -Force -ErrorAction SilentlyContinue


Write-Host "start a replica set and tell it that it will be a shard0"
New-Item -Path "c:/data/shard/shard0/dbrs7", "c:/data/shard/shard0/dbrs8", "c:/data/shard/shard0/dbrs9" -Type directory -Force | Out-Null
Start-Job { mongod --replSet "s0" --logpath "c:/data/logs/dbrs7.log" --dbpath "c:/data/shard/shard0/dbrs7" --port 37017 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --replSet "s0" --logpath "c:/data/logs/dbrs8.log" --dbpath "c:/data/shard/shard0/dbrs8" --port 37018 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --replSet "s0" --logpath "c:/data/logs/dbrs9.log" --dbpath "c:/data/shard/shard0/dbrs9" --port 37019 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command

# connect to one server and initiate the set
Start-Sleep -s 5
@"
config = { _id: "s0", members:[
	      { _id : 0, host : "localhost:37017" },
	      { _id : 1, host : "localhost:37018" },
	      { _id : 2, host : "localhost:37019" }]};
rs.initiate(config)
"@ | mongo --port 37017


Write-Host " start a replica set and tell it that it will be a shard1"
New-Item -Path "c:/data/shard/shard1/dbrs10", "c:/data/shard/shard1/dbrs11", "c:/data/shard/shard1/dbrs12" -Type directory -Force | Out-Null
Start-Job { mongod --replSet "s1" --logpath "c:/data/logs/dbrs10.log" --dbpath "c:/data/shard/shard1/dbrs10" --port 47017 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --replSet "s1" --logpath "c:/data/logs/dbrs11.log" --dbpath "c:/data/shard/shard1/dbrs11" --port 47018 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --replSet "s1" --logpath "c:/data/logs/dbrs12.log" --dbpath "c:/data/shard/shard1/dbrs12" --port 47019 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command

# connect to one server and initiate the set
Start-Sleep -s 5
@"
config = { _id: "s1", members:[
          { _id : 0, host : "localhost:47017" },
          { _id : 1, host : "localhost:47018" },
          { _id : 2, host : "localhost:47019" }]};
rs.initiate(config)
"@ | mongo --port 47017


Write-Host "start a replica set and tell it that it will be a shard2"
New-Item -Path "c:/data/shard/shard2/dbrs13", "c:/data/shard/shard2/dbrs14", "c:/data/shard/shard2/dbrs15" -Type directory -Force | Out-Null
Start-Job { mongod --replSet "s2" --logpath "c:/data/logs/dbrs13.log" --dbpath "c:/data/shard/shard2/dbrs13" --port 57017 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --replSet "s2" --logpath "c:/data/logs/dbrs14.log" --dbpath "c:/data/shard/shard2/dbrs14" --port 57018 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --replSet "s2" --logpath "c:/data/logs/dbrs15.log" --dbpath "c:/data/shard/shard2/dbrs15" --port 57019 --shardsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command

# connect to one server and initiate the set
Start-Sleep -s 5
@"
config = { _id: "s2", members:[
          { _id : 0, host : "localhost:57017" },
          { _id : 1, host : "localhost:57018" },
          { _id : 2, host : "localhost:57019" }]};
rs.initiate(config)
"@ | mongo --port 57017


# now start 3 config servers
md "c:/data/config/config-a", "c:/data/config/config-b", "c:/data/config/config-c" -Force | Out-Null
Start-Job { mongod --logpath "c:/data/logs/config-a.log" --dbpath "c:/data/config/config-a" --port 57040 --configsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --logpath "c:/data/logs/config-b.log" --dbpath "c:/data/config/config-b" --port 57041 --configsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command
Start-Job { mongod --logpath "c:/data/logs/config-c.log" --dbpath "c:/data/config/config-c" --port 57042 --configsvr --logappend --smallfiles --oplogSize 100 } | Select-Object Command


# now start the mongos on a standard port
Start-Job { mongos --logpath "c:/data/logs/mongos-1.log" --configdb "localhost:57040,localhost:57041,localhost:57042" --logappend } | Select-Object Command

Write-Host "Waiting 60 seconds for the replica sets to fully come online"
Start-Sleep -s 60
Write-Host "Connnecting to mongos and enabling sharding"

# add shards and enable sharding on the test db
@"
db.adminCommand( { addshard : "s0/"+"localhost:37017" } );
db.adminCommand( { addshard : "s1/"+"localhost:47017" } );
db.adminCommand( { addshard : "s2/"+"localhost:57017" } );
db.adminCommand({enableSharding: "test"})
db.adminCommand({shardCollection: "test.grades", key: {student_id:1}});
"@ | mongo
