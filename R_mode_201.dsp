import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.01);
selector = hslider("selector", 0, 0, 3, 1);
shift = hslider("shift", 0, -24, 24, 0.01) : si.polySmooth(gate, 0.999, 10);

oscG = hslider("osc1", 0.7, 0, 1, 0.01) ;
triG = hslider("osc2", 0.7, 0, 1, 0.01) ;
sqrG = hslider("osc3", 0.25, 0, 1, 0.01) ;
sawG = hslider("osc4", 0.45, 0, 1, 0.01) ;

att = hslider("att", 0.01, 0.001, 2, 0.001);
dec = hslider("dec", 0.01, 0.001, 4, 0.001);
sus = hslider("sus", 0.9, 0, 1, 0.001);
rel = hslider("rel", 0.1, 0.001, 4, 0.001);

// freq as signal goes in
theWaves(x) = _ <: ba.selectmulti( ma.SR/100, (os.osc*oscG, os.triangle*triG, os.square*sqrG, os.sawtooth*sawG ), x );

// Frequency Mod LFO signal input added to the tpose
process = _ + shift : ba.midikey2hz : (theWaves(selector) * 0.5) * gain, en.adsre(att, dec, sus, rel, gate) : *;