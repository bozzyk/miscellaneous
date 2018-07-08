module MusicComposer.MIDI.GeneralMidi where 

data InstrumentName =
     AcousticGrandPiano     | BrightAcousticPiano    | ElectricGrandPiano
  |  HonkyTonkPiano         | RhodesPiano            | ChorusedPiano
  |  Harpsichord            | Clavinet               | Celesta 
  |  Glockenspiel           | MusicBox               | Vibraphone  
  |  Marimba                | Xylophone              | TubularBells
  |  Dulcimer               | HammondOrgan           | PercussiveOrgan 
  |  RockOrgan              | ChurchOrgan            | ReedOrgan
  |  Accordion              | Harmonica              | TangoAccordion
  |  AcousticGuitarNylon    | AcousticGuitarSteel    | ElectricGuitarJazz
  |  ElectricGuitarClean    | ElectricGuitarMuted    | OverdrivenGuitar
  |  DistortionGuitar       | GuitarHarmonics        | AcousticBass
  |  ElectricBassFingered   | ElectricBassPicked     | FretlessBass
  |  SlapBass1              | SlapBass2              | SynthBass1   
  |  SynthBass2             | Violin                 | Viola  
  |  Cello                  | Contrabass             | TremoloStrings
  |  PizzicatoStrings       | OrchestralHarp         | Timpani
  |  StringEnsemble1        | StringEnsemble2        | SynthStrings1
  |  SynthStrings2          | ChoirAahs              | VoiceOohs
  |  SynthVoice             | OrchestraHit           | Trumpet
  |  Trombone               | Tuba                   | MutedTrumpet
  |  FrenchHorn             | BrassSection           | SynthBrass1
  |  SynthBrass2            | SopranoSax             | AltoSax 
  |  TenorSax               | BaritoneSax            | Oboe  
  |  Bassoon                | EnglishHorn            | Clarinet
  |  Piccolo                | Flute                  | Recorder
  |  PanFlute               | BlownBottle            | Shakuhachi
  |  Whistle                | Ocarina                | Lead1Square
  |  Lead2Sawtooth          | Lead3Calliope          | Lead4Chiff
  |  Lead5Charang           | Lead6Voice             | Lead7Fifths
  |  Lead8BassLead          | Pad1NewAge             | Pad2Warm
  |  Pad3Polysynth          | Pad4Choir              | Pad5Bowed
  |  Pad6Metallic           | Pad7Halo               | Pad8Sweep
  |  FX1Train               | FX2Soundtrack          | FX3Crystal
  |  FX4Atmosphere          | FX5Brightness          | FX6Goblins
  |  FX7Echoes              | FX8SciFi               | Sitar
  |  Banjo                  | Shamisen               | Koto
  |  Kalimba                | Bagpipe                | Fiddle 
  |  Shanai                 | TinkleBell             | Agogo  
  |  SteelDrums             | Woodblock              | TaikoDrum
  |  MelodicDrum            | SynthDrum              | ReverseCymbal
  |  GuitarFretNoise        | BreathNoise            | Seashore
  |  BirdTweet              | TelephoneRing          | Helicopter
  |  Applause               | Gunshot                | Percussion
  |  CustomInstrument String
    deriving (Show, Eq, Ord)

data PercussionSound =
        AcousticBassDrum  --  MIDI Key 35
     |  BassDrum1         --  MIDI Key 36
     |  SideStick         --  ...
     |  AcousticSnare  | HandClap      | ElectricSnare  | LowFloorTom
     |  ClosedHiHat    | HighFloorTom  | PedalHiHat     | LowTom
     |  OpenHiHat      | LowMidTom     | HiMidTom       | CrashCymbal1
     |  HighTom        | RideCymbal1   | ChineseCymbal  | RideBell
     |  Tambourine     | SplashCymbal  | Cowbell        | CrashCymbal2
     |  Vibraslap      | RideCymbal2   | HiBongo        | LowBongo
     |  MuteHiConga    | OpenHiConga   | LowConga       | HighTimbale
     |  LowTimbale     | HighAgogo     | LowAgogo       | Cabasa
     |  Maracas        | ShortWhistle  | LongWhistle    | ShortGuiro
     |  LongGuiro      | Claves        | HiWoodBlock    | LowWoodBlock
     |  MuteCuica      | OpenCuica     | MuteTriangle
     |  OpenTriangle
   deriving (Show,Eq,Ord)

instance Enum PercussionSound where
  fromEnum AcousticBassDrum = 35
  fromEnum BassDrum1 = 36
  fromEnum SideStick = 37
  fromEnum AcousticSnare = 38
  fromEnum HandClap = 39
  fromEnum ElectricSnare = 40
  fromEnum LowFloorTom = 41
  fromEnum ClosedHiHat = 42
  fromEnum HighFloorTom = 43
  fromEnum PedalHiHat  = 44
  fromEnum LowTom = 45
  fromEnum OpenHiHat = 46
  fromEnum LowMidTom = 47
  fromEnum HiMidTom = 48
  fromEnum CrashCymbal1  = 49
  fromEnum HighTom = 50
  fromEnum RideCymbal1 = 51
  fromEnum ChineseCymbal = 52
  fromEnum RideBell = 53
  fromEnum Tambourine = 54
  fromEnum SplashCymbal = 55 
  fromEnum Cowbell = 56
  fromEnum CrashCymbal2 = 57
  fromEnum Vibraslap = 58
  fromEnum RideCymbal2 = 59
  fromEnum HiBongo = 60
  fromEnum LowBongo = 61
  fromEnum MuteHiConga = 62
  fromEnum OpenHiConga = 63
  fromEnum LowConga = 64
  fromEnum HighTimbale = 65
  fromEnum LowTimbale = 66
  fromEnum HighAgogo = 67
  fromEnum LowAgogo = 68
  fromEnum Cabasa = 69
  fromEnum Maracas = 70
  fromEnum ShortWhistle = 71
  fromEnum LongWhistle = 72
  fromEnum ShortGuiro = 73
  fromEnum LongGuiro = 74
  fromEnum Claves = 75
  fromEnum HiWoodBlock = 76
  fromEnum LowWoodBlock = 77
  fromEnum MuteCuica = 78
  fromEnum OpenCuica = 79
  fromEnum MuteTriangle = 80
  fromEnum OpenTriangle = 81
  
  toEnum 35 = AcousticBassDrum
  toEnum 36 = BassDrum1
  toEnum 37 = SideStick
  toEnum 38 = AcousticSnare
  toEnum 39 = HandClap
  toEnum 40 = ElectricSnare
  toEnum 41 = LowFloorTom
  toEnum 42 = ClosedHiHat
  toEnum 43 = HighFloorTom
  toEnum 44 = PedalHiHat
  toEnum 45 = LowTom
  toEnum 46 = OpenHiHat
  toEnum 47 = LowMidTom
  toEnum 48 = HiMidTom
  toEnum 49 = CrashCymbal1
  toEnum 50 = HighTom
  toEnum 51 = RideCymbal1
  toEnum 52 = ChineseCymbal
  toEnum 53 = RideBell
  toEnum 54 = Tambourine
  toEnum 55 = SplashCymbal
  toEnum 56 = Cowbell
  toEnum 57 = CrashCymbal2
  toEnum 58 = Vibraslap
  toEnum 59 = RideCymbal2
  toEnum 60 = HiBongo
  toEnum 61 = LowBongo
  toEnum 62 = MuteHiConga
  toEnum 63 = OpenHiConga
  toEnum 64 = LowConga
  toEnum 65 = HighTimbale
  toEnum 66 = LowTimbale
  toEnum 67 = HighAgogo
  toEnum 68 = LowAgogo
  toEnum 69 = Cabasa
  toEnum 70 = Maracas
  toEnum 71 = ShortWhistle
  toEnum 72 = LongWhistle
  toEnum 73 = ShortGuiro
  toEnum 74 = LongGuiro
  toEnum 75 = Claves
  toEnum 76 = HiWoodBlock
  toEnum 77 = LowWoodBlock
  toEnum 78 = MuteCuica
  toEnum 79 = OpenCuica
  toEnum 80 = MuteTriangle
  toEnum 81 = OpenTriangle
  toEnum n = error $ "toEnum: " ++ show n ++ " is not implemented for PercussionSound"
  
instance Enum InstrumentName where
  fromEnum AcousticGrandPiano = 0
  fromEnum BrightAcousticPiano = 1
  fromEnum ElectricGrandPiano = 2
  fromEnum HonkyTonkPiano = 3
  fromEnum RhodesPiano = 4
  fromEnum ChorusedPiano = 5
  fromEnum Harpsichord = 6
  fromEnum Clavinet = 7
  fromEnum Celesta = 8
  fromEnum Glockenspiel = 9
  fromEnum MusicBox = 10
  fromEnum Vibraphone = 11
  fromEnum Marimba = 12
  fromEnum Xylophone = 13
  fromEnum TubularBells = 14
  fromEnum Dulcimer = 15
  fromEnum HammondOrgan = 16
  fromEnum PercussiveOrgan = 17
  fromEnum RockOrgan = 18
  fromEnum ChurchOrgan = 19
  fromEnum ReedOrgan = 20
  fromEnum Accordion = 21
  fromEnum Harmonica = 22
  fromEnum TangoAccordion = 23
  fromEnum AcousticGuitarNylon = 24
  fromEnum AcousticGuitarSteel = 25
  fromEnum ElectricGuitarJazz = 26
  fromEnum ElectricGuitarClean = 27
  fromEnum ElectricGuitarMuted = 28
  fromEnum OverdrivenGuitar = 29
  fromEnum DistortionGuitar = 30
  fromEnum GuitarHarmonics = 31
  fromEnum AcousticBass = 32
  fromEnum ElectricBassFingered = 33
  fromEnum ElectricBassPicked = 34
  fromEnum FretlessBass = 35
  fromEnum SlapBass1 = 36
  fromEnum SlapBass2 = 37
  fromEnum SynthBass1 = 38
  fromEnum SynthBass2 = 39
  fromEnum Violin = 40
  fromEnum Viola = 41
  fromEnum Cello = 42
  fromEnum Contrabass = 43
  fromEnum TremoloStrings = 44
  fromEnum PizzicatoStrings = 45
  fromEnum OrchestralHarp = 46
  fromEnum Timpani = 47
  fromEnum StringEnsemble1 = 48
  fromEnum StringEnsemble2 = 49
  fromEnum SynthStrings1 = 50
  fromEnum SynthStrings2 = 51
  fromEnum ChoirAahs = 52
  fromEnum VoiceOohs = 53
  fromEnum SynthVoice = 54
  fromEnum OrchestraHit = 55
  fromEnum Trumpet = 56
  fromEnum Trombone = 57
  fromEnum Tuba = 58
  fromEnum MutedTrumpet = 59
  fromEnum FrenchHorn = 60
  fromEnum BrassSection = 61
  fromEnum SynthBrass1 = 62
  fromEnum SynthBrass2 = 63
  fromEnum SopranoSax = 64
  fromEnum AltoSax = 65
  fromEnum TenorSax = 66
  fromEnum BaritoneSax = 67
  fromEnum Oboe = 68
  fromEnum EnglishHorn = 69
  fromEnum Bassoon = 70
  fromEnum Clarinet = 71
  fromEnum Piccolo = 72
  fromEnum Flute = 73
  fromEnum Recorder = 74
  fromEnum PanFlute = 75
  fromEnum BlownBottle = 76
  fromEnum Shakuhachi = 77
  fromEnum Whistle = 78
  fromEnum Ocarina = 79
  fromEnum Lead1Square = 80
  fromEnum Lead2Sawtooth = 81
  fromEnum Lead3Calliope = 82
  fromEnum Lead4Chiff = 83
  fromEnum Lead5Charang = 84
  fromEnum Lead6Voice = 85
  fromEnum Lead7Fifths = 86
  fromEnum Lead8BassLead = 87
  fromEnum Pad1NewAge = 88
  fromEnum Pad2Warm = 89
  fromEnum Pad3Polysynth = 90
  fromEnum Pad4Choir = 91
  fromEnum Pad5Bowed = 92
  fromEnum Pad6Metallic = 93
  fromEnum Pad7Halo = 94
  fromEnum Pad8Sweep = 95
  fromEnum FX1Train = 96
  fromEnum FX2Soundtrack = 97
  fromEnum FX3Crystal = 98
  fromEnum FX4Atmosphere = 99
  fromEnum FX5Brightness = 100
  fromEnum FX6Goblins = 101
  fromEnum FX7Echoes = 102
  fromEnum FX8SciFi = 103
  fromEnum Sitar = 104
  fromEnum Banjo = 105
  fromEnum Shamisen = 106
  fromEnum Koto = 107
  fromEnum Kalimba = 108
  fromEnum Bagpipe = 109
  fromEnum Fiddle = 110
  fromEnum Shanai = 111
  fromEnum TinkleBell = 112
  fromEnum Agogo = 113
  fromEnum SteelDrums = 114
  fromEnum Woodblock = 115
  fromEnum TaikoDrum = 116
  fromEnum MelodicDrum = 117
  fromEnum SynthDrum = 118
  fromEnum ReverseCymbal = 119
  fromEnum GuitarFretNoise = 120
  fromEnum BreathNoise = 121
  fromEnum Seashore = 122
  fromEnum BirdTweet = 123
  fromEnum TelephoneRing = 124
  fromEnum Helicopter = 125
  fromEnum Applause = 126
  fromEnum Gunshot = 127
  fromEnum i = error $ "fromEnum: " ++ show i ++ " is not implemented"

  toEnum 0 = AcousticGrandPiano 
  toEnum 1 = BrightAcousticPiano 
  toEnum 2 = ElectricGrandPiano 
  toEnum 3 = HonkyTonkPiano 
  toEnum 4 = RhodesPiano 
  toEnum 5 = ChorusedPiano 
  toEnum 6 = Harpsichord 
  toEnum 7 = Clavinet 
  toEnum 8 = Celesta 
  toEnum 9 = Glockenspiel 
  toEnum 10 = MusicBox 
  toEnum 11 = Vibraphone 
  toEnum 12 = Marimba 
  toEnum 13 = Xylophone 
  toEnum 14 = TubularBells 
  toEnum 15 = Dulcimer 
  toEnum 16 = HammondOrgan 
  toEnum 17 = PercussiveOrgan 
  toEnum 18 = RockOrgan 
  toEnum 19 = ChurchOrgan 
  toEnum 20 = ReedOrgan 
  toEnum 21 = Accordion 
  toEnum 22 = Harmonica 
  toEnum 23 = TangoAccordion 
  toEnum 24 = AcousticGuitarNylon 
  toEnum 25 = AcousticGuitarSteel 
  toEnum 26 = ElectricGuitarJazz 
  toEnum 27 = ElectricGuitarClean 
  toEnum 28 = ElectricGuitarMuted 
  toEnum 29 = OverdrivenGuitar 
  toEnum 30 = DistortionGuitar 
  toEnum 31 = GuitarHarmonics 
  toEnum 32 = AcousticBass 
  toEnum 33 = ElectricBassFingered 
  toEnum 34 = ElectricBassPicked 
  toEnum 35 = FretlessBass 
  toEnum 36 = SlapBass1 
  toEnum 37 = SlapBass2 
  toEnum 38 = SynthBass1 
  toEnum 39 = SynthBass2 
  toEnum 40 = Violin 
  toEnum 41 = Viola 
  toEnum 42 = Cello 
  toEnum 43 = Contrabass 
  toEnum 44 = TremoloStrings 
  toEnum 45 = PizzicatoStrings 
  toEnum 46 = OrchestralHarp 
  toEnum 47 = Timpani 
  toEnum 48 = StringEnsemble1 
  toEnum 49 = StringEnsemble2 
  toEnum 50 = SynthStrings1 
  toEnum 51 = SynthStrings2 
  toEnum 52 = ChoirAahs 
  toEnum 53 = VoiceOohs 
  toEnum 54 = SynthVoice 
  toEnum 55 = OrchestraHit 
  toEnum 56 = Trumpet 
  toEnum 57 = Trombone 
  toEnum 58 = Tuba 
  toEnum 59 = MutedTrumpet 
  toEnum 60 = FrenchHorn 
  toEnum 61 = BrassSection 
  toEnum 62 = SynthBrass1 
  toEnum 63 = SynthBrass2 
  toEnum 64 = SopranoSax 
  toEnum 65 = AltoSax 
  toEnum 66 = TenorSax 
  toEnum 67 = BaritoneSax 
  toEnum 68 = Oboe 
  toEnum 69 = EnglishHorn 
  toEnum 70 = Bassoon 
  toEnum 71 = Clarinet 
  toEnum 72 = Piccolo 
  toEnum 73 = Flute 
  toEnum 74 = Recorder 
  toEnum 75 = PanFlute 
  toEnum 76 = BlownBottle 
  toEnum 77 = Shakuhachi 
  toEnum 78 = Whistle 
  toEnum 79 = Ocarina 
  toEnum 80 = Lead1Square 
  toEnum 81 = Lead2Sawtooth 
  toEnum 82 = Lead3Calliope 
  toEnum 83 = Lead4Chiff 
  toEnum 84 = Lead5Charang 
  toEnum 85 = Lead6Voice 
  toEnum 86 = Lead7Fifths 
  toEnum 87 = Lead8BassLead 
  toEnum 88 = Pad1NewAge 
  toEnum 89 = Pad2Warm 
  toEnum 90 = Pad3Polysynth 
  toEnum 91 = Pad4Choir 
  toEnum 92 = Pad5Bowed 
  toEnum 93 = Pad6Metallic 
  toEnum 94 = Pad7Halo 
  toEnum 95 = Pad8Sweep 
  toEnum 96 = FX1Train 
  toEnum 97 = FX2Soundtrack 
  toEnum 98 = FX3Crystal 
  toEnum 99 = FX4Atmosphere 
  toEnum 100 = FX5Brightness 
  toEnum 101 = FX6Goblins 
  toEnum 102 = FX7Echoes 
  toEnum 103 = FX8SciFi 
  toEnum 104 = Sitar 
  toEnum 105 = Banjo 
  toEnum 106 = Shamisen 
  toEnum 107 = Koto 
  toEnum 108 = Kalimba 
  toEnum 109 = Bagpipe 
  toEnum 110 = Fiddle 
  toEnum 111 = Shanai 
  toEnum 112 = TinkleBell 
  toEnum 113 = Agogo 
  toEnum 114 = SteelDrums 
  toEnum 115 = Woodblock 
  toEnum 116 = TaikoDrum 
  toEnum 117 = MelodicDrum 
  toEnum 118 = SynthDrum 
  toEnum 119 = ReverseCymbal 
  toEnum 120 = GuitarFretNoise 
  toEnum 121 = BreathNoise 
  toEnum 122 = Seashore 
  toEnum 123 = BirdTweet 
  toEnum 124 = TelephoneRing 
  toEnum 125 = Helicopter 
  toEnum 126 = Applause 
  toEnum 127 = Gunshot 
  toEnum n = error $ "toEnum: " ++ show n ++ " is not implemented for InstrumentName"
