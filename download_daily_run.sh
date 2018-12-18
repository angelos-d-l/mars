#!/bin/bash

cd /mirror/ssd/nmmd01/
rm *



# DISTANT DIRECTORY
TARGETFOLDER='/mirror/ssd/nmmd01/'

#LOCAL DIRECTORY
SOURCEFOLDER='/plots'

HOST='files.antimeteo.gr'
USER='angelos'
PASS='al578899!'

lftp -f "
set ftp:ssl-allow no
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --only-newer --continue --parallel=100   --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"
