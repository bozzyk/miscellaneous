def doAnalysis(Track):
    while '{' in Track:
        ind = Track.index('{')
        if '}' in Track:
            ind2 = Track.index('}')
            Track = Track[:ind] + [Track[ind+1:ind2]] + Track[ind2+1:]
        else:
            Track = Track[:ind] + [Track[ind+1:]]
    return Track

def makeTogether(track):
    if isinstance(track, list):
        res = track[0]
        for note in track[1:]:
            res = res + '=:= ' + note
        res = res
        return "(" + res + ")"
    else: return track
    
def makeTogetherFinal(track):
    if isinstance(track, list):
        res = track[0]
        for note in track[1:]:
            res = res + '=:= ' + note
        res = res
        return res
    else: return track

def makeHaskellMusic(dataDict):
    musicDict = dataDict.copy()
    for trackName in dataDict:
        trackStr = "{} = {}".format(trackName, makeTogether(dataDict[trackName][0]))
        for note in dataDict[trackName][1:]:
            trackStr = trackStr + '+:+ ' + makeTogether(note)
        musicDict[trackName] = trackStr
    return musicDict

def main (infile, outfile):
    fd = open(infile, "r")
    data = fd.read().split("\n")
    fd.close()

    if not data[-1]:
        data = data[:-1]

    dataTrack = []
    dataDict = {}
    currentKey = -1

    for i in data:
        if 'track' in i:
            if currentKey != -1:
                dataDict.update({currentKey : dataTrack})
                dataTrack = []
            l = i.partition(" = ")
            currentKey = l[0]
            dataTrack += [l[2]]
        else:
            dataTrack += [i]

    dataDict.update({currentKey : dataTrack})

    for i in dataDict:
        dataDict.update({i : doAnalysis(dataDict[i])})

    dictMusic = makeHaskellMusic(dataDict)

    Music = [i for i in dictMusic.values()]
    Music += ["music = " + makeTogetherFinal(list(dictMusic.keys()))]

    fd = open(outfile, "w")
    fd.write("import MusicComposer\n")
    for i in Music:
        fd.write(i + "\n")
    fd.close()
