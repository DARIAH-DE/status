#!/bin/bash
# test and validate YAML files for DARIAH-DE status
# requires YAML CLI parser from npm, do (sudo) npm install -g yaml-cli

# globals
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORM=$(tput sgr0)

# look for YAML parser
yaml >> /dev/null
if [[ $? -gt 0 ]]; then echo "YAML parser not found."; exit; fi;
echo "  -->  found YAML parser";

# prepare temporary copy of the files
for FILE in {_data,_infrastructure,_servers,_middlewares,_services}/*.yaml; do
  cp $FILE $FILE.tmp;
  # remove YAML header marker from files
  # NOTE on MAC please use "gsed" instead of "sed"!
  #gsed "s \-\-\-  g" -i $FILE.tmp;
  sed "s \-\-\-  g" -i $FILE.tmp;
done;
echo "  -->  copied YAML files to temp files";

# prepare item list
LIST=$(ls **/*.tmp | sed -e "s _ / g" -e "s \.yaml\.tmp  g")
# make it a bash array
declare -a array=($LIST)
echo "  -->  the list contains ${#array[@]} items"

# work on the temporary files
for FILE in {_data,_infrastructure,_servers,_middlewares,_services}/*.tmp; do
  NAME=$(sed -e "s _  g" -e "s \.yaml\.tmp  g" <<< $FILE)
  # give the name at first and print YAML errors then
  echo -n -e "  -->  $NAME:${RED}${BOLD}"
  DEP=($(yaml get $FILE dependencies));
  echo -e "${NORM}${NC} found ${#DEP[@]} dependencies";

  for DEPi in ${DEP[*]}; do
    [[ "$DEPi" =~ ^/.* ]] && true || echo -e "       ${RED}${BOLD}$(sed 's/./ /g' <<< $NAME): $DEPi has no starting slash.${NORM}${NC}"
    [[ ${array[*]} =~ "$DEPi" ]] && true || echo -e "       ${RED}${BOLD}$(sed 's/./ /g' <<< $NAME): $DEPi nil.${NORM}${NC}"
  done;

  rm $FILE;

done;
