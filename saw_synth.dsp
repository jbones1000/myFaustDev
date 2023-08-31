
// simple saw synth

declare options "[midi:on][nvoices:12]";
// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001) : si.polySmooth(gate, 0.999, 64);

a = hslider("a", 0.001, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 0.2, 0, 1, 0.01);
r = hslider("r", 0.5, 0.001, 4, 0.001);

displace = hslider("displace", 0.1, 0, 10, 0.001);

// dual saw oscillator
//ba.if(d > 0, d, 0)
oss(d) = (os.sawtooth(freq) * 0.2) + (os.sawtooth(freq+ba.if(d > 0, d, 0)) * 0.2);

synth = (oss(displace) * 0.5) * en.adsre(a,d,s,r, gate);

process = synth *(gain);