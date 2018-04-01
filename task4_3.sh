#!/bin/bash

# simple back up of directories

# clear

count_arg_need=2 #correct amount of argument
count_arg_input="$#"  # amount of arguments was specified  during the starting of script 

if_arg_int="^[0-9]+$"

dir_final="/tmp/backups/" # final destination directory for backups
dir_source="" #source directory (from where)
script_name="$0" 
arg_1="$1"
arg_2="$2"

# echo "$count_arg_input"

check_arg() {
if [ "$count_arg_need" != "$count_arg_input" ]; then
   printf "\n**ERROR1** in ($script_name):\n   incorrect amount of arguments (\"$count_arg_input\" instead of \"$count_arg_need\").\n\
   Please, try \"$script_name source_dir count_of_backups\".\n\
   For example, $script_name \"/var/log/\" 2\n" >&2; exit 1; 
else 
   if [ -d "$arg_1" ];  then dir_source="$arg_1"
      else printf "\n**ERROR2** in ($script_name):\n   Source directory ("$arg_1") is not exist.\n" >&2; exit 2;  
   fi
   if ! [[ $arg_2 =~ $if_arg_int ]]; then
      printf "\n **ERROR3** in ($script_name): Second argument is not a digit or less than \"0\".\n" >&2; exit 3;
   fi 
   if [ $arg_2 -eq 0 ]; then
      printf "\n **ERROR4** in ($script_name): Second argument should be more than \"0\".\n" >&2; exit 4;
   fi 
return 0
fi
}

crt_back() {
 return 0;
}

###########################
### Main body of script ###
###########################

if ! [ -d "$dir_final"  ]; then mkdir -p "$dir_final"; fi


check_arg # function for check of arguments
crt_back  # function for backups creation

 printf "\n**ERROR100** in ($script_name): The script has not done yet.\n" >&2
 exit 100

# exit

