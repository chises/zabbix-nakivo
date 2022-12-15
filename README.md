# zabbix-nakivo
Zabbix Template to check Nakivo Backup &amp; Replication with external script
- Discovery rule for all jobs
- 5 Minute Update interval
- single API command to gather all items and values
- Trigger severity average on last result not "Successful"
- Trigger severity information on running jobs

Tested on Zabbix 6.2.4 with debian 11.

## Requirement
**JAVA that is comptible with Nakivo cli.jar file**
Tested with java -version: 
```
openjdk version "1.8.0_292"
OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_292-b10)
OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.292-b10, mixed mode)
```

Installed with the following on Debian 11:
```
apt install apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common -y
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
apt update
apt install adoptopenjdk-8-hotspot -y
```

## Installation
1. get your nakivo cli.sh and cli.jar based on https://helpcenter.nakivo.com/display/NH/Using+Command+Line+Interface and copy it to the zabbix external scripts folder
2. copy the *nakivo.sh* file to the zabbix external scripts folder and allow execution (chmod +x nakivo.sh)
3. adjust path to cli.sh in file nakivo.sh if it is not */usr/lib/zabbix/externalscripts/cli.sh*
4. import template to zabbix
5. increase script timeout on server/proxy to 10 seconds

## Testing
Run nakivo.sh on the zabbix server or proxy with 3 paramters: nakivo server ip, nakivo user, nakivo password
```
/usr/lib/zabbix/externalscripts/nakivo.sh <IP> <user> '<password>'
ID,Name,State,Last run
69,copy to nas01,Running. 67.0%,Successful
33,Backup,Scheduled,Successful
108,recover data,On demand,Successful
109,recover from nas01,On demand,Successful
107,recover_all,On demand,Stopped (3 VM successful. 0 VM failed. 2 VM stopped)
```

## Usage
1. Create a host with agent interface ip pointing to naktivo server ip
2. assign template "nakivo" to host
3. adjust tempalte macros {$NAKIVOPASSWORD} and {$NAKIVOUSER} with a valid nakivo user


## Notice
Tested with nakivo 10.7.2