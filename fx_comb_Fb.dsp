// feedback comb effect

// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

gain = hslider("gain", 0.5, 0, 1, 0.001);
gate = button("gate");

combFb =  fi.fb_comb(maxDel, modDel_clip, 0.5, amt)
with {
    maxDel = 2000;
    del = hslider("del", 10, 0, maxDel, 0.01) : si.polySmooth(gate, 0.999, 64);
    amt = hslider("amt", 0.8, 0, 0.95, 0.01);
    modDepth = hslider("modDepth", 1, 0, 100, 0.01);
    modRate = hslider("modRate", 0, 0, 10, 0.01);
    // mod the del amt
    modDel = (os.osc(modRate) * modDepth) + del;
    modDel_clip = min( max( modDel, 0), 2000);
};

process = _ : combFb : _*(gain);