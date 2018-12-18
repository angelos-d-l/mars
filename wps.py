import os

work_path = "/home/angelos.d.lampiris/uems/uems/runs/bench"
os.chdir(work_path)
s = open("./namelist.wps", "r")

newString = ", '/home/angelos.d.lampiris/uems/uems/runs/bench/wpsprd/ICONX3D'\n"

if os.path.exists("tmp.txt"):
    os.remove("tmp.txt")
else:
    print("The tmp.txt file does not exist")

tmp = open("./tmp.txt", "a")

for line in s.readlines():
    if "fg_name" in line:
        line = line + newString
        print(line)
        tmp.write(line)
    else:
        tmp.write(line)
