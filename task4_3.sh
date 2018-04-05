#!/bin/bash

# simple back up of directories (note: max possible amount (arg_2 here) of backup is 9 files)

# clear

count_arg_need=2 #correct amount of argument
count_arg_input="$#"  # amount of arguments was specified  during the starting of script 
count_of_exist_bu=0 # amount of (already) existing backups in the "dir_final" 

if_arg_int="^[0-9]+$"

dir_final="/tmp/backups/" # final destination directory for backups
dir_source="" # source directory (from where)
arc_name="" # name of archive which will be created
script_name="$0" 
arg_1="$1"
arg_2="$2"

# echo "arg_1=$arg_1 arg1=$arg_2"
# echo "$count_arg_input"

check_arg() {
 if [ "$count_arg_need" != "$count_arg_input" ]; then
    printf "\n**ERROR1** in ($script_name):\n   incorrect amount of arguments (\"$count_arg_input\" instead of \"$count_arg_need\").\n\
    Please, try \"$script_name source_dir count_of_backups\".\n\
    For example, $script_name \"/var/log/\" 2\n" >&2; exit 1; 
 else 
    if ! [ -d "$arg_1" ];  then  
       printf "\n**ERROR2** in ($script_name):\n   Source directory ("$arg_1") is not exist.\n" >&2; exit 2;  
    fi
    if ! [[ $arg_2 =~ $if_arg_int ]]; then
       printf "\n **ERROR3** in ($script_name): Second argument is not a digit or less than \"0\".\n" >&2; exit 3;
    fi 
    if [ $arg_2 -eq 0 -o $arg_2 -ge 10 ]; then
       printf "\n **ERROR4** in ($script_name): Second argument should be more than \"0\" and less than 10.\n" >&2; exit 4;
    fi 
 return 0
 fi
}

create_backups() {

 if ! [ -d "$dir_final"  ]; then mkdir -p "$dir_final"; fi

 # no matter relative or absolute path to arc dir was specified (dir_source)
 dir_source="$(cd "$(dirname "$arg_1")"; pwd)/$(basename "$arg_1")"; 
 arc_name="$(echo "$dir_source" | \
          awk -F/ ' { nm1=substr($0,2,length($0)-1); gsub("/","-",nm1); printf nm1 } ')";
 #echo "arc_name=$arc_name"

 count_of_exist_bu=$(ls -avr "$dir_final"  | grep -E "$arc_name"[\.]?[0-9]?".tar.gz" | wc -l)
 # echo "count_of_exist_bu=$count_of_exist_bu"

 list_of_exist_bu=$(ls -avr "$dir_final"  | grep -E "$arc_name"[\.]?[0-9]?".tar.gz")
 # echo -e "list_of_exist_bu=\n$list_of_exist_bu"

 ir=$(($count_of_exist_bu)) # it is variable for the loop "for" below

 for file_in in $list_of_exist_bu; do
     if [ $ir -ge $arg_2  ]; then  
          # echo "rm ${dir_final}${file_in}";
          rm "${dir_final}""${file_in}";
     else 
          # echo "mv ${dir_final}${file_in} ${dir_final}${arc_name}.${ir}.tar.gz";
          mv "${dir_final}""${file_in}" "${dir_final}""${arc_name}.${ir}.tar.gz";
     fi

     ir=$(($ir-1))
     # echo "$ir"
     # read

 done

 # echo "tar -zv --create --file=${dir_final}${arc_name}.tar.gz $dir_source"
 tar -zv --create --file="${dir_final}${arc_name}.tar.gz" "$dir_source" 1>/dev/null
 # read

 return 0;
}

###############################
### Main body of the script ###
###############################


check_arg # function for check of arguments
create_backups  # function for backups creation

# exit


