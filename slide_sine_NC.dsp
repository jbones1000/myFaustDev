import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

att = hslider("att", 0.01, 0.001, 4, 0.001);
dec = hslider("dec", 0.01, 0.001, 4, 0.001);
sus = hslider("sus", 0.5, 0, 1, 0.001);
rel = hslider("rel", 0.1, 0.001, 4, 0.001);

ampA = hslider("ampA", 0.01, 0.001, 4, 0.001);
ampD = hslider("ampD", 0.01, 0.001, 4, 0.001);
ampDepth = hslider("ampDepth", 3, -12, 48, 0.1);

ampMod = _ , en.adsre(ampA, ampD, 0, ampD, gate) * ampDepth : +;
midiGain = (((_ / 127) / 4) + 0.25) * (ma.PI*2)  : sin;
sound = ba.midikey2hz : (os.osc * 0.5) * en.adsre(att, dec, sus, rel, gate) * gain;


process = ba.hz2midikey(freq) : ampMod <: midiGain, sound : * ;

// co.compressor_mono(12, -30, 0.01, 0.1);








