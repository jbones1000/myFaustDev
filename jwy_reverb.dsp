import("stdfaust.lib");

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

gain = hslider("gain", 0.5, 0, 1, 0.001);

time = hslider("time", 1, 0.1, 60, 0.01);
damp = hslider("damp", 0.1, 0, 1, 0.001);
size = hslider("size", 2, 0.5, 5, 0.001);
early_diff = hslider("eDiff", 0.5, 0, 1, 0.001);
mod_depth = hslider("mod_depth", 0.5, 0, 1, 0.001);
mod_freq = hslider("mod_freq", 0.5, 0, 10, 0.001);
low = hslider("low", 0.5, 0, 1, 0.001);
mid = hslider("mid", 0.5, 0, 1, 0.001);
high = hslider("high", 0.5, 0, 1, 0.001);
lowcut = hslider("lowcut", 500, 100, 6000, 1);
hicut = hslider("hicut", 5000, 1000, 10000, 1);

verb = re.jpverb(time, damp, size, early_diff, mod_depth, mod_freq,  low, mid, high, lowcut, hicut);

process = _ * gain,_ * gain : verb;