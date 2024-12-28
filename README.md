# Honeypots
Some Honeypot Technologies to tarpit, confuse, distract, and detect attackers on the network they are deployed.

Disclaimer: Be sure you gain prior authoriziation before setting up any of these services or using any of the scripts here. Understand the potential effects of setting one of these systems up and blocking people who are trying to access systems legitimately or for research. A good example of this would be to make sure you will not inadvertently take up resources of legitimate webcrawlers that are indexing websites when deploying something like spidertrap or a script like that. The scripts here are provided as is without warrenty use at your own risk and discression.

## Honeyport.sh
This is a super simple script to log and block an attacker from accessing a system when they do a full connect to the system. Really annoying if your an attacker but even worse if its not configured correctly and or logs are not going to a SIEM. This is most effective when used on a well known but not used port on the system. Note that only full TCP connections will be logged and blocked, UDP may also be something you want to play around with too.

## Honeyport.ps1
This script will detect and log connections to port 8080 it must be run as administrator and will not run otherwise. Logs are saved by default to the C:\Logs\HoneyPortLog.txt file. The firewall rules are marked as "Honeyport Blocked IP $IPAddress" where $IPAddress is the ip address of the blocked host. This allows for a second script to run through and delete enteries that may have blocked legitimate hosts.

## Tarport.sh
This one actually involves compiling the c file found under the name of bonk.c, respect the bonk. How this one works is very similar to the utility portspoof which is probably better more secure well developed and has a lot more thought put into it than this one. However this is for demonstrative purposes. How it works is that first it redirects all ports, really can be however many you want though, to the port 8000. Once redirected to that particular port when nmap attempts to connect to it, or really any scanner like netcat that pulls a header from the port, it floods the attacker with a bunch of random hex data. I thought it was clever but like I said the legit one is going to be portspoof which will probably handle simultanious connections a lot better...

Also the bonk.c can be written in any language that allows you to compile to an executable, all it really needs to do is flood the standard output with a bunch of data for long enough to keep the scanner occupied.

## arpDetector.py
This python script is a stand alone and is only intended to serve as a starting point for implementation of an actual arp spoofing detection script.

## Full projects
If you are not in a tight spot and have some preperation that can be done, like setting up a full on vm or even a raspberry pi I reccomend the following projects for full blown honeypots.

Portspoof: https://github.com/strandjs/IntroLabs/blob/master/IntroClassFiles/Tools/IntroClass/Portspoof.md
- This is a tarpit for automated scanners
Cowrie SSH/Telnet Honeypot: https://github.com/cowrie/cowrie
- A system that emulates SSH or telnet systems, pretty cool stuff.
Spider Trap: https://github.com/adhdproject/spidertrap
- A fancy quick and dirty python script that will tarpit an ajax scanner and fill up a scan log with a bunch of junk data possibly crashing an adversarys system, use with care and consideration.
