import("stdfaust.lib");

declare options "[midi:on][nvoices:8]";

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

//carrier adsr
op1F = hslider("[1] op1F", 1, 0, 12, 0.001) : si.polySmooth(gate, 0.999, 10);
a1 = hslider("[2] a1", 0.01, 0.001, 4, 0.001);
d1 = hslider("[3] d1", 1, 0.001, 4, 0.001);
s1 = hslider("[4] s1", 0.8, 0, 1, 0.01);
r1 = hslider("[5] r1", 2, 0.001, 4, 0.001);

// modulator adsr
op2F = hslider("[6] op2F", 2, 0, 12, 0.001) : si.polySmooth(gate, 0.999, 10);
a2 = hslider("[7] a2", 0.001, 0.001, 4, 0.001);
d2 = hslider("[8] d2", 0.1, 0.001, 4, 0.001);
s2 = hslider("[9] s2", 0.2, 0, 1, 0.01);
r2 = hslider("[91] r2", 0.5, 0.001, 4, 0.001);

// mod control
modAmt = hslider("[300] modAmt", 0.5, 0, 12, 0.001) : si.polySmooth(gate, 0.999, 10);

operator(f, a, d, s, r, amp) =  (os.oscp(f)*0.5) * en.adsre(a,d,s,r,gate) * amp;

process = 0 : operator( freq*op2F, a2, d2, s2, r2, modAmt) * gain : operator( freq*op1F, a1, d1, s1, r1, 0.5) * ((gain*0.9)+0.1) <: _,_;

