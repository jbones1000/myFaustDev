import("stdfaust.lib");

declare options "[midi:on][nvoices:4]";

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

sweep = hslider("sweep", 0.1, 0.001, 2, 0.001);

freqBP1 = hslider("freqBP1", 1000, 50, 12000, 0.1);
qBP1 = hslider("qBP1", 1, 1, 20, 0.01);
freqBP2 = hslider("freqBP2", 2000, 50, 12000, 0.1);
qBP2 = hslider("qBP2", 1, 1, 20, 0.01);


att = hslider("att", 0.001, 0.001, 1, 0.001);
dec = hslider("dec", 0.01, 0.001, 1, 0.001);
rel = hslider("rel", 0.1, 0.001, 4, 0.001);

delAmt = hslider("delAmt", 700, 0, 2000, 1);

env(del, d, g) = _ , en.adsre(att, d, 0, d, gate : @(del) ) * g : *;



process = no.noise *(0.25) <: fi.resonbp( freqBP1, qBP1, 0.45), fi.resonbp(freqBP2, qBP2, 1) :> env(delAmt*1.25, rel, 0.5) :> _ *(gain);