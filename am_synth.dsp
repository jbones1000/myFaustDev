import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

rel = hslider("rel", 0.25, 0.01, 4, 0.01);

modIndex = hslider("modIndex", 3, 0, 12, 0.001);
bal = hslider("bal", 0.5, 0, 1, 0.001) : si.polySmooth(gate,0.999,10);

op(f,a,d,s,r) = _, os.osc(f) * en.adsre(a,d,s,r,gate) : *;



process = 1 : op(freq*modIndex, 0.01, 0.5, 0.5, rel/1.5), 1 : si.bus(2) : fd.linInterp1D(2,bal) :> op(freq, 0.01, 0.5, 0.5, rel) * gain;