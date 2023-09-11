declare filename "saw_synth.dsp";
declare name "saw_synth";

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

displace = hslider("displace", 0.1, -24, 24, 0.001)  : si.polySmooth(gate, 0.999, 64);

// dual saw oscillator
//ba.if(d > 0, d, 0)
oss(d) = (os.sawtooth(freq) * 0.2) + (os.sawtooth(convert(ba.if(d != 0, d, 0))) * 0.2)
with {
    convert(x) = ba.midikey2hz( ba.hz2midikey(freq) + x);
};



synth = (oss(displace) * 0.5) * en.adsre(a,d,s,r, gate);

process = synth *(gain);