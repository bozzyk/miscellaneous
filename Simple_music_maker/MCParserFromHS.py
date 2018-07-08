def splitAccord(accord):
    ind1 = accord.index("(")
    ind2 = accord.rindex(")")

    accord = accord[ind1+1:ind2]
    accordSplit = accord.split("=:=")

    return accordSplit

def writingIntoFile(track, fd):
    for part in track:
        if part[0] == ' ': part = part[1:]
        if isinstance(part,list):
            fd.write("{\n")
            writingIntoFile(part, fd)
            fd.write("}\n")
        else:
            fd.write(part + "\n")

    return True

def main(infile = "321.hs", outfile = "tmp.hs"):
    fd = open(infile, "r")
    data = fd.read().split("\n")
    fd.close()

    if not data[-1]: data = data[:-1]

    resTrackList = []

    for track in data:
        if 'music' in track or 'import' in track:
            continue
        trackSplit = track.split("+:+")

        for num, part in enumerate(trackSplit):
            if '=:=' in part:
                trackSplit[num] = splitAccord(part)

        resTrackList += trackSplit

    fd = open(outfile, "w")
    writingIntoFile(resTrackList, fd)
    fd.close()
    
    return True
