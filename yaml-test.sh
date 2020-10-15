#!/bin/bash
# test and validate YAML files for DARIAH-DE status
# requires YAML CLI parser from npm, do npm install -g yaml-cli

# globals
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORM=$(tput sgr0)

yaml >> /dev/null
if [[ $? -gt 0 ]]; then echo "YAML parser not found."; exit; fi;

for FILE in {_infrastructure,_servers,_middlewares,_services}/*.yaml; do
  # prepare temporary copy of the files
  cp $FILE $FILE.tmp;
  # remove YAML header marker from files
  sed "s \-\-\-  g" -i $FILE.tmp;
done;

# prepare item list
LIST=$(ls **/*.tmp | sed -e "s _ / g" -e "s \.yaml\.tmp  g")
# make it a bash array
declare -a array=($LIST)
echo "the list contains ${#array[@]} items"


# work on the temporary files
for FILE in {_infrastructure,_servers,_middlewares,_services}/*.tmp; do
  NAME=$(sed -e "s _  g" -e "s \.yaml\.tmp  g" <<< $FILE)
  # give the name at first and print YAML errors then
  echo -n -e "$NAME:${RED}${BOLD}"
  DEP=($(yaml get $FILE dependencies));
  # reset terminal font styles for information on dependencies.
  echo -e "${NORM}${NC} found ${#DEP[@]} dependencies";
  
  for DEPi in ${DEP[*]}; do
    [[ ${array[*]} =~ "$DEPi" ]] && true || echo -e "${RED}${BOLD}$(sed 's/./ /g' <<< $NAME): $DEPi nil.${NORM}${NC}"
  done;
  
  rm $FILE;
  
done;
