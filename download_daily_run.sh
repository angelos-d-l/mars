#!/bin/bash

cd /mirror/ssd/nmmd01/
rm nclplots/*



# DISTANT DIRECTORY
TARGETFOLDER='/mirror/ssd/nmmd01/'

#LOCAL DIRECTORY
SOURCEFOLDER='/nclplots'

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
