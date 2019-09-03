#!/bin/bash

#Pass/Fail functions
function print_PASS() {
  echo -e '\033[1;32mPASS\033[0;39m'
}


function print_FAIL() {
  echo -e '\033[1;31mFAIL\033[0;39m'
}

function top_fluff() {
printf "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
}
function bottom_fluff() {
printf "++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
}

# Check to make sure root is running the script - root access req for both
# setup and grading
function check_root {
if [[ "$EUID" -ne "0" ]] ; then
    echo='This script must be run as root!'
    exit 1
fi
}

function create_users() {
useradd -s /sbin/nologin Ralph
useradd -s /sbin/nologin Sam
useradd -s /sbin/nologin Gossamer
}

function marvin() {
while IFS= read -r file1 <&3 && read file2 <&4
do
  echo "$file1" >> /var/log/secure # must have quotes around var to keep whitespace
  for i in {1..5}
    do
      echo $file2 >> /var/log/secure
    done
# change location of files if necessary
done 3<$(pwd)/\.marvins 4</var/log/secure
}

function hide_files() {
touch /var/log/unicorn
touch /var/log/platypus
touch /var/log/kraken
touch /var/log/golden_squirrel
touch /var/log/pixies
touch /var/log/honest_people
chown Gossamer /var/log/unicorn
chown Gossamer /var/log/platypus
chown Gossamer /var/log/kraken
chown Gossamer /var/log/golden_squirrel
chown Gossamer /var/log/pixies
chown Gossamer /var/log/honest_people
}

#####TEST FILES####
#touch /root/GossamerFiles/unicorn
#touch /root/GossamerFiles/platypus
#touch /root/GossamerFiles/kraken
#touch /root/GossamerFiles/golden_squirrel
#touch /root/GossamerFiles/pixies
#touch /root/GossamerFiles/honest_people

################################
# Grader part
################################

function grade_hidden_files() {
  top_fluff
  echo "Checking /root/GossamerFiles has the correct files"
  bottom_fluff

  if [ ! -d /root/GossamerFiles ]; then
    echo "The target directory /root/GossamerFiles does not exist."
    print_FAIL
    return 1
  fi

  if ! ls /root/GossamerFiles | grep -q 'unicorn'; then
    echo "Gossamer's unicorn was not copied properly."
    print_FAIL
    return 1
  fi

  if ! ls /root/GossamerFiles | grep -q 'platypus'; then
    echo "Gossamer's platypus was not copied properly."
    print_FAIL
    return 1
  fi
  if ! ls /root/GossamerFiles | grep -q 'kraken'; then
    echo "Gossamer's kraken was not copied properly."
    print_FAIL
    return 1
  fi

  if ! ls /root/GossamerFiles | grep -q 'golden_squirrel'; then
    echo "Gossamer's golden_squirrel were not copied properly."
    print_FAIL
    return 1
  fi

  if ! ls /root/GossamerFiles | grep -q 'pixies'; then
    echo "Gossamer's pixies was not copied properly."
    print_FAIL
    return 1
  fi

  if ! ls /root/GossamerFiles | grep -q 'honest_people'; then
    echo "Gossamer's honest_people were not copied properly."
    print_FAIL
    return 1
  fi

  echo "You have found and moved all the files."
  print_PASS
  return 0
}

function grade_marvin() {
  top_fluff
  echo "Checking VeryAngry.txt file"
  bottom_fluff

f1="$(pwd)/.marvins"
f2="/root/VeryAngry.txt"
  if [ ! -f "$f2" ]; then
     echo "The VeryAngry.txt file does not exist"
     print_FAIL
     return 1
  fi

  if diff -q $f1 $f2 &>/dev/null; then
    echo "The files are the same."
    print_PASS
    return 0
  else
    echo "The VeryAngry.txt file has not been grepped correctly."
    print_FAIL
    return 1
fi
}

function grade_cronjob() {
  top_fluff
  echo "Checking for cron jobs."
  bottom_fluff

# Check if crontabs exist for users:
if [ ! -f /var/spool/cron/Ralph ]; then
  echo "Crontab for Ralph does not exist"
  print_FAIL
  return 1
fi

if [ ! -f /var/spool/cron/Sam ]; then
  echo "Crontab for Ralph does not exist"
  print_FAIL
  return 1
fi

# Variables set to compare strings
cronRalph=$(crontab -u Ralph -l)
chkRalph="0 18 * * 1-5 date >> /home/Ralph/MorninSam"
cronSam=$(crontab -u Sam -l)
chkSam="0 6 * * 1-5 date >> /home/Sam/MorninRalph"

# Previous code - however if statement passed if Ralph had set it correctly
# and would exit code with a pass. Leaving in script for time being!
#if [ "$cronRalph" == "$chkRalph" ]; then
#   echo "Cronjob for Ralph has been set correctly."
#   print_PASS
#   return 0
#else
#   echo "Cronjob for Ralph has not been set correctly."
#   print_FAIL
#   return 1
#fi
#if [ "$cronSam" == "$chkSam" ]; then
#   echo "Cronjob for Sam has been set correctly."
#   print_PASS
#   return 0
#else
#   echo "Cronjob for Sam has not been set correctly."
#   print_FAIL
#   return 1
#fi

#####################################
#   Correct ****USE THIS ONE*****   #
#####################################
if [ "$cronRalph" != "$chkRalph" ]; then
     echo "Cronjob for Ralph has not been set correctly."
     print_FAIL
     return 1
fi
if [ "$cronSam" != "$chkSam" ]; then
     echo "Cronjob for Sam  has not been set correctly."
     print_FAIL
     return 1
fi

  echo "Cronjob for sam and Ralph have been setup correctly."
  print_PASS
  return 0
}


function grade_primary_group {
  groupid=$(grep $1 /etc/group | awk -F ":" '{print $(NF-1)}')
        primarygroupid=$(grep $2 /etc/passwd | awk -F ":" '{print $4}')
        if ! [ "$groupid" = "$primarygroupid" ]; then
            print_FAIL
      groupname=$(echo $1 | sed "s/:/./")
            echo " - The user $2 is not in the primary group $groupname"
            return 1
        fi
}

function grade_toons_group {
  top_fluff
  echo "Checking users are part of Toons group"
  bottom_fluff

for USER in Bugs Daffy Taz; do
  getent group Toons | grep &>/dev/null "$USER"
    RESULT=$?
    if [ "${RESULT}" -ne 0 ]; then
    echo "$USER is not in the Toons group."
    print_FAIL
    return 1
  fi
done
echo "All the users are part of the Toon group"
print_PASS
return 0

}
################################################################
# Does not work at the moment - realized it checks for groupid #
# for the time being resolved issue another way                #
################################################################
#function grade_toons_group {
#  groupid2=$(grep $1 /etc/group | awk -F ":" '{print $(NF-1)}')
#        toonsgroupid=$(grep $2 /etc/passwd | awk -F ":" '{print $4 $5 $6}')
#        if ! [ "$groupid2" = "$toonsgroupid" ]; then
#            print_FAIL
#      groupname2=$(echo $1 | sed "s/:/./")
#            echo " - The user $2 is not in group $groupname2"
#            return 1
#        fi
#}

function grade_check_users() {
  top_fluff
  echo "Checking for correct user setup"
  bottom_fluff

  grep 'Toons:x:*' /etc/group &>/dev/null
  RESULT=$?
  if [ "${RESULT}" -ne 0 ]; then
    print_FAIL
    echo "The Toons group does not exist."
    return 1
  fi

  for USER in Bugs Daffy Taz; do
    grep "$USER:x:.*" /etc/passwd &>/dev/null
    RESULT=$?
    if [ "${RESULT}" -ne 0 ]; then
      print_FAIL
      echo "The user $USER has not been created."
      return 1
    fi
  done

  if ! grade_primary_group 'Bugs:' 'Bugs' ||
  ! grade_primary_group 'Daffy:' 'Daffy' ||
  ! grade_primary_group 'Taz:' 'Taz'; then
  return 1
  fi

#### This part does not work at the moment --- will look to fix later
#  if ! grade_toons_group 'Toons:' 'Bugs' ||
#  ! grade_toons_group 'Toons:' 'Daffy' ||
#  ! grade_toons_group 'Toons:' 'Taz'; then
#  return 1
#  fi

  for USER in Bugs Daffy Taz; do
    NEWPASS="Loony"
    FULLHASH=$(grep "^$USER:" /etc/shadow | cut -d: -f 2)
    SALT=$(grep "^$USER:" /etc/shadow | cut -d'$' -f3)
    PERLCOMMAND="print crypt(\"${NEWPASS}\", \"\\\$6\\\$${SALT}\");"
    NEWHASH=$(perl -e "${PERLCOMMAND}")
    if [ "${FULLHASH}" != "${NEWHASH}" ]; then
      print_FAIL
      echo " - The password for user $USER is not set to ${NEWPASS}"
      return 1
    fi
  done

  print_PASS
  return 0
}

function grade_mischief() {
  top_fluff
  echo "Checking for correct mischief directory"
  bottom_fluff

if [ ! -d /mischief ]; then
   echo "The /mischief directory does not exist."
   print_FAIL
   return 1
fi

if [ $(stat -c %a /mischief) -ne 2770 ]; then
  echo "The /mischief directory does not have correct permissions."
  print_FAIL
  return 1
fi
  echo "The directory permissions are set correctly"
  print_PASS
  return 0
}

function grade_facl() {
  top_fluff
  echo "Checking facl settings on /mischief directory"
  bottom_fluff

if [ ! -d /mischief ]; then
  echo "The /mischief directory does not exist"
  return_FAIL
  return 1
fi

userTaz=$(getfacl -p /mischief | grep "^user:Taz:")
chkTaz="user:Taz:---"
defuserTaz=$(getfacl -p /mischief | grep "default:user:Taz:---")
chkdefTaz="default:user:Taz:---"
  if ! [ "$userTaz" = "$chkTaz" ]; then
     echo "User permission settings for Taz on /mischief are incorrect"
     print_FAIL
     return 1
  fi

  if ! [ "$defuserTaz" = "$chkdefTaz" ]; then
     echo "Default user permission settings for Taz on /mischief are incorrect"
     print_FAIL
     return 1
  fi
 echo "Settings on /mischief are correct"
 print_PASS
 return 0
}

function usage() {
printf "Usage: looneyTunes.sh [ setup | grade ] [--help]"
printf "\nTo setup the homework type:\t ./looneyTunes.sh setup\n"
printf "To grade the homework type:\t ./looneyTunes.sh grade\n"
printf "The option --help will bring up this menu\n"
}

function lab_grade() {
FAIL=0
grade_hidden_files || (( FAIL += 1 ))
grade_marvin || (( FAIL += 1 ))
grade_cronjob || (( FAIL += 1 ))
grade_toons_group || (( FAIL += 1 ))
grade_check_users || (( FAIL += 1 ))
grade_mischief || (( FAIL += 1 ))
grade_facl || (( FAIL += 1 ))

printf "\n++++++++++++++++++"
printf "++ Overall result ++"
printf "++++++++++++++++++\n"
if [ ${FAIL} -eq 0 ]; then
  printf "\nCongratulations! You've passed all the tests........"
  print_PASS
else
  printf "You have failed ${FAIL} tests, please check your work and try again...."
  print_FAIL
fi
}

check_root

case $1 in
  setup )
        create_users
        marvin
        hide_files
        echo "Setup complete. Please refer to instructions to begin homework"
        ;;
  grade )
        lab_grade
        ;;
  --help )
        usage
        ;;
      * )
     usage
        ;;
esac
