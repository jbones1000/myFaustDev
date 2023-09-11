// vocoder effect with 8 bands

// faust library
import("stdfaust.lib");

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

gain = hslider("gain", 0.5, 0, 1, 0.001);


att = hslider("att", 0.01, 0.001, 2, 0.001);
rel = hslider("rel", 0.1, 0.001, 2, 0.001);

bwRatio = hslider("bwRatio", 0.5, 0.1, 2, 0.001) : si.smoo;

// inlet 1 modulation (like drums)
// inlet 2 carrier (like a saw wave)
process = _, _ : ve.vocoder(8, att,rel, bwRatio) : _*(gain);