M101j - Windows .bat files for lecture 6
==============

Windows equivalent of the bash scripts supplied by the tutor in M101J course lecture 6.

To install just download the files and run create_shard.bat in a command shel in windows. Edit the paths to
the db files if neccesary. I executed the script from another drive than c: and thats why I've added the c:\ part to
some of the lines in the script.

##Extra files

I also included some extra files.

**close_shard.bat**

Shutsdown the shard in a more neat way instead of just killing the processes. Also needs close_mongod.js to run

**start_shard.bat**

If the shard has already been created run this to start instead of recreate.
