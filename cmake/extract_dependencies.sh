#!/bin/bash
RESULT=""

TMP_DB_FILE="/tmp/$$_make.db.txt"
env -i make -pn -f ../tdp_build/cmake/parse_dependencies.pri > $TMP_DB_FILE 2>/dev/null
while read var assign value; do
  if [[ ${var} = $1 ]] && [[ ${assign} = '=' ]]; then
    RESULT="$value"
    break
  fi
done < $TMP_DB_FILE

#cat $TMP_DB_FILE

rm -f $TMP_DB_FILE
echo $RESULT

