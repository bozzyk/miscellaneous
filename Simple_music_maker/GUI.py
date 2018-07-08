#!/usr/bin/python3
# -*- coding: utf-8 -*-
import sys
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from re import findall
import MCParser
import MCParserFromHS
import os

current_track = "track1"
tn = 2
oct = 1
duration = 1
instr_name = "AcousticGrandPiano"
instruments = ["AcousticGrandPiano"     , "BrightAcousticPiano"    , "ElectricGrandPiano"
  ,  "HonkyTonkPiano"         , "RhodesPiano"            , "ChorusedPiano"
  ,  "Harpsichord"            , "Clavinet"               , "Celesta"
  ,  "Glockenspiel"           , "MusicBox"               , "Vibraphone"
  ,  "Marimba"                , "Xylophone"              , "TubularBells"
  ,  "Dulcimer"               , "HammondOrgan"           , "PercussiveOrgan"
  ,  "RockOrgan"              , "ChurchOrgan"            , "ReedOrgan"
  ,  "Accordion"              , "Harmonica"              , "TangoAccordion"
  ,  "AcousticGuitarNylon"    , "AcousticGuitarSteel"    , "ElectricGuitarJazz"
  ,  "ElectricGuitarClean"    , "ElectricGuitarMuted"    , "OverdrivenGuitar"
  ,  "DistortionGuitar"       , "GuitarHarmonics"        , "AcousticBass"
  ,  "ElectricBassFingered"   , "ElectricBassPicked"     , "FretlessBass"
  ,  "SlapBass1"              , "SlapBass2"              , "SynthBass1"
  ,  "SynthBass2"             , "Violin"                 , "Viola"
  ,  "Cello"                  , "Contrabass"             , "TremoloStrings"
  ,  "PizzicatoStrings"       , "OrchestralHarp"         , "Timpani"
  ,  "StringEnsemble1"        , "StringEnsemble2"        , "SynthStrings1"
  ,  "SynthStrings2"          , "ChoirAahs"              , "VoiceOohs"
  ,  "SynthVoice"             , "OrchestraHit"           , "Trumpet"
  ,  "Trombone"               , "Tuba"                   , "MutedTrumpet"
  ,  "FrenchHorn"             , "BrassSection"           , "SynthBrass1"
  ,  "SynthBrass2"            , "SopranoSax"             , "AltoSax"
  ,  "TenorSax"               , "BaritoneSax"            , "Oboe"
  ,  "Bassoon"                , "EnglishHorn"            , "Clarinet"
  ,  "Piccolo"                , "Flute"                  , "Recorder"
  ,  "PanFlute"             , "BlownBottle"            , "Shakuhachi"
  ,  "Whistle"                , "Ocarina"                , "Lead1Square"
  ,  "Lead2Sawtooth"          , "Lead3Calliope"          , "Lead4Chiff"
  ,  "Lead5Charang"           , "Lead6Voice"             , "Lead7Fifths"
  ,  "Lead8BassLead"          , "Pad1NewAge"             , "Pad2Warm"
  ,  "Pad3Polysynth"          , "Pad4Choir"              , "Pad5Bowed"
  ,  "Pad6Metallic"           , "Pad7Halo"               , "Pad8Sweep"
  ,  "FX1Train"               , "FX2Soundtrack"          , "FX3Crystal"
  ,  "FX4Atmosphere"          , "FX5Brightness"          , "FX6Goblins"
  ,  "FX7Echoes"              , "FX8SciFi"               , "Sitar"
  ,  "Banjo"                  , "Shamisen"               , "Koto"
  ,  "Kalimba"                , "Bagpipe"                , "Fiddle"
  ,  "Shanai"                 , "TinkleBell"             , "Agogo"
  ,  "SteelDrums"             , "Woodblock"              , "TaikoDrum"
  ,  "MelodicDrum"            , "SynthDrum"              , "ReverseCymbal"
  ,  "GuitarFretNoise"        , "BreathNoise"            , "Seashore"
  ,  "BirdTweet"              , "TelephoneRing"          , "Helicopter"
  ,  "Applause"               , "Gunshot"]

percussion = ["AcousticBassDrum"
     ,  "BassDrum1"
     ,  "SideStick"
     ,  "AcousticSnare"  , "HandClap"      , "ElectricSnare"  , 'LowFloorTom'
     ,  "ClosedHiHat"    , "HighFloorTom"  , "PedalHiHat"     , "LowTom"
     ,  "OpenHiHat"      , "LowMidTom"     , "HiMidTom"       , "CrashCymbal1"
     ,  "HighTom"        , "RideCymbal1"   , "ChineseCymbal"  , "RideBell"
     ,  "Tambourine"     , "SplashCymbal"  , "Cowbell"        , "CrashCymbal2"
     ,  "Vibraslap"      , "RideCymbal2"   , "HiBongo"        , "LowBongo"
     ,  "MuteHiConga"    , "OpenHiConga"   , "LowConga"       , "HighTimbale"
     ,  "LowTimbale"     , "HighAgogo"     , "LowAgogo"       , "Cabasa"
     ,  "Maracas"        , "ShortWhistle"  , "LongWhistle"    , "ShortGuiro"
     ,  "LongGuiro"      , "Claves"        , "HiWoodBlock"    , "LowWoodBlock"
     ,  "MuteCuica"      , "OpenCuica"     , "MuteTriangle"]

class SimpleMusicMaker(QWidget):

    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        exitAction = QAction('Exit', self)
        exitAction.setShortcut('Ctrl+Q')
        exitAction.triggered.connect(self.quitApp)

        saveAction = QAction('Save',self)
        saveAction.setShortcut('Ctrl+S')
        saveAction.triggered.connect(self.showSaveDialog)


        helpAction = QAction('Help', self)
        helpAction.setShortcut('F1')

        openAction = QAction('Open', self) 
        openAction.setShortcut('Ctrl+O')
        openAction.triggered.connect(self.showOpenDialog)

        toolbar = QToolBar("smth")
        toolbar.addAction(exitAction)
        toolbar.addAction(openAction)
        toolbar.addAction(saveAction)
        toolbar.addAction(helpAction)

        back = QShortcut("Backspace",self)
        back.activated.connect(self.Backspace_pressed)


        C = QPushButton("C",self)
        C.clicked.connect(self.buttonClicked)
        C.setObjectName("C")
        D = QPushButton("D",self)
        D.clicked.connect(self.buttonClicked)
        D.setObjectName("D")
        E = QPushButton("E",self)
        E.clicked.connect(self.buttonClicked)
        E.setObjectName("E")
        F = QPushButton("F",self)
        F.clicked.connect(self.buttonClicked)
        F.setObjectName("F")
        G = QPushButton("G",self)
        G.clicked.connect(self.buttonClicked)
        G.setObjectName("G")
        A = QPushButton("A",self)
        A.clicked.connect(self.buttonClicked)
        A.setObjectName("A")
        B = QPushButton("B",self)
        B.clicked.connect(self.buttonClicked)
        B.setObjectName("B")

        Cs = QPushButton("C#",self)
        Cs.clicked.connect(self.buttonClicked)
        Cs.setObjectName("C#")
        Ds = QPushButton("D#",self)
        Ds.clicked.connect(self.buttonClicked)
        Ds.setObjectName("D#")
        Es = QPushButton("E#",self)
        Es.clicked.connect(self.buttonClicked)
        Es.setObjectName("E#")
        Fs = QPushButton("F#",self)
        Fs.clicked.connect(self.buttonClicked)
        Fs.setObjectName("F#")
        Gs = QPushButton("G#",self)
        Gs.clicked.connect(self.buttonClicked)
        Gs.setObjectName("G#")
        As = QPushButton("A#",self)
        As.clicked.connect(self.buttonClicked)
        As.setObjectName("A#")
        Bs = QPushButton("B#",self)
        Bs.clicked.connect(self.buttonClicked)
        Bs.setObjectName("B#")

        Cb = QPushButton("Cb",self)
        Cb.clicked.connect(self.buttonClicked)
        Cb.setObjectName("Cb")
        Db = QPushButton("Db",self)
        Db.clicked.connect(self.buttonClicked)
        Db.setObjectName("Db")
        Eb = QPushButton("Eb",self)
        Eb.clicked.connect(self.buttonClicked)
        Eb.setObjectName("Eb")
        Fb = QPushButton("Fb",self)
        Fb.clicked.connect(self.buttonClicked)
        Fb.setObjectName("Fb")
        Gb = QPushButton("Gb",self)
        Gb.clicked.connect(self.buttonClicked)
        Gb.setObjectName("Gb")
        Ab = QPushButton("Ab",self)
        Ab.clicked.connect(self.buttonClicked)
        Ab.setObjectName("Ab")
        Bb = QPushButton("Bb",self)
        Bb.clicked.connect(self.buttonClicked)
        Bb.setObjectName("Bb")

        pause = QPushButton("pause",self)
        pause.clicked.connect(self.buttonClicked)


        editor = QTextEdit(self)

        global grid
        grid = QGridLayout()
        grid.setSpacing(10)

        grid.addWidget(self.TracksBox(),0,1,5,1)

        grid.addWidget(C, 0, 3)
        grid.addWidget(D, 0, 4)
        grid.addWidget(E, 0, 5)
        grid.addWidget(F, 0, 6)
        grid.addWidget(G, 0, 7)
        grid.addWidget(A, 0, 8)
        grid.addWidget(B, 0, 9)

        grid.addWidget(Cs, 1, 3)
        grid.addWidget(Ds, 1, 4)
        grid.addWidget(Es, 1, 5)
        grid.addWidget(Fs, 1, 6)
        grid.addWidget(Gs, 1, 7)
        grid.addWidget(As, 1, 8)
        grid.addWidget(Bs, 1, 9)

        grid.addWidget(Cb, 2, 3)
        grid.addWidget(Db, 2, 4)
        grid.addWidget(Eb, 2, 5)
        grid.addWidget(Fb, 2, 6)
        grid.addWidget(Gb, 2, 7)
        grid.addWidget(Ab, 2, 8)
        grid.addWidget(Bb, 2, 9)

        grid.addWidget(pause, 3,6)
        grid.addWidget(self.OctSlider(), 4,3,1,3)
        grid.addWidget(self.DurInput(), 4,7,1,3)

        grid.addWidget(self.CompileMode(), 5,7,1,3)
        grid.addWidget(self.chordsBox(),5,3,1,4)

        grid.addWidget(editor, 0,11,6,5)
        grid.addWidget(toolbar,6,1,1,5)

        grid.addWidget(self.InstrCombo(),4,6)

        self.setLayout(grid)

        self.setGeometry(300, 300, 1400, 500)
        self.setWindowTitle('Simple Music Maker')
        self.show()
    
    def chordsBox(self):

        group_box = QGroupBox("Аккорд")
        group_box.setObjectName("chord")
        hbox = QHBoxLayout()
        
        chord = QTextEdit(self)
        btn = QPushButton("Add",self)
        btn.clicked.connect(self.addChord)
        hbox.addWidget(chord)
        hbox.addWidget(btn)
        group_box.setLayout(hbox)
        return group_box
        
    def addChord(self):
        ch = self.findChild(QGroupBox,"chord").findChild(QTextEdit).toPlainText()
        self.findChild(QTextEdit).append("{\n"+ch+"\n}")
       
    def GetInstr(self):
        return self.findChild(QComboBox).currentText()


    def showOpenDialog(self):
        global tn
        name = QFileDialog.getOpenFileName(self)
        if name[0]:
            MCParserFromHS.main(name[0])
        else: return
        f = open("tmp.hs","r")
        music = f.read()
        f.close()
        
        tracks = []
        t = ''
        
        for k in self.findChildren(QGroupBox):
            if k.title() == "Дорожки": object = k
        for i in music.split("\n"):
            if findall("track",i):
                track_num = findall("track[0-9]+",i)[0]
                if not object.findChild(QRadioButton,track_num):
                    track = QRadioButton(track_num,self)
                    track.setObjectName(track_num)
                    track.clicked.connect(self.TrackSwitch)
                    object.layout().addWidget(track)
                    tn += 1
                if object.findChild(QRadioButton,track_num).isChecked():
            
                    self.updateTrack(track_num)

                    
                
            

    def showSaveDialog(self):
        for i in self.findChildren(QGroupBox):
            if i.title() == "Дорожки":
                for j in i.findChildren(QRadioButton):
                    if j.isChecked():
                        text_to_save = self.findChild(QTextEdit).toPlainText()
                        f = open("tmp.hs","a")
                        f.write('')
                        f.write(j.objectName()+" = " + text_to_save+"\n")
                        f.close()
                        break
                        break

        name = QFileDialog.getSaveFileName(self)
        if name[0]:
            outfile = open(name[0],"w")
            to_save = open("tmp.hs","r").read()
            outfile.write(to_save)
            outfile.close()
            true_name = findall(".+\.",name[0]) or findall(".+",name[0])
            MCParser.main(name[0], true_name[0]+"hs")


    def updateTrack(self,track_name):
        file = open("tmp.hs","r")
        text = file.read()
        file.close()
        lst = text.split("track")
        lst = lst[1:]
        #print (lst[::-1])

        number = []
        for i in lst[::-1]:
            number.append(int(findall("[0-9]+",i)[0]))
        if number:

            num = max(number)
            req_num = int(findall("[0-9]+",track_name)[0])
            for i in lst[::-1]:
                if int(findall("[0-9]+",i)[0]) == req_num:
                    self.findChild(QTextEdit).setText(i[len(str(req_num))+3:len(i)-1])
                    break



    def quitApp(self):
        self.close()



    def Backspace_pressed(self):
        text = self.findChild(QTextEdit).toPlainText()
        new_text = ''
        self.findChild(QTextEdit).clear()
        lst = text.split("\n")
        trunc_lst = []
        for i in lst:
            if i: trunc_lst.append(i)
        for i in trunc_lst[:len(trunc_lst)-1]:
            new_text += i + "\n"
        self.findChild(QTextEdit).setText(new_text[:len(new_text)-1])

    def TracksBox(self):
        self.setObjectName("tracks")
        group_box = QGroupBox("Дорожки")
        plus_track = QPushButton("+",self)
        plus_track.clicked.connect(self.buttonClicked)

        track = QRadioButton("track1",self)
        track.setObjectName("track1")
        track.clicked.connect(self.TrackSwitch)
        track.toggle()
        vbox = QVBoxLayout()
        vbox.addWidget(plus_track)
        vbox.addWidget(track)
        group_box.setLayout(vbox)
        return group_box


    def CompileMode(self):
        group_box = QGroupBox ("Режим")
        group_box.setObjectName("compileMode")
        samebt = QRadioButton("Одновременно", self)
        samebt.clicked.connect(self.CheckBoxChanged)
        samebt.setObjectName("Одновременно")
        seqbt = QRadioButton("Последовательно",self)
        seqbt.clicked.connect(self.CheckBoxChanged)
        seqbt.setObjectName("Последовательно")
        seqbt.toggle()
        vbox = QVBoxLayout()
        vbox.addWidget(samebt)
        vbox.addWidget(seqbt)
        group_box.setLayout(vbox)
        return group_box

    def InstrCombo(self):
        group_box = QGroupBox("Инструмент")
        combo = QComboBox(self)
        combo.addItems(instruments+percussion)
        combo.setObjectName("instr")
        #combo.activated[str].connect(self.changeInstrument)
        vbox = QVBoxLayout()
        vbox.addWidget(combo)

        group_box.setLayout(vbox)
        return group_box


    def OctSlider(self):
        group_box = QGroupBox("Октава")
        slider = QSlider(Qt.Horizontal)
        slider.setFocusPolicy(Qt.StrongFocus)
        slider.setTickPosition(QSlider.TicksBothSides)
        slider.setTickInterval(1)
        slider.setSingleStep(1)
        slider.setMaximum(7)
        slider.setMinimum(1)
        slider.setObjectName("oct")
        slider.setValue(4)
        slider.valueChanged[int].connect(self.changeValue)
        val = QLabel(str(slider.value()),self)
        global vbox_oct
        vbox_oct = QVBoxLayout()
        vbox_oct.addWidget(val)
        vbox_oct.addWidget(slider)
        group_box.setLayout(vbox_oct)

        return group_box

    def DurInput(self):
        group_box = QGroupBox("Длительность")
        line = QLineEdit(self)
        line.setText("1/2")
        lbl = QLabel("Значение")
        vbox = QVBoxLayout()
        vbox.addWidget(lbl)
        vbox.addWidget(line)
        group_box.setLayout(vbox)
        return group_box
        
    def DurSlider(self):
        dur_human = ["1/64","1/32","3/64","1/16","3/32","1/8","3/16","7/32","1/4","3/8","7/16","1/2","3/4","7/8","1","3/2","2"]
        group_box = QGroupBox("Длительность")
        slider = QSlider(Qt.Horizontal)
        slider.setFocusPolicy(Qt.StrongFocus)
        slider.setTickPosition(QSlider.TicksBothSides)
        slider.setTickInterval(1)
        slider.setSingleStep(1)
        slider.setMaximum(16)
        slider.setMinimum(0)
        slider.setObjectName("dur")
        slider.valueChanged[int].connect(self.changeValue)
        val = QLabel(dur_human[slider.value()],self)
        global vbox_dur
        vbox_dur = QVBoxLayout()
        vbox_dur.addWidget(val)
        vbox_dur.addWidget(slider)
        group_box.setLayout(vbox_dur)

        return group_box

    def changeValue(self,value):
        sender = self.sender()
        global oct
        global duration
        dur_human = ["1/64","1/32","3/64","1/16","3/32","1/8","3/16","7/32","1/4","3/8","7/16","1/2","3/4","7/8","1","3/2","2"]
        if sender.objectName() == 'oct':
            oct = sender.value()
            val = str(sender.value())
            vbox_oct.itemAt(0).widget().setText(val)

        if sender.objectName() == 'dur':
            val = dur_human[sender.value()]
            vbox_dur.itemAt(0).widget().setText(val)


    def CheckBoxChanged(self):
        sender = self.sender()
        mode = self.GetMode()
        #if mode == "=:=": self.findChild(QTextEdit).append("{")
        #elif mode == "+:+": self.findChild(QTextEdit).append("}")

        #print (sender.text()+" "+str(sender.isChecked()))

    def GetOct(self):
        return self.findChild(QSlider,"oct").value()

    def GetDur(self):
        #dur_mean = ["sfn","tn","dtn","sn","dsn","en","den","dden","qn","dqn","ddqn","hn","dhn","ddhn","wn","dwn","bn"]
        #return dur_mean[self.findChild(QSlider,"dur").value()]
        return eval(self.findChild(QLineEdit).text())

    def GetMode(self):
        if self.findChild(QRadioButton, "Последовательно").isChecked(): return "+:+"
        elif self.findChild(QRadioButton, "Одновременно").isChecked(): return "=:="

    def GetTrack(self):
        return

    def buttonClicked(self):
        #print(self.findChild(QTextEdit).toPlainText())
        #print (self.GetOct())
        global tn
        sender = self.sender()
        #print (self.findChildren(QGroupBox))
        #for i in self.findChildren(QGroupBox): print (i.title())

        if sender.text() == '+':
            track = QRadioButton("track{num}".format(num = tn),self)
            track.setObjectName("track{num}".format(num = tn))
            track.clicked.connect(self.TrackSwitch)
            for i in self.findChildren(QGroupBox):
                if i.title() == "Дорожки": i.layout().addWidget(track)
            tn += 1
        elif sender.text() in ("C","D","E","F","G","A","B","C#","D#","E#","F#","G#","A#","B#","Cb","Db","Eb","Fb","Gb","Ab","Bb"):
            oct = self.GetOct()
            if oct <= 4: oct = "lower {n}".format(n=4-oct)
            else: oct = "higher {n}".format(n=oct-4)
            dur = "(stretch {v})".format(v=self.GetDur())
            mode = self.GetMode()
            instr = self.GetInstr()
            if instr in instruments: instr = "instr " + instr
            else: instr = "drum " + instr
            p = ''
            for i in sender.text():
                if i not in ("#","b"): p += i.lower()
                elif i == "#": p += "s"
                else: p += "f"
            note = "{ins} ({oc} ({d} {pitch}))".format(oc=oct, d=dur, pitch = p, ins=instr )
            if self.findChild(QGroupBox,"compileMode").findChild(QRadioButton,"Последовательно").isChecked(): self.findChild(QTextEdit).append(note)
            else: self.findChild(QGroupBox,"chord").findChild(QTextEdit).append(note)
        elif sender.text() == "pause":
            dur = self.GetDur()
            note = "(stretch {d}) wnr".format(d=dur)
            self.findChild(QTextEdit).append(note)




    def TrackSwitch(self):
        global current_track

        sender = self.sender()
        text_to_save = self.findChild(QTextEdit).toPlainText()
        f = open("tmp.hs","a")
        f.write(current_track+" = " + text_to_save+"\n")
        f.close()
        self.findChild(QTextEdit).clear()
        current_track = sender.objectName()



        self.updateTrack(current_track)


    def closeEvent(self, event):

        reply = QMessageBox.question(self, 'Exit',
            "Are you sure to quit?\nAll unsaved changes will be lost!", QMessageBox.Yes |
            QMessageBox.No, QMessageBox.No)

        if reply == QMessageBox.Yes:
            f = open("tmp.hs","w")
            f.write('')
            f.close()
            os.remove("tmp.hs")
            event.accept()
        else:
            event.ignore()




if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = SimpleMusicMaker()
    sys.exit(app.exec_())
