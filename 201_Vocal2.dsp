import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 300, 20, 8000, 0.001);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001);

vibGain = hslider("vibGain", 0.5, 0, 12, 0.01);
vibRate = hslider("vibRate", 0.5, 0, 10, 0.01);
voiceType = hslider("voiceType", 1, 0, 4, 0.01) ;
noise = hslider("noise", 0.01, 0, 1, 0.01) ;


att = hslider("att", 0.1, 0.001, 2, 0.001);
dec = hslider("dec", 0.4, 0.001, 2, 0.001);
sus = hslider("sus", 0.5, 0, 1, 0.001);
rel = hslider("rel", 0.4, 0.001, 2, 0.001);
 
vowel = hslider("vowel", 0.5, 0, 4, 0.01) : si.polySmooth(gate,0.999,10);
vibrato(g,r) = os.osc(r) * g;
// convert to midi for scaled vibrato range, convert back to hz
newFreq = ba.midikey2hz( ba.hz2midikey(freq) + vibrato(vibGain,vibRate) );

process =  en.adsre(att, dec, sus, rel, gate), 
           pm.SFFormantModelBP( voiceType, vowel, 0.01, freq, 0.1) * (gain) 
           : *;