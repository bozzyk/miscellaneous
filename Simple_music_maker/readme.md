Simple music composer
Edit:
    a) Without GUI:
        -- all tracks should be described as Haskell variables
        -- each track consists of notes superposition (parallel (=:=) or sequential (+:+) playback)
        -- note is instrument code (midi standard), volume and pitch
        -- there is bool flag for drum in note
        -- default instrument code is Acoustic Grand piano
        -- default octave is 4
        -- you can change instrument/octave with "instr"/"upper(lower)" keywords
        -- custom duration can be configured with "stretch <int>" keyword
        -- there are synonyms for duration:
            == wn, hn, qn, en, sn, tn, sfn (whole, half,
                      quarter, eighth, sixteenth, thirty-second, sixty-fourth note)
            == dwn, dhn, dqn, den, dsn, dtn - dotted notes
            == ddhn, ddqn, dden -- double-dotted notes
        -- use keyword "rest" for pause:
            == rest <int> for custom pause
            == wnr, hnr, qnr, enr, snr, tnr, sfnr (whole note rest, etc.)
        -- use "louder"/"quieter" keywords to change volume
        -- use keyword "drum" instead of "instr" for percussion
        -- example: "dhn e =:= (qn e +:+ qn d)"

    b) Using graphic interface:
        -- composition consists of tracks parallel playback;
              you can add tracks by clicking "+" button in upper left area
        -- switch to "Sequential" radio button to edit "Chord" field;
              then click on "Add" to add chord to current track
        -- instrument panel in the bottom of app window contains "exit", "open",
              "save" menus
        -- I suppose, other elements of the app windows are easy to work with

Launch:
        -- write your composition
        -- save file with ".hs" extension
        -- launch that file
        -- type "out %final_composition_name%" in appeared console window
            (type "out music" if you're using GUI)
        -- get your .mid file and launch it with your media player

Please send all questions on bozzyk44@gmail.com
