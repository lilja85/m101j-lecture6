@echo off

:: Close the mongos
echo.
echo Shutting down mongos.exe
echo.

mongo "localhost/admin" --eval "db.shutdownServer();"

:: Shard config servers
echo Shutting down shard configuration
mongo "localhost:57040/admin" --eval "db.shutdownServer();"
mongo "localhost:57041/admin" --eval "db.shutdownServer();"
mongo "localhost:57042/admin" --eval "db.shutdownServer();"

:: Shard0
echo Shutting down shard 0
mongo "localhost:37017/admin" --eval "db.shutdownServer();"
mongo "localhost:37018/admin" --eval "db.shutdownServer();"
mongo "localhost:37019/admin" --eval "db.shutdownServer();"

:: Shard1
echo Shutting down shard 1
mongo "localhost:47017/admin" --eval "db.shutdownServer();"
mongo "localhost:47018/admin" --eval "db.shutdownServer();"
mongo "localhost:47019/admin" --eval "db.shutdownServer();"

:: Shard2
echo Shutting down shard 2
mongo "localhost:57017/admin" --eval "db.shutdownServer();"
mongo "localhost:57018/admin" --eval "db.shutdownServer();"
mongo "localhost:57019/admin" --eval "db.shutdownServer();"

echo.
echo All mongod and mongos processes for the shard environment should now have been taken down
echo.
