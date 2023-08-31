// simple 2 operator fm synth

// declare options "[midi:on][nvoices:12]";
// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001);

modAmt = hslider("[0] modAmt", 0.5, 0, 2, 0.01) : si.polySmooth(gate, 0.999, 10);
modIndex = hslider("[1] modIndex", 2, 0, 18, 0.01) : si.polySmooth(gate, 0.999, 10);

fb1 = hslider("[6] fb1", 0, 0, 0.49, 0.01);
fb2 = hslider("[92] fb2", 0, 0, 0.49, 0.01);

//carrier adsr
a1 = hslider("[2] a1", 0.01, 0.001, 4, 0.001);
d1 = hslider("[3] d1", 1, 0.001, 4, 0.001);
s1 = hslider("[4] s1", 0.8, 0, 1, 0.01);
r1 = hslider("[5] r1", 2, 0.001, 4, 0.001);

// modulator adsr
a2 = hslider("[7] a2", 0.001, 0.001, 4, 0.001);
d2 = hslider("[8] d2", 0.1, 0.001, 4, 0.001);
s2 = hslider("[9] s2", 0.2, 0, 1, 0.01);
r2 = hslider("[91] r2", 0.5, 0.001, 4, 0.001);

//feedback(a) = _ : +~ (*(a) : fi.zero(-1));
// ring mod
ringMod(f) = _, os.osc(f) : *;
// phase mod 
fmoder(f) = _, os.phasor(1,f) : + : * (ma.PI*2) : cos; 

op(f, a, d, s, r, amp) = ringMod(f) * en.adsre(a,d,s,r,gate) * amp;

process = 1 : op(freq*modIndex, a2, d2, s2, r2, modAmt ) : op(freq, a1, d1, s1, r1, 0.5) * ((gain/2) + 0.5);

