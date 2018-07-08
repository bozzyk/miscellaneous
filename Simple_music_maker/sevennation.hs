import MusicComposer

-- main motive

mel1 = lower 1 (dhn e +:+ qn e +:+ dqn g +:+ dqn e +:+ qn d) --tact 1
mel2 = lower 1 (wn c) +:+ lower 2 (wn b) --tact 2

melody = mel1 +:+ mel2 +:+ mel1 +:+ mel2 -- whole melody (phrase)
melPV = mel1 +:+ mel2 +:+ mel1 +:+ (mel2 =:= preVoc) -- mel + preVoc

-- percussions

bassDrumPhrase = loop 16 (hn $ bam 35) -- phrase of bd
bassDrum = hn $ bam 35

-- vocals 1
preVoc = hnr +:+ enr +:+ loop 3 (hn e) -- tact before phrase
voc11 = qn g +:+ qn e +:+ qn e +:+ enr +:+ hnr -- (snr)
voc12 = qnr +:+ enr +:+ qn d +:+ qn e +:+ qn d +:+ qn e +:+ qn d
--voc3 = e 4 en +:+ d 4 en +:+ e 4 en +:+ d 4 en  +:+ e 4 den +:+ rest sn +:+ e 4 en +:+ e 4 en
voc13 = qn e +:+ qn d +:+ qn e +:+ qn d +:+ stretchTrack(1.5) (loop 3 (qn e)) -- triplet at the end

voc1 = voc11 +:+ voc12 +:+ voc13
vocPre1 = voc11 +:+ voc12 +:+ voc13 +:+ preVoc -- voc + preVoc

-- vocals 2
voc21 = loop 2 (qn b) +:+ loop 2 (qn a) +:+ dqn g +:+ dqn fs +:+ hn e
voc22 = loop 3 (qn e) +:+ loop 3 (qn ds) +:+ bn e +:+ enr
--voc22 = times 3 (e 4 en) +:+ tempo(3/4) (times 2 (ds 4 en)) +:+ e 4 wn +:+ rest en

vocPre2 = voc21 +:+ voc22 +:+ preVoc

-- additional defs

melBD = (melody =:= bassDrumPhrase) -- melody + BD
melPBD = (melPV =:= bassDrumPhrase)  -- melody + BD + vocPre (phrase before vocs)
melBDV = (vocPre1 =:= melBD) -- melody + BD + voc (loop)
melBDV2 = (vocPre2 =:= melBD) -- melody + BD + voc2
melBDVend = (voc1 =:= melBD) -- melody - last pre

-- music
--music = melody +:+ melPBD +:+ times 2 melBDV
music = melody +:+ melPBD +:+ loop 2 melBDV +:+ melBDV2 +:+ melBDVend

--out music