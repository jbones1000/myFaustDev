import("stdfaust.lib");

declare options "[midi:on][nvoices:4]";

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

freqDepth = hslider("freqDepth", 12, -24, 24, 0.1);

attF = hslider("freqAttack", 0.001, 0.001, 1, 0.001);
decF = hslider("freqDecay", 0.05, 0.001, 1, 0.001);

att = hslider("att", 0.001, 0.001, 1, 0.001);
dec = hslider("dec", 0.5, 0.001, 5, 0.001);

freqEnv(d) = en.adsre(attF, decF, 0, decF, gate) * d;
ampEnv = _, en.adsre(att, dec, 0, dec, gate) : *;

midiGain = (((ba.hz2midikey(freq)/ 127) / 4) + 0.25) * (ma.PI*2)  : sin;

freqModder = ba.midikey2hz( ba.hz2midikey( freq ) + freqEnv(freqDepth));

process = (os.oscp( freqModder, 0 ) * midiGain) * 0.5 : ampEnv * gain;