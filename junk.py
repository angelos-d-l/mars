s = s.replace('mickey', 'minnie')
f = open("mount.txt", 'w')
f.write(s)
f.close()

import fileinput
for line in fileinput.FileInput("file", inplace=1):
    line=line.replace("old","new")
    print line


import re
#fstab location, use w mode as need to overwrite whole file.
s = open("/usr2/py/mount.txt","r")
#temp txt file to store new mount.
tmpfile = open("/usr2/py/tmp.txt","a")
#new nas mount point
newmount = open("/usr2/py/newmount.txt","r")
#search pg-swnas1 line
for line in s.readlines():
    if re.search("filer", line, re.IGNORECASE) != None:
        print line
    else:
        tmpfile.write(line)
#read the latest mount point
readmount = newmount.read()
#append to temp file
tmpfile.write(readmount)
s.close()
tmpfile.close()
tmpfile = open("/usr2/py/tmp.txt","r")
readtmp = tmpfile.read()
s = open("/usr2/py/mount.txt","w")
s.write(readtmp)

tmpfile.close()
newmount.close()


mountList = open("/usr2/py/mount.txt", "r").readlines()
newmountList = open("/usr2/py/newmount.txt","r").readlines()
outputList = [item for item in mountList if "filer" not in item.lower()]
outputList.extend(newmountList)
f = open("/usr2/py/mount.txt","w")
f.write(''.join(outputList))
f.close()