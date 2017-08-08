#!/bin/sh

#Transformat the fowlling format to 1 line cvs format

#From:
#".equals()" should not be used to test the values of "Atomic" classes
#Java     Bug 

#To:
#".equals()" should not be used to test the values of "Atomic" classes, #Java,Bug

#Exception:
#if , existing, it will be replaced by ;

usage(){
  echo "Usage: $0 SONAR-RULEFILE"
  echo ""
}

SONARRULEFILE="$1"
TMPFILE="/tmp/tmp_sona_$$"
RESULT="/tmp/result_sonar_rule.$$"

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

if [ ! -f $SONARRULEFILE ]; then
  usage
  exit 1
fi

date
echo "Transformat sonar rules"
echo "From: $SONARRULEFILE"
echo "To  : $RESULT"
echo "Operation begins ..."
sed s/"Code Smell"/CodeSmellREP/g $SONARRULEFILE > $TMPFILE
awk '{ 
  printf("%s ", $0);
  getline;
  printf("REPLACESEP %sREPLACESEP%sREPLACESEP%s\n",$1,$2,$3) 
}' $TMPFILE >$RESULT
sed -i s/,/\;/g $RESULT
sed -i s/REPLACESEP/,/g $RESULT
sed -i s/CodeSmellREP/"Code Smell"/g $RESULT
echo "Operation ends  ..."
rm $TMPFILE
#cat $RESULT
date
