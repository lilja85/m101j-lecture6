:: Close the mongos
mongo < close_mongod.js
 
:: Shard0
mongo --port 37017 < close_mongod.js
mongo --port 37018 < close_mongod.js
mongo --port 37019 < close_mongod.js
 
:: Shard1
mongo --port 47017 < close_mongod.js
mongo --port 47018 < close_mongod.js
mongo --port 47019 < close_mongod.js
 
:: Shard2
mongo --port 57017 < close_mongod.js
mongo --port 57018 < close_mongod.js
mongo --port 57019 < close_mongod.js
 
:: Shard config
mongo --port 57040 < close_mongod.js
mongo --port 57041 < close_mongod.js
mongo --port 57042 < close_mongod.js
