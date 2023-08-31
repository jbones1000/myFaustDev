import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

filtBot = hslider("filtBot", 500, 20, 10000, 1);

att = hslider("att", 0.001, 0.001, 1, 0.001);
dec = hslider("dec", 0.1, 0.001, 8, 0.001);
noiseAmp = hslider("noiseAmp", 0.09, 0, 1, 0.001);
noiseDec = hslider("noiseDec", 0.1, 0.001, 8, 0.001);

operator(f, a, d, s, r, amp) =  os.oscp(f) * en.adsre(a,d,s,r,gate) * amp;
partial(i,amp,a,d,s,r) = os.osc(freq*i) * amp, en.adsre(a,d,s,r,gate) : *;
freqMod = en.adsre(0.001, 0.002, 0, 0.002, gate);

opera = partial( 1.333+(freqMod*12), 0.8/3, 0.01, 0.1, 0, 0.1), 
        partial( 2.1 +(freqMod*12), 0.8/3, 0.001, 0.03, 0, 0.03),
        partial( 3.34 +(freqMod*2), 0.8/2, 0.001, 0.01, 0, 0.01),
        partial( 5.34 +(freqMod*2), 0.8/4, 0.001, 0.01, 0, 0.01)
        
        :> _;

noiser = (no.noise*0.1) * noiseAmp, en.adsre( 0.001, noiseDec, 0, noiseDec, gate) : *;
filter = fi.resonbp(filtBot+(freqMod*5000), 1, 1);

process =  (opera*0.5), (noiser:filter) :>  *(gain);