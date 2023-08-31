import("stdfaust.lib");

midi = hslider("midi", 45, 0, 127, 1);
midiGain = (((_ / 127) / 4) + 0.25) * (ma.PI*2)  : sin;
//: max(0) : sin;
//(min(127) * ma.PI/2) - 0.25 : 
process = midi : midiGain;