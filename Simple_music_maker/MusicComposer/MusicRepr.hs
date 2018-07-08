{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NamedFieldPuns #-}

module MusicComposer.MusicRepr where
import MusicComposer.MIDI.GeneralMidi

data Event t a = Event {
    eventStart   :: t,
    eventDur     :: t,
    eventContent :: a
    } deriving (Show, Eq)

data Track t a = Track {
    trackDur    :: t,
    trackEvents :: [Event t a]
    }

data Note = Note {
    noteInstr :: Instr,
    noteVolume :: Volume,
    notePitch :: Pitch, -- высота
    isDrum :: Bool } -- ударные ли

type Instr = Int
type Volume = Int
type Pitch = Int

type Score = Track Double Note

delayEvent :: Num t => t -> Event t a -> Event t a
delayEvent d e = e{ eventStart = d + eventStart e }

stretchEvent :: Num t => t -> Event t a -> Event t a
stretchEvent s e = e{
    eventStart = s * eventStart e,
    eventDur   = s * eventDur e }

delayTrack :: Num t => t -> Track t a -> Track t a
delayTrack d (Track t es) = Track (t + d) (map (delayEvent d) es)

stretchTrack :: Num t => t -> Track t a -> Track t a
stretchTrack s (Track t es) = Track (t * s) (map (stretchEvent s) es)

class Temporal a where
    type Dur a :: *
    dur :: a -> Dur a
    delay :: Dur a -> a -> a -- задержка
    stretch :: Dur a -> a -> a -- изменение темпа
    
instance Num t => Temporal (Event t a) where
    type Dur (Event t a) = t
    dur = eventDur
    delay = delayEvent
    stretch = stretchEvent

instance Num t => Temporal (Track t a) where
    type Dur (Track t a) = t
    dur = trackDur
    delay = delayTrack
    stretch = stretchTrack

-- наложение партий
(=:=) :: Ord t => Track t a -> Track t a -> Track t a
Track t es =:= Track t' es' = Track (max t t') (es ++ es')

-- объединение партий (по сути, отсрочка исполнения для второй партии)
(+:+) :: (Ord t, Num t) => Track t a -> Track t a -> Track t a
(+:+) a b = a =:= delay (dur a) b

-- аккорд
chord :: (Num t, Ord t) => [Track t a] -> Track t a
chord = foldr (=:=) (silence 0)

-- перебор
line :: (Num t, Ord t) => [Track t a] -> Track t a
line = foldr (+:+) (silence 0)

--триоль
triple :: Fractional a => Track a t -> Track a t
triple track = stretchTrack (2 / 3) track 


loop :: (Num t, Ord t) => Int -> Track t a -> Track t a
loop n t = line $ replicate n t

-- определим map, удобно менять высоту, инструмент и т.д.
instance Functor (Event t) where
    fmap f e = e{ eventContent = f (eventContent e) }

instance Functor (Track t) where
    fmap f t = t{ trackEvents = fmap (fmap f) (trackEvents t) }

-- 0 - AcousticGrandPiano (см. GeneralMidi)
note :: Int -> Score
note n = Track 1 [Event 0 1 (Note (fromEnum AcousticGrandPiano) 64 (60+n) False)]



--аккорды

--аккорд
majChord :: Score -> Score
majChord x = chord (map f [0, 4, 7]) where
    f i = setPitchInScore ((getPitchFromScore x) + i) x
   

  
getPitchFromScore :: Score -> Pitch
getPitchFromScore (Track _ (x:_)) = notePitch (eventContent x)

setPitchInNote :: Pitch -> Note -> Note
setPitchInNote x n = n {notePitch=x}

setPitchInScore :: Pitch -> Score -> Score
setPitchInScore x (Track d  (y:_)) = Track d [Event 0 d (setPitchInNote x (eventContent y))] 

-- ноты (s - sharp (диез), f - flat (бемоль))
a, b, c, d, e, f, g,
    as, bs, cs, ds, es, fs, gs,
    af, bf, cf, df, ef, ff, gf :: Score

cf = note 0; c = note 0; cs = note 1;
df = note 1;  d = note 2; ds = note 3;
ef = note 3; e = note 4; es = note 4;
ff = note 5; f = note 5; fs = note 6;
gf = note 6; g = note 7; gs = note 8;
af = note 8; a = note 9; as = note 10;
bf = note 10; b = note 11; bs = note 11;

-- увеличение на октаву соответсвует прибавлению 12 к высоте
-- "До" субконтроктавы (нулевой) - 12
-- "До" первой октавы (четвертой) - 60
-- "До" пятой октавы (восьмой) - 108

higher :: Int -> Score -> Score
higher n = fmap (\a -> a{ notePitch = 12*n + notePitch a })

lower :: Int -> Score -> Score
lower n = higher (-n)

high :: Score -> Score
high = higher 1

low :: Score -> Score
low = lower 1

-- Изменение длительности, по дефолту играет в wn (whole note)

bn, hn, qn, en, sn, wn, tn, sfn, dwn, dhn,
    dqn, den, dsn, dtn, ddhn, ddqn, dden :: Score -> Score

bn    = stretch 2;        --  brewis note
wn    = stretch 1;        --  whole note
hn    = stretch 0.5;      --  half note
qn    = stretch 0.25;     --  quarter note
en    = stretch 0.125;    --  eighth note
sn    = stretch 0.0625;   --  sixteenth note
tn    = stretch 0.03125;  --  thirty-second note
sfn   = stretch 0.015625; --  sixty-fourth note 

dwn   = stretch 1.5;      --  dotted whole note (3/2)
dhn   = stretch 0.75;     --  dotted half note (3/4)
dqn   = stretch 0.375;
den   = stretch 0.1875;
dsn   = stretch 0.09375;  
dtn   = stretch 0.046875;

ddhn  = stretch 0.875;    --  double-dotted half note (7/8)
ddqn  = stretch 0.4375;
dden  = stretch 0.21875;

silence t = Track t [] -- пауза содержит только продолжительность

rest :: Double -> Score
rest = silence

wnr = rest 1;
bnr = bn wnr; 
hnr = hn wnr;
qnr = qn wnr; 
enr = en wnr; 
snr = sn wnr;
tnr = tn wnr; 
sfnr = sfn wnr;
-- ...

louder :: Int -> Score -> Score
louder n = fmap $ \a -> a{ noteVolume = n + noteVolume a }

quieter :: Int -> Score -> Score
quieter n = louder (-n)

instr :: InstrumentName -> Score -> Score
instr n = fmap $ \a -> a{ noteInstr = fromEnum n, isDrum = False }

-- в MIDI в случае ударных высота звука кодирует инструмент
drum :: PercussionSound -> Score -> Score
drum n = fmap $ \a -> a{ notePitch = fromEnum n, isDrum = True }

-- 35 - AcousticBassDrum (см. GeneralMidi)
bam :: Int -> Score
bam n = Track 1 [Event 0 1 (Note 0 n (fromEnum AcousticBassDrum) True)]