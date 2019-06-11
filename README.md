# zabbix-nakivo
Zabbix Template to check Nakivo Backup &amp; Replication with external script
- 1 Discovery rule for jobs.
- 2 Disocery Items, "state" and "last result"
Tested on Zabbix 4.0.9 with debian 9.

## Requierment
Perl + Perl Library JSON and File::Basename

## Installation
1. copy the nakivo.pl file to the zabbix external scripts folder and allow execution (chmod +x nakivo.pl)
2. set correct value for NAKIVO_USER and NAKIVO_PWD variable in nakivo.pl (line 22 and line 23)
3. get your nakivo cli.sh and cli.jar based on https://helpcenter.nakivo.com/display/NH/Using+Command+Line+Interface and copy it to the zabbix external scripts folder
4. import zbx_export_templates_nakivo.xml

## Usage
1. Create a host with agent interface ip pointing to naktivo server ip
2. assign template "nakivo" to host
3. have fun

## Tests
nakivo.pl <IP> --job-list
{
        "data":[

        {
                "{#ID}":"35",
                "{#NAME}":"VM Backup"
        }

        ]
}


## Notice
Tested with nakivo 8.5.2.32767. On some older version the API call with cli.jar were to slow (>30 sec) and this caused the agent to terminate to early.
Feel free to post some feedback.