declare filename "waveShape_synth.dsp";
declare name "waveShape_synth";

// simple saw synth

declare options "[midi:on][nvoices:12]";
// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001);

a = hslider("a", 0.001, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 0.2, 0, 1, 0.01);
r = hslider("r", 0.5, 0.001, 4, 0.001);

bottom = hslider("bottom", -1, -1, 0, 0.001)  : si.polySmooth(gate, 0.999, 64);
absolute = hslider("absolute", 0, 0, 1, 0.001)  : si.polySmooth(gate, 0.999, 64);
duty = hslider("duty", 0, 0, 1, 0.001)  : si.polySmooth(gate, 0.999, 64);
sine = max( min(os.osc(freq), 1), bottom) * 0.5;
//abs_it(p) = _ <: _ *(p-1), abs * (p) :> _;
length = (os.osc(freq)*0.25) * p;
synth = length : *(en.adsre(a,d,s,r, gate));

process = synth *(gain);