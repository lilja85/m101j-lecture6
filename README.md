M101J - Windows .bat files for lecture 6
==============

Windows equivalent of the bash scripts supplied by the tutor in M101J course lecture 6.

To install the shard just download the files and run create_shard.bat in a command shell in windows. Edit the paths
to the db files if necessary. I executed the script from another drive than c: and thats why I've added the c:\ part
to some of the lines in the script.

Those of you who did not go trough the course at https://education.10gen.com/ during spring 2013 and still want to
try and run this need to install mongodb from http://www.mongodb.org/. This version was tested with mongodb 2.2.3
and to run this script you need the path to your mongodb bin folder in the windows system PATH variable.

##Extra files

I also included some extra files.

[**close_shard.bat**](https://github.com/lilja85/m101j-lecture6/blob/master/close_shard.bat)

Shutdown the shard in a more neat way instead of just killing the processes. Also needs close_mongod.js to run

[**start_shard.bat**](https://github.com/lilja85/m101j-lecture6/blob/master/start_shard.bat)

If the shard has already been created run this to start instead of recreating the whole environment with
create_shard.bat.

##Disclaimer
This project is provided "as is". It has not been properly tested and there is no official support for it provided
by anyone (especially not by 10gen). It is intended for M101J's students using windows.
