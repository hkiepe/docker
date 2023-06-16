<!-- TABLE OF CONTENTS -->

#readme-top

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <ul>
            <li><a href="#Environment variables">Environment variables</a></li>
            <li><a href="#Timer units">Timer units</a></li>
            <li><a href="#Timer units">Mount options for CIFS Share</a></li>
        </ul>
      </ul>
    </li>
    <li>
      <a href="#restore-the-backup">Restore the Backup</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <ul>
            <li><a href="#Environment variables">Environment variables</a></li>
            <li><a href="#Timer units">Timer units</a></li>
            <li><a href="#Timer units">Mount options for CIFS Share</a></li>
        </ul>
      </ul>
    </li>
    <li><a href="#use-docker">Use Docker</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

A script to reate backups in the Frankfurt SDI environment.

| Notation | Hostname                                  | ip             | Shortcut in ssh config |
| -------- | ----------------------------------------- | -------------- | ---------------------- |
| PROD_DB  | sgdem0011548.con-02.emea.dc.corpintra.net | 53.136.162.121 | p-db-sdi               |
| INT_DB   | sgdem0011549.con-02.emea.dc.corpintra.net | 53.136.156.184 | i-db-sdi               |
| DEV_DB   | sgdem0011547.con-02.emea.dc.corpintra.net | 53.136.154.8   | d-db-sdi               |

The script takes care about:

- creating the backups,
- cleanup old backups and
- cleanup the transaction log files
- writes the status of all processes into a logfile
- measure the time the backup needs to be created

There are view variables available which can be set in the db users profile to set:

- database name
- backup directory path
- logfile path
- path to the db2 backup command
- days to keep the backup
- days to keep the transaction logs
- days to keep the archived transaction logs

The backup script can be executed directly or using a service unit on the backup machine

Path to the stored backups:

```sh
/swan/db/backup/{MACHINE_NAME}
```

Path to the logfiles:

```sh
/srv/db2/var/log/{db2backup-YEAR.log}
```

<!-- GETTING STARTED -->

## Getting Started

This is an example how you can settup the script.
To get the script up and running follow these simple steps below.

### Prerequisites

This is an example of things you need to prepare to install the script.

- you should have a IBM DB2, SWAN database running on the server.
- The CIFS shere where the backups are stored should be mounted with the same user which executes the script, to ensure the backup files are propperly stored and accesible.

### Installation

Copy the files from your local computer to the remote machine. Assumed on your local machine you are in the script folder the command to shift the files to the <b>PROD</b> environment is:

```sh
scp -r db2_backup_script p-db-sdi:/tmp
```

On the remote machine change to the root user with <b>sudo -i</b>. Now you can move the files to the folder where you want to store the script.
The script can be saved in the home directory of the user which executes the script in the "bin" folder.

```sh
mv /tmp/db2_backup_script/ /srv/db2/home/db2swan/bin/
```

Because the location where the backups will be saved is mounted as user <b>db2swan</b> its important to execute the script as the same user.
Make sure the owner and group for the script files is set to db2swan. The following command will set the apropriate user rights for the script files recursively.

```sh
chown -R db2swan:db2swan /srv/db2/home/db2swan/bin/db2_backup_script
```

Login as user db2swan and create the folder for the logfile:

```sh
su - db2swan
mkdir /srv/db2/var/log
```

#### Environment variables

To configure parameters and settings the sipt needs to run in the specific environment you should add some information in the <b>db2 user profile</b> of the executing user.
For example the user profile of the <b>db2swan</b> user you can find here:

```sh
vim /srv/db2/home/db2swan/sqllib/db2profile
```

Make the changes according to the variables in the file [db2profile.env](https://git.ssc-services.de/SWAN-Operations/operating-specials/-/blob/master/db2_backup_script/utils/db2profile.env). You can change the settings according to your needs. To apply the changes to the user environment variables you have to log off from this user and log in to the user agian.

#### Timer units

You can choose to use timer units to run the script periodically. For this script i propose to use a timer unit to configure the time when the script should be executed and a service unit which defines the command to run the script. Bot files you can find here:
[db2backup.timer](https://git.ssc-services.de/SWAN-Operations/operating-specials/-/blob/master/db2_backup_script/utils/systemd/db2backup.timer)
[db2backup.service](https://git.ssc-services.de/SWAN-Operations/operating-specials/-/blob/master/db2_backup_script/utils/systemd/db2backup.service)

Adopt the execution time and command to run the script to your needs. Both files can be placed in the folder "/etc/systemd/system" with appropriate user rights

```sh
-rw-r--r-- 1 root root 275 May 26 15:34 /etc/systemd/system/db2backup.service
-rw-r--r-- 1 root root 198 May 31 16:12 /etc/systemd/system/db2backup.timer
```

After changing the units reload the daemon:

```sh
systemctl daemon-reload
```

Start the timer:

```sh
systemctl start db2backup.timer
```

Enable the timer to be started automatically

```sh
systemctl enable db2backup.timer
```

You can stop the timer with:

```sh
systemctl stop db2backup.timer
```

You can check the status of the units with:

```sh
systemctl status db2backup.timer
systemctl status db2backup.service
```

#### Mount options for CIFS Share

If the CIFS share is not mounted as the same user which creates the database backup the backup will fail. The solution is to change the user which mounts the share to the user which executes the backup script. The user Id of the db2 user you can check with:

```sh
cat /etc/passwd | grep db2swan
```

You can edit the user to mount the share in this file:

```sh
vim /etc/systemd/system/swan-db-backup.mount
```

Now in swan-db-backup.mount edit the user id to the new one in this line:

```sh
Options=vers=3,credentials=/root/cifscred,iocharset=utf8,seal,noauto,uid=904,gid=904,dir_mode=0750,file_mode=0750
```

Afterwards load the system unit and the automount unit

```sh
systemctl daemon-reload
systemctl restart swan-db-backup.automount
```

<!-- DB2 SPECIFIC -->

## DB2 Specific commands

If an error ocures during backup there will be db2 specific error messages created. You can check the error description by entering the following command with db2 error number:

```sh
db2 ? <db2_error_number>
```

<!-- SALT IMPLEMENTATION -->

## SALT implementation

The conficuration for SALT you can find in the following files:

Store script files and assign settings

```sh
https://git.ssc-services.de/saltstack/salt-states/-/blob/DAS-1688/swan-server/db2/full-hardening-install.sls
```

Settings for CIFS share

```sh
https://git.ssc-services.de/saltstack/mercedes-benz-pillars/-/blob/master/setups/db.sls
```

Example for some defined values which are inserted into the backup script

```sh
https://git.ssc-services.de/saltstack/salt-states/-/blob/master/swan-server/map.jinja
```

Script file

```sh
https://git.ssc-services.de/saltstack/salt-states/-/blob/master/swan-server/db2/files/DB2_backup.sh.jinja
```

## Use Docker

<!-- USE DOCKER -->

Show current docker version on your machine

```sh
docker version
```

The command returns information about the docker client (cli) and the docker server (engine) which is running as a deamon/service on your machine. The cli is talking to the engine and then the cli returns the values whic it gots from the engine. Make sure you have the latest versions as possible installed.

Show configuration information for the engine

```sh
docker info
```

Show a list of docker commands.

```sh
docker
```

At the top of the list you will see the management commands. So you can use the management command format.

```sh
docker <command> <sub-command> (options)
```

<!-- IMAGE VS CONTAINER -->

### Difference between image and container

<ol>
    <ul>
        <li>
            An image is the application we want to run
        </li>
        <li>
            A container ist the instance of that image running as a process
        </li>
        <li>
            You can have many containers running off the same image
        </li>
        <li>
            Dockers default image "registry" is called Docker Huib [(hub.docker.com)](https://hub.docker.com/)
        </li>
    </ul>
</ol>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->

## Roadmap

- [x] Check if disk space on CIFS share is sufficient before running the backup command
- [ ] Logfile monitoring with grafana
  - [ ] Specify requirements
  - [ ] display errors in grafana
  - [ ] display succesfull backups
- [ ] Write instruction how to restore db2 backup

See the [open issues](https://git.ssc-services.de/SWAN-Operations/operating-specials/-/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->

## License

Distributed under the XXX. See `XXXLICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

Henrik Kiepe - hkiepe@ssc-services.de

Project Link: [https://git.ssc-services.de/SWAN-Operations/operating-specials/-/tree/master/db2_backup_script](https://git.ssc-services.de/SWAN-Operations/operating-specials/-/tree/master/db2_backup_script)

<p align="right">(<a href="#readme-top">back to top</a>)</p>
