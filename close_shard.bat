@echo off

:: Close the mongos
echo.
echo Shutting down mongos.exe
echo.

mongo < close_mongod.js

:: Shard config servers
echo Shutting down shard configuration
mongo --port 57040 < close_mongod.js
mongo --port 57041 < close_mongod.js
mongo --port 57042 < close_mongod.js

:: Shard0
echo Shutting down shard 0
mongo --port 37017 < close_mongod.js
mongo --port 37018 < close_mongod.js
mongo --port 37019 < close_mongod.js

:: Shard1
echo Shutting down shard 1
mongo --port 47017 < close_mongod.js
mongo --port 47018 < close_mongod.js
mongo --port 47019 < close_mongod.js

:: Shard2
echo Shutting down shard 2
mongo --port 57017 < close_mongod.js
mongo --port 57018 < close_mongod.js
mongo --port 57019 < close_mongod.js

echo.
echo All mongod and mongos processes for the shard environment should now have been taken down
echo.
