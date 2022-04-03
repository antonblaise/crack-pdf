#!/bin/bash

PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
WHITE='\033[1;37m'
BG_RED='\033[0;101m'
NC='\033[0m' # No Color

printf """
${PURPLE}
      PDF Password Recovery Tool
      ft. Hashcat & JohnTheRipper
${NC}

${BG_RED}${WHITE} Please make sure to run this script in the same directory as your target PDFs!  ${NC}


"""

echo "Checking dependencies ... "
bash requirements.sh


# 1. List and select PDF file

SAVEIFS=$IFS

IFS=$(echo -en "\n\b")
i=1

printf "PDFs in the current directory:\n"

for f in *.pdf
do
  printf "${WHITE}$i. $f${NC}\n"
  files[i]=$f
  i=$((i+1))
done

IFS=$SAVEIFS
input=-1

echo ""
echo "Please select a PDF"
while true
do
  printf ">> "
  read input

  if [ $input -ge 1 ] && [ $input -lt $i ] 
  then
    break
  fi

  if [ $input -ne $input 2>/dev/null ]
  then
    continue
  fi
done

file=${files[$input]}
printf "Selected PDF is ${YELLOW}'${file}'${NC}.\n"


# 2. Obtain hash

i=1
for j in $(locate pdf2john)
do
  pdf2john[i]=$j # get pdf2john.pl tool
  i=$((i+1))
done

pdf2john=${pdf2john[1]} # store tool in a variable for use
"$pdf2john" "${file}" | sed 's/.*://' > "${file}.hash" # store useable (hashcat compatible) hash in a .hash file

if [[ $(cat madrafin.pdf.hash) == " not encrypted!" ]] # if the PDF is not encrypted
then
  printf "\n${YELLOW}'${file}'${NC} is ${GREEN}NOT ENCRYPTED${NC}!\n\n"
  rm "${file}.hash"
  exit 1
fi

if [[ "$file" != "${file%[[:space:]]*}" ]] # if the file name has space(s)
then
  mv "$file".hash `echo $file | tr ' ' '_'`.hash # replace spaces with underscores and ceate the hash file with that name
  hashFile=`echo $file.hash | tr ' ' '_'` # store the hash file's name into a variable for use
else
  hashFile="$file".hash
fi


# 3. Build hashcat command

printf """
Choose password type:${WHITE}
1. Numbers only
2. Alphanumeric (lowercase only)
3. Alphanumeric (uppercase only)
4. Alphanumeric (lower+upper cases)
5. All alphanumeric + Symbols (May take forever!!)${NC}
"""

while true
do
  printf ">> "
  read passType

  if [ $passType -ge 1 ] && [ $passType -le 5 ]
  then
    break
  fi

  if [ $passType -ne $passType 2>/dev/null ]
  then
    continue
  fi
done

printf "\nHow many characters?\n"
while true
do
  printf ">> "
  read passLength
  if [ $passLength -eq $passLength 2>/dev/null ] && [ ! -z $passLength ]
  then
    break
  fi
done

case $passType in # build character command
  1)
    custom=""
    char="?d"
    ;;
  
  2)
    custom="-1 ?l?d "
    char="?1"
    ;;
  
  3)
    custom="-1 ?u?d "
    char="?1"
    ;;

  4)
    custom="-1 ?l?u?d "
    char="?1"
    ;;
  
  5)
    custom=""
    char="?a"
    ;;
  
  *)
    echo "None"
    ;;

esac

characters=$char

for ((i=0; i<$((passLength-1)); i++))
do
  characters=$char$characters
done

characters="$custom$characters"

hashcat_cmd="hashcat -a 3 -m 10700 ${hashFile} ${characters} -w 4 --hwmon-temp-abort 100 -O --session ${hashFile}.session"


# 4. Show and execute command

printf """

Executing hashcat command:

${BLUE}${hashcat_cmd}${NC}

"""

$hashcat_cmd

crackedPassword=$($hashcat_cmd --show | sed 's/.*://')

printf """
Target PDF: ${YELLOW}${file}${NC}
Password: ${GREEN}${crackedPassword}${NC}

"""

