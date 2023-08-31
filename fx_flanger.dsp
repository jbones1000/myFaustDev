// Flanger effect

// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001);

fx_flanger = pf.flanger_mono( 2000, oscEnv( min(rate,2000) ), depth, fb, 0)
with {
    a = hslider("a", 0.001, 0.001, 4, 0.001);
    d = hslider("d", 0.1, 0.001, 4, 0.001);
    s = hslider("s", 0.2, 0, 1, 0.01);
    r = hslider("r", 0.5, 0.001, 4, 0.001);

    depth = hslider("depth", 1, 0, 1, 0.01);
    fb = hslider("fb", 0.98, 0, 0.99, 0.01);
    rate = hslider("rate", 2000, 0, 2000, 0.01) : si.polySmooth(gate, 0.999, 64);

    oscEnv(dp) = en.adsre(a,d,s,r, gate) * dp;
};

process = _ : fx_flanger : _*(gain);