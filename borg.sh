#!/bin/bash
export BORG_PASSCOMMAND="cat /path/to/borgpass"
SSHPASSFILE=/path/to/sshpasswordfile
BORGSERVER=ssh://user@ip:port
PATTERN=id_ed25519
REMOTEPATH=/path/to/remote/borg
BACKUPNAME=backupname

arg2err () {
   if [[ -z "$2" ]]
   then
       echo "Archive name not provided!"
       exit 2
   fi
}

if  [[ $1 == "list" ]]
then
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg list $BORGSERVER$REMOTEPATH
elif [[ $1 == "data" ]]
then
   arg2err
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg list $BORGSERVER$REMOTEPATH::$2
elif [[ $1 == "create" ]]
then
sshpass -v -f $SSHPASSFILE -P $PATTERN borg create -p --stats --compression zstd,15 --exclude='/dev' --exclude='/proc' --exclude='/sys' --exclude='/tmp' --exclude='/run' --exclude='/mnt' --exclude='/media' --exclude='/lost+found' --exclude='/bin' --exclude='/boot' --exclude='/lib' --exclude='/lib32' --exclude='/lib64' --exclude='/libx32' --exclude='/srv' --exclude='/sys' --exclude='/usr' $BORGSERVER$REMOTEPATH::$BACKUPNAME-{now:%Y-%m-%dT%H:%M:%S} '/'
elif [[ $1 == "delete" ]]
then
   arg2err
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg delete $BORGSERVER$REMOTEPATH::$2 --stats -p
elif [[ $1 == "extract" ]]
then
   arg2err
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg extract $BORGSERVER$REMOTEPATH::$2 --stats -p
elif [[ $1 == "check" ]]
then
   retVal=$?
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg check $BORGSERVER$REMOTEPATH -p --verify-data
   if [[ $retVal -eq 1 ]]
   then
       echo "Borg check completed. There are errors, exit code: "$retVal
       exit 1
   else
       echo "Borg check completed. No errors, exit code: "$retVal
   fi
elif [[ $1 == "checkarch" ]]
then
   retVal=$?
   arg2err
   sshpass -v -f $SSHPASSFILE -P $PATTERN borg check $BORGSERVER$REMOTEPATH::$2 -p --verify-data
   if [[ $retVal -eq 1 ]]
   then
       echo "Borg checkarch completed. There are errors, exit code: "$retVal
       exit 1
   else
        echo "Borg checkarch completed. No errors, exit code: "$retVal
   fi
else
   echo "No arguments supplied!"
fi
