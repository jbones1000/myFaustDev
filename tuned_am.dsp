import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01) : ba.hz2midikey;
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

rel = hslider("rel", 0.25, 0.01, 4, 0.01);
att = hslider("att", 0.01, 0.001, 4, 0.001);

modIndex = hslider("modIndex", 5, -24, 68, 0.001) : si.polySmooth(gate,0.999,10);
bal = hslider("bal", 0.5, 0, 1, 0.001) : si.polySmooth(gate,0.999,10);

op(f,mod,a,d,s,r) = ((_/2)+0.5) * mod + (1-mod), (os.osc( ba.midikey2hz(f) )*0.5) * en.adsre(a,d,s,r,gate) : *;



process = 1 : op(freq+modIndex, 0, att/2, 0.5, 0.5, rel/2) : op(freq, bal, att, 0.5, 0.5, rel) * gain;