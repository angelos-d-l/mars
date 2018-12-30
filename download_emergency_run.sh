#!/bin/bash

cd /mirror/ssd/nmmd02/
rm plots3/*



# DISTANT DIRECTORY
TARGETFOLDER='/mirror/ssd/nmmd02/'

#LOCAL DIRECTORY
SOURCEFOLDER='/plots3'

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
