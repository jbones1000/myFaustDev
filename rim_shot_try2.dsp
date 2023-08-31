import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

filterF = hslider("filterF", 800, 300, 8000, 0.1);
filterQ = hslider("filterQ", 20, 1, 40, 0.01);

att = hslider("att", 0.001, 0.001, 1, 0.001);
dec = hslider("dec", 0.1, 0.001, 1, 0.001);
rel = hslider("rel", 0.8, 0.001, 4, 0.001);

delAmt = hslider("delAmt", 300, 0, 2000, 1);

env(del, d, g) = _ , en.adsre(att, d, 0, d, gate : @(del) ) * g : *;

partial(i,amp,a,d,s,r,g) = os.osc(freq*i) * amp, en.adsre(a,d,s,r,g) : *;
freqMod = en.adsre(0.0001, 0.001, 0, 0.001, gate);

ring = partial( 1+(freqMod*12), 0.8/3, 0.01, 0.01, 0, 0.01, gate),
        partial( 2.633+(freqMod*12), 0.8/3, 0.001, 0.005, 0, 0.005, gate @(500) ),
        partial( 3.133+(freqMod*12), 0.8/3, 0.001, 0.05, 0, 0.05, gate @(1000) );

process = no.noise * 0.015 : fi.resonhp( filterF+(freqMod*8000), filterQ, 0.5) <: env(0, dec, 1), env(delAmt, dec, 1) :> _, ring :> *(gain);