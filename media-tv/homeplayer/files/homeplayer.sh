#!/bin/sh
# -----------------------------------------------------------------------------
# Script de demarrage pour HomePlayer
#
# 
#   0) met en place les variables d'execution
#   1) HPM variable indiquant le repertoire de HomePlayer
#   2) test si le repertoire $HPM/update existe
#   3) test si le fichier HomePlayer.zip existe
#   4) deplace le fichier $HPM/lib/HomePlayer.jar dans $HPM/lib/HomePlayer.old 
#   5) decompresse HomePlayer.zip dans $HPM/
#   6) efface le fichier HomePlayer.zip
#
# -----------------------------------------------------------------------------

# OS flag - unused for the moment
mac=false
linux=false
bsd=false

case "`uname`" in
Linux)linux=true;;
Darwin)mac=true;;
*BSD)bsd=true;;
esac

# detect linktype
DIR="$0"

while [ -h "$DIR" ]; do
  ls=`ls -ld "$DIR"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    DIR="$link"
  else
    DIR=`dirname "$DIR"`/"$link"
  fi
done

#determines HomePlayer PATH
HPM=`dirname "$DIR"`
#echo "HomePlayer PATH : $HPM"

#determines the date of the update
UPDATE=`date`

#check if update dir exists and create it if not
if [ -d "$HPM"/update ]; then
   echo "Repertoire deja cree" 1>/dev/null
else
   mkdir "$HPM"/update
   echo "Repertoire update cree le $UPDATE" 1>>"$HPM"/homeplayer_update.log
fi
#check if HomePlayer.zip exists in update dir
#move HomePlayer.jar to /update/HomePlayer.old
#unzip the HomePlayer.zip file in HPM directory

if [ -d "$HPM"/update -a -f "$HPM"/update/HomePlayer.zip ]; then
 echo "HomePlayer operation : update/mise a jour du $UPDATE" 1>>"$HPM"/homeplayer_update.log
 mv "$HPM"/lib/HomePlayer.jar "$HPM"/lib/HomePlayer.old
 unzip -oq "$HPM"/update/HomePlayer.zip -d "$HPM"/
 rm -f "$HPM"/update/HomePlayer.zip
fi

#locate java Mac, Linux, *BSD command
#EXECJAVA=`which java`
EXECJAVA=`java-config --select-vm=2 -J`
#optional Java options
#JAVA_OPTS=-Xmx256m

#libs classpath 
CLASSPATH="$CLASSPATH":"$HPM"
CLASSPATH="$CLASSPATH":"$HPM"/webapps/ROOT
CLASSPATH="$CLASSPATH":"$HPM"/../classes
CLASSPATH="$CLASSPATH":"$HPM"/lib/1.5/tools.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/entagged-audioformats-0.15.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/HomePlayer.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/HomePlayer-tool.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/jai_codec.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/jai_core.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/jawin.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/linux/jdic.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/jdom.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/jiu.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/metadata-extractor-2.3.0.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/mlibwrapper_jai.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/rome-0.8.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/skinlf.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/smallsql.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/tomcat.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/xstream-1.1.3.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/PgsLookAndFeel.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/commons-net-1.4.1.jar
CLASSPATH="$CLASSPATH":"$HPM"/lib/jakarta-oro-2.0.8.jar

#HomePlayer main class 
MAINCLASS=org.homeplayer.HomePlayer

#library path fo linux or *nix *.so
LIBRARY="$HPM"/lib/linux

#HP extra options like -serveronly

HP_OPTS=""

#pagosoft plaf option, comment it for non-graphical use
HP_OPTS="$HP_OPTS -pgs"
#uncomment if you don't want systray
#HP_OPTS="$HP_OPTS -nosystray"
#uncomment for server only version
#HP_OPTS="$HP_OPTS -serveronly"

#uncomment to specify the log directory (in Homeplayer directory by default)
LOG_DIR="$HOME"/.homeplayer
if [ -d "$LOG_DIR" ]; then
   echo "Repertoire deja cree" 1>/dev/null
else
   mkdir $LOG_DIR
fi
HP_OPTS="$HP_OPTS -logDir $LOG_DIR"

$EXECJAVA $JAVA_OPTS -cp "$CLASSPATH" -Djava.library.path="$LIBRARY" $MAINCLASS $HP_OPTS $@
