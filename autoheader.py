import sys

if len(sys.argv) != 2:
    print("usage: autoheader.py <markdown file>")
else:
    file_name = sys.argv[1]
    file = open(file_name)

    result = ""

    for line in file.readlines():
        if len(line) > 3:
            id = None
            text = None
            level = None
            if line[0:2] == "<h": #HTML like header
                id = line.split("id=\"")[1].split("\"")[0]
                if id == "ToC":
                    id = None
                    continue
                level = int(line[2])
                text = line.split("</a>")[1].split("</")[0].strip()
            elif line[0:3] == ":::":
                splited = line.split(" ")
                if splited[1] == "title":
                    id = splited[3]
                    level = int(splited[2])
                    if "\"" in line:
                        text = line.split("\"")[1].split("\"")[0]
                    else:
                        text = splited[4].split("\n")[0]

            if id != None:
                result += ("    " * (level-1)) + "- [**" + text + "**](#" + id + ")\n"
print(result)
