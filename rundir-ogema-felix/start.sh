#!/bin/bash

#
# Start OGEMA with default configuration (Equinox OSGi and no security)
#

LAUNCHER="./system/felix-launcher.jar:./system/org.apache.felix.framework-5.6.10.jar"
CONFIG=${OGEMA_CONFIG:-config/config.xml}
JAVA=${JAVA_HOME:+${JAVA_HOME}/bin/}java
EXTENSIONS=ext$(find ext/ -iname "*jar" -printf :%p)
VMOPTS="-Dfile.encoding=UTF-8 -Dogema.resources.useByteCodeGeneration=true -Dorg.osgi.framework.storage.fromlevel=40 -Dorg.ogema.persistence=active -Dfelix.config.properties=file:./config/config.properties"
VMOPTS="$VMOPTS -cp $LAUNCHER:$EXTENSIONS"
CLEAN_ARGS="-Dorg.osgi.framework.storage.clean=onFirstInit"
SECURITY_ARGS="-Dorg.osgi.framework.security=osgi -Djava.security.policy=config/all.policy"

for var in "$@"
do
    echo "Next argument ${var}"
    case $var in
        -clean)
            echo "Case clean"
            VMOPTS="${VMOPTS} ${CLEAN_ARGS}"
            echo "OPT: ${VMOPTS}"
            ;;
        -security)
            echo "Case secure"
            VMOPTS="${VMOPTS} ${SECURITY_ARGS}"
            ;;
        *)
            echo "Case default"
            VMOPTS="${VMOPTS} ${var}"
            ;;
    esac
done

# Determine java version # https://stackoverflow.com/questions/7334754/correct-way-to-check-java-version-from-bash-script
if type -p java; then
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then   
    _java="$JAVA_HOME/bin/java"
else
    echo "Java not found"
    return
fi
version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
if [[ $version == 1.* ]]; then
    version="${version:2}"
fi
version=${version%%.*}
#echo "JAVA version : ${version}"

if [[ "$version" > "8" ]]; then
    echo "greater: ${version}" 
    JAVA="${JAVA} --add-modules java.xml.bind --add-opens=java.base/jdk.internal.loader=ALL-UNNAMED"
else
    echo "lesser: ${version}" 
fi

if [[ " $@ " =~ " --verbose " ]]; then
VMOPTS="$VMOPTS -Dequinox.ds.debug=true -Dequinox.ds.print=true"
echo $JAVA $VMOPTS org.apache.felix.main.Main $OPTIONS $*
fi
echo $JAVA $VMOPTS org.apache.felix.main.Main $OPTIONS

#$JAVA $VMOPTS org.apache.felix.main.Main $OPTIONS $*
$JAVA $VMOPTS org.apache.felix.main.Main $OPTIONS

