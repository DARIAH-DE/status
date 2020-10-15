#!/bin/bash
# test and validate YAML files for DARIAH-DE status
# requires YAML CLI parser from npm, do (sudo) npm install -g yaml-cli

# globals
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORM=$(tput sgr0)
TAB='       '
ARROW='  -->  '

# functions
function test () {
  ARRAY=$1
  for DEPi in ${ARRAY[*]}; do
    [[ "$DEPi" =~ ^/.* ]] && true || echo -e "${TAB}${RED}${BOLD}$(sed 's/./ /g' <<< $NAME): $DEPi has no starting slash.${NORM}${NC}"
    [[ ${array[*]} =~ "$DEPi" ]] && true || echo -e "${TAB}${RED}${BOLD}$(sed 's/./ /g' <<< $NAME)$(echo " [$((i + 1))]" | sed 's/./ /g'): $DEPi nil.${NORM}${NC}"
  done;
}

# look for YAML parser
yaml >> /dev/null
if [[ $? -gt 0 ]]; then echo "YAML parser not found."; exit; fi;
echo "${ARROW}found YAML parser";

# prepare temporary copy of the files
for FILE in {_data,_infrastructure,_servers,_middlewares,_services}/*.yaml; do
  cp ${FILE} ${FILE}.tmp;
  # remove YAML header marker from files
  # NOTE on MAC please use "gsed" instead of "sed"!
  #gsed "s \-\-\-  g" --in-place ${FILE}.tmp;
  sed "s \-\-\-  g" --in-place ${FILE}.tmp;
done;
echo "${ARROW}copied YAML files to temp files";

# prepare item list
LIST=$(ls {_infrastructure,_servers,_middlewares,_services}/*.tmp | sed -e "s _ / g" -e "s \.yaml\.tmp  g")
# make it a bash array
declare -a array=($LIST)
echo "${ARROW}the list contains ${#array[@]} items"

# work on the temporary files
for FILE in {_infrastructure,_servers,_middlewares,_services}/*.tmp; do
  NAME=$(sed -e "s _  g" -e "s \.yaml\.tmp  g" <<< ${FILE})
  # give the name at first and print YAML errors then
  echo -n -e "${ARROW}${NAME}:${RED}${BOLD}"
  DEP=($(yaml get ${FILE} dependencies));
  echo -e "${NORM}${NC} found ${#DEP[@]} dependencies";

  test $DEP;

  rm ${FILE};

done;

# check _data files for affected items
for FILE in _data/*.tmp; do
  NAME=$(sed -e "s _  g" -e "s \.yaml\.tmp  g" <<< ${FILE})
  NUM_TOP_LEVEL_ARRAYS=$(grep --count ^\- ${FILE})
  echo -e "${ARROW}${NAME}:${RED}${BOLD}"
  [[ NUM_TOP_LEVEL_ARRAYS -lt 1 ]] && echo -e "${ORANGE} No item in array." || true
  for i in `seq 0 $((NUM_TOP_LEVEL_ARRAYS - 1))`; do
    AFF=($(yaml get ${FILE} ${i}.affected));
    echo -e "${NORM}${NC}${TAB}$(sed 's/./ /g' <<< $NAME) [$((i + 1))]: found ${#AFF[@]} affected items";
    test $AFF;
  done;

  rm ${FILE};

done;
