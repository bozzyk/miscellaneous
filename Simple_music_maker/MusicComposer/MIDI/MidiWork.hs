module MusicComposer.MIDI.MidiWork where

import MusicComposer.MusicRepr
import Data.List(sortBy)
import Data.Function (on)
import Control.Arrow(first, second)
import Data.List(sortBy, groupBy, partition)
import qualified Codec.Midi as M

render :: Score -> M.Midi
render s = M.Midi M.SingleTrack (M.TicksPerBeat divisions) [toTrack s]

-- разрешение по времени
divisions :: M.Ticks
divisions = 24

type MidiEvent = Event Double Note

-- группируем по парам: неударные, ударные. Список неударных - список списков событий (нот) для
-- каждого неударного. Список ударных - список событий (нот) для ударного
-- функция "on" как бы объединяет две функции
groupInstr :: Score -> ([[MidiEvent]], [MidiEvent])
groupInstr = first groupByInstrId .
    partition (not . isDrum . eventContent). alignEvents . trackEvents
    where groupByInstrId = groupBy ((==) `on` instrId) .
                           sortBy (compare `on` instrId)

-- устанавливаем инструменты на каналы. Всего 16 каналов (0..15). Девятый для ударных.
-- формируем midi-сообщения
mergeInstr :: ([[MidiEvent]], [MidiEvent]) -> M.Track Double
mergeInstr (instrs, drums) = concat $ drums' : instrs'
    where instrs' = zipWith setChannel ([0 .. 8] ++ [10 .. 15]) instrs
          drums'  = setDrumChannel drums

-- сортируем события по времени, производим квантование времени (fromRealTime) и переходим от
-- абсолютных единиц к относительным (fromAbsTime)
tfmTime :: M.Track Double -> M.Track M.Ticks
tfmTime = M.fromAbsTime . M.fromRealTime (M.TicksPerBeat divisions) . sortBy (compare `on` fst)

-- присоединяем в начало событие, в котором назначаем на канал инструмент
setChannel :: M.Channel -> [MidiEvent] -> M.Track Double
setChannel ch ms = case ms of
    [] -> []
    x:xs -> (0, M.ProgramChange ch (instrId x)) : (concat (map (fromEvent ch) ms))

setDrumChannel :: [MidiEvent] -> M.Track Double
setDrumChannel ms = concat $ map (fromEvent drumChannel) ms
    where drumChannel = 9

instrId = noteInstr . eventContent

-- непосредственно формируем сообщения о начале и конце звучания ноты
fromEvent :: M.Channel -> MidiEvent -> M.Track Double
fromEvent ch e = [
    (eventStart e, noteOn n),
    (eventStart e + eventDur e, noteOff n)]
    where n = clipToMidi $ eventContent e
          noteOn n = M.NoteOn ch (notePitch n) (noteVolume n)
          noteOff n = M.NoteOff ch (notePitch n) 0

-- приводим значения к формату midi
clipToMidi :: Note -> Note
clipToMidi n = n {
    notePitch = clip $ notePitch n,
    noteVolume = clip $ noteVolume n }
    where clip = max 0 . min 127

-- смещаем к 0, если начало в минусе
alignEvents :: [MidiEvent] -> [MidiEvent]
alignEvents es
    | d < 0 = map (delay (abs d)) es
    | otherwise = es
    where d = minimum $ map eventStart es

toTrack :: Score -> M.Track M.Ticks
toTrack = addEndMsg . tfmTime . mergeInstr . groupInstr

addEndMsg :: M.Track M.Ticks -> M.Track M.Ticks
addEndMsg = (++ [(0, M.TrackEnd)])