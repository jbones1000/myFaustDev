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

clip = hslider("clip", 1, 1, 12, 0.001);
power = hslider("power", 2, 1, 12, 0.01);
lopF = hslider("lopF", 4000, 500, 9000, 1);

a = hslider("a", 0.01, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 0.2, 0, 1, 0.01);
r = hslider("r", 0.5, 0.001, 4, 0.001);

bottom = hslider("bottom", -1, -1, 0, 0.001)  : si.polySmooth(gate, 0.999, 64);
absolute = hslider("absolute", 0, 0, 1, 0.001)  : si.polySmooth(gate, 0.999, 64);
duty = hslider("duty", 0, 0, 1, 0.001)  : si.polySmooth(gate, 0.999, 64);
sine = max( min(os.osc(freq), 1), bottom) * 0.5;
//abs_it(p) = _ <: _ *(p-1), abs * (p) :> _;
pow_it(b,p) = _ <: _ *(b-1), (_,p : pow * (b)) :> _;
clip_len(c) = os.phasor(1,freq) : ba.if(_>c,0,1);

length = sine : pow_it(clip,power);

trigg = os.phasor(1,freq) * clip;
convertCos =_ *(ma.PI*2) : cos;

synth = trigg : convertCos : fi.lowpass(2,lopF) : *(en.adsre(a,d,s,r, gate));



process =  synth *(gain);