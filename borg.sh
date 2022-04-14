#!/bin/bash
export BORG_PASSCOMMAND="cat /path/to/borgpass"
SSHPASSFILE=/path/to/sshpasswordfile
BORGSERVER=ssh://user@ip:port
PATTERN=id_ed25519
REMOTEPATH=/path/to/remote/borg
BACKUPNAME=backupname

if  [[ $1 == "list" ]]
then
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg list $BORGSERVER$REMOTEPATH
elif [[ $1 == "data" ]]
then
   if [[ -z "$2" ]]
   then
       echo "Archive name not provided!"
       exit 22
   fi
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg list $BORGSERVER$REMOTEPATH::$2
elif [[ $1 == "create" ]]
then
sshpass -v -f $SSHPASSFILE -P $PATTERN borg create -p --stats --compression zstd,15 --exclude='/dev' --exclude='/proc' --exclude='/sys' --exclude='/tmp' --exclude='/run' --exclude='/mnt' --exclude='/media' --exclude='/lost+found' --exclude='/bin' --exclude='/boot' --exclude='/lib' --exclude='/lib32' --exclude='/lib64' --exclude='/libx32' --exclude='/srv' --exclude='/sys' --exclude='/usr' $BORGSERVER$REMOTEPATH::$BACKUPNAME-{now:%Y-%m-%dT%H:%M:%S} '/'
elif [[ $1 == "delete" ]]
then
   if [[ -z "$2" ]]
   then
       echo "Archive name not provided!"
       exit 22
   fi
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg delete $BORGSERVER$REMOTEPATH::"$2" --stats -p
elif [[ $1 == "extract" ]]
then
   if [[ -z "$2" ]]
   then
       echo "Archive name not provided!"
       exit 22
   fi
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg extract $BORGSERVER$REMOTEPATH::"$2" --stats -p
else
   echo "No arguments supplied!"
fi
