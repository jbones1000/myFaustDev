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

modAmt = hslider("[0] modAmt", 0.5, 0, 12, 0.01) : si.polySmooth(gate, 0.999, 64);
modIndex = hslider("[1] modIndex", 2, 0, 18, 0.01) : si.polySmooth(gate, 0.999, 64);
skew = hslider("skew [midi:ctrl 1 1]", 3, 0, 24, 0.001) : si.polySmooth(gate, 0.999, 64);
fb1 = hslider("[6] fb1", 0, 0, 5, 0.01);
fb2 = hslider("[92] fb2", 0, 0, 5, 0.01);

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


phaseMod(f,fb, modd) = modd : op(f)~ *(fb)
with{
    op(f, mod) = _, mod : + : os.oscp(f) *(0.5);
};

operator(f, a, d, s, r, amp, fb) = phaseMod(f,fb) * en.adsre(a,d,s,r,gate) * gain * amp;



process = 0 : operator(freq*modIndex, a2, d2, s2, r2, modAmt,fb2) * 1 <: operator(freq, a1, d1, s1, r1, 0.35,fb1), operator(freq+skew, a1, d1, s1, r1, 0.35,fb1);

