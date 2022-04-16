# Borg.sh ⚡️
Script made for managing borg backups in a simple way!

## Prerequisites
This script works in a borg setup made of:
- keyfile-blake2/sha256 initiated repository
- SSH key protected with a password, either id_ed25519 or id_rsa, used to access via SSH
- sshpass package installed in the client

# Setup
There are 6 variables that need to be set to make the script work correctly.
### `BORG_PASSCOMMAND`
It's a flag used by borg itself. The variable contains the file location where the borg password is stored.

### `SSHPASSFILE`
The variable contains the file location where the SSH key password is stored.

### `BORGSERVER`
The variable contains the the remote host that borg will connect to.
The only things that need to be changed are:
- `user`
- `ip`
- `port`
### ⚠️ DO NOT ADD THE / AT THE END! ⚠️

### `REMOTEPATH`
The variable contains the abosolute path of the remote borg repository.
Example: `/storage/user1/backups/borgrepo`
### ⚠️ DO NOT ADD THE / AT THE END! ⚠️

### `PATTERN`
This variable contains what pattern will sshpass look for before sending the password contained in the file specified in `SSHPASSFILE`<br>
Probably the two most common options will be id_ed25519 and id_rsa, depending on the type of the SSH key

### `BACKUPNAME`
This variable contains the name of the backup followed by the current date separated with a -.<br> 
The date is used to identify backups by the time of their creation.

# Commands
In this script you can find 7 different commands that are specified as an argument. It doesn't require any arguments
### `./borg.sh list`
This command allows you to list all the backups made to the borg repository. 

### `./borg.sh data`
This command allows you to list the files contained in a specific backup. Requires the name of the backup as second argument.<br>
Example: `./borg.sh data BackupName`

### `./borg.sh create`
This command allows you to create a backup compressed with zstd at level 15. Find more about compression [here.](https://borgbackup.readthedocs.io/en/stable/internals/data-structures.html#compression)<br>
It doesn't require any arguments. By default it backups the / directory by excluding the following directories:
- /dev
- /proc
- /sys
- /tmp
- /run
- /mnt
- /media
- /lost+found
- /bin
- /boot
- /lib
- /lib32
- /lib64
- /libx32
- /srv
- /sys
- /usr

### `./borg.sh delete`
This command allows you to delete a backup from the borg repository. Requires the name of the backup as second argument.<br>
Example: `./borg.sh delete BackupName`

### `./borg.sh extract`
This command allows you to extract a backup from the borg repository to the current folder. Requires the name of the backup as second argument.<br>
Example: `./borg.sh extract BackupName`

### `./borg.sh check`
This command allows you to check the integrity of a repository. It doesn't require any arguments.<br>
By default `--verify-data` options is enabled. It takes more time but it's the safest option for intergrity check.

### `./borg.sh checkarch`
This command allows you to check the integrity of a backup archive. It requires the name of the backup.<br>
By default `--verify-data` options is enabled. It takes more time but it's the safest option for intergrity check.<br>
Example: `./borg.sh checkarch BackupName`

# **This is FREE software and i don't take responsability on whatever you do with this!**
