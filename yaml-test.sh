#!/bin/bash
# test and validate YAML files for DARIAH-DE status
# requires YAML CLI parser from npm, do (sudo) npm install -g yaml-cli
# AUTHOR: Stefan Funk, Mathias Göbel (SUB Göttingen)

# globals
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORM=$(tput sgr0)
BACK=$(tput cub 5)
TAB='       '
ARROW='  -->  '

# functions
function test () {
  echo -n "${TAB}...testing $1... [OK]"
  [[ "$1" =~ ^/.* ]] && true || echo -ne "${BACK}$3${BOLD} [$2] $1 has no starting slash${NORM}${NC}"
  [[ ${array[*]} =~ "$1" ]] && true || echo -ne "${BACK}$3${BOLD} [$2] $1 nil${NORM}${NC}"
  echo;
}

function name () {
  NAME=$(sed -e "s _  g" -e "s \.yaml\.tmp  g" <<< ${FILE})
  echo -n -e "${ARROW}${NAME}:${RED}${BOLD}"
}

# look for YAML parser
yaml >> /dev/null
if [[ $? -gt 0 ]]; then echo "YAML parser not found"; exit; fi;
echo "${ARROW}found YAML parser";

# prepare temporary copy of the files
for FILE in {_data,_infrastructure,_servers,_middlewares,_services}/*.yaml; do
  cp ${FILE} ${FILE}.tmp;
  # remove YAML header marker from files
  # NOTE on MAC please use "gsed" instead of "sed"!
  sed "s \-\-\-  g" --in-place ${FILE}.tmp;
done;
echo "${ARROW}copied YAML files to temp files";

# prepare item list
LIST=$(ls {_infrastructure,_servers,_middlewares,_services}/*.tmp | sed -e "s _ / g" -e "s \.yaml\.tmp  g")
# make it a bash array
declare -a array=($LIST)
echo "${ARROW}the list contains ${#array[@]} items"

# work on the temporary files
STATE='ERROR'
COLOR=${RED}
for FILE in {_infrastructure,_servers,_middlewares,_services}/*.tmp
do
  name
  # give the name at first and print YAML errors then
  DEP=($(yaml get ${FILE} dependencies));
  echo -e "${NORM}${NC} found ${#DEP[@]} dependencies";
  for I in ${DEP[@]}; do
    test $I $STATE $COLOR;
  done;
  rm ${FILE};
done;

# check _data files for affected items
for FILE in _data/*.tmp
do
  name
  NUM_TOP_LEVEL_ARRAYS=$(grep --count ^\- ${FILE})
  [[ NUM_TOP_LEVEL_ARRAYS -lt 1 ]] && echo -e "${ORANGE}[WARNING] No item in array"
  echo;
  if [ "$FILE" = "_data/history.yaml.tmp" ]; then
    STATE='WARNING'
    COLOR=${ORANGE}
  else
    STATE='ERROR'
    COLOR=${RED}
  fi
  for i in `seq 0 $((NUM_TOP_LEVEL_ARRAYS - 1))`
  do
    AFF=($(yaml get ${FILE} ${i}.affected));
    echo -e "${TAB}${NORM}${NC}[$((i + 1))] found ${#AFF[@]} affected items";
    for I in ${AFF[@]}; do
      test $I $STATE $COLOR;
    done;
  done;
  rm ${FILE};
done;

exit 0
