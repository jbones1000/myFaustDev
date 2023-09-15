// cricket model
import("stdfaust.lib");

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 2000, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

diff = hslider("diff", 35, 0, 120, 0.001): si.polySmooth(gate,0.999,64);
modAmt = hslider("modAmt", 0.5, 0, 1, 0.001) : si.polySmooth(gate,0.999,64);
phase = hslider("phase", 0.1, 0, 10, 0.001) ;
hz = hslider("hz", 10, 0, 200, 0.01);



freqOsc(f) = f + (osc * freq_depth)
with{
    rate = hslider("rate", 0, 0, 120, 0.001);
    freq_depth = hslider("freq_depth", 100, -2000, 2000, 1);
    osc = 1 - pow( os.phasor(1,rate), 8);
    
};
freqMod = freqOsc(2000);

synth = (os.osc(freqMod)*0.5) * (os.triangle(38)*1);
synth2 = (os.osc(freqMod+4000)*0.5) * (os.triangle(36)*1);

a = hslider("a", 0.01, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 0.8, 0, 1, 0.01);
r = hslider("r", 0.1, 0.001, 4, 0.001);

ampChirp(hz) = _, clip : *
with{
    topSine = max( os.osc(hz), 0) * 10;
    clip = min(topSine, 0.9);
};

process = ((synth*0.5) + (synth2*0.25)) : ampChirp(hz) : *(en.adsre(a,d,s,r,gate)) <: _,_;

