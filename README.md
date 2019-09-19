# looneyTunes
A bash shell script written for setting up and subsequently grading a Linux workshop. This is geared towards getting familiar with creating users/groups, setting passwords, setting up cron jobs, using the find command, using grep and output redirection

# Recommendation
This script creates a number of users and will place lines in to /var/log/secure! It is recommended to be used with a VirtualMachine for ease of reset

# Usage
User must be root or have sudo permissions to run the setup and grade functions of the script
looneyTunes.sh setup >> will run the setup script
looneyTunes.sh grade >> will run the grade script

# Instructions
**Users and Groups**
* Create users for: Bugs, Daffy and Taz
* Create the group Toons and add all three new users to it
* Set passwords for each user to Loony
* Create a collaborate directory called /mischief with permissions granting the owner and group owner full access while denying access to others
* Configure the directory to deny Taz any access to the directory and any files that may be made in the future

**cron**
* Schedule a daily task that creates a sign in log as the user Ralph at 6PM Monday thru Friday. This should run the date command and append to the file /home/Ralph/MorninSam
* Schedule a daily task that creates a sign in log as the user Ralph at 6AM Monday thru Friday. This should run the date command and append to the file /home/Sam/MorninRalph

**find**
* Find all files (not special or hidden) owned by user Gossamer on the copy system and copy them to the directory /root/GossamerFiles

**grep**
* Log files are making me AnGry! Find all lines in the file **/var/log/secure** that contain the word angry, regardless of case and copy the lines to the file /root/VeryAngry.txt
