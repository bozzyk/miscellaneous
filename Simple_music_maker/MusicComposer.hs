module MusicComposer (
  module MusicComposer.MusicRepr,
  module MusicComposer.MIDI.MidiWork,
  module MusicComposer.MIDI.GeneralMidi,
  module System.IO,
  exportFile, out
  ) where

import System.IO

import MusicComposer.MIDI.MidiWork
import MusicComposer.MusicRepr
import MusicComposer.MIDI.GeneralMidi
import Codec.Midi
--(>> system "timidity tmp.mid")
out = exportFile "music.mid" . render