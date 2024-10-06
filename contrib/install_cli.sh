 #!/usr/bin/env bash

 # Execute this file to install the akitacoin cli tools into your path on OS X

 CURRENT_LOC="$( cd "$(dirname "$0")" ; pwd -P )"
 LOCATION=${CURRENT_LOC%Akitacoin-Qt.app*}

 # Ensure that the directory to symlink to exists
 sudo mkdir -p /usr/local/bin

 # Create symlinks to the cli tools
 sudo ln -s ${LOCATION}/Akitacoin-Qt.app/Contents/MacOS/akitacoind /usr/local/bin/akitacoind
 sudo ln -s ${LOCATION}/Akitacoin-Qt.app/Contents/MacOS/akitacoin-cli /usr/local/bin/akitacoin-cli
