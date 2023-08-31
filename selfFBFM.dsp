// simple 2 operator fm synth

// declare options "[midi:on][nvoices:12]";
// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";



operator(i) = phaseMod(freq*f,fb) * en.adsre(a,d,s,r,gate) * amp
with{
    // feedback phase mod oscillator
    phaseMod(f,fb, modd) = modd : op(f)~ *(fb)
    with{
        op(f, mod) = _, mod : + : os.oscp(f) *(0.5);
    };
    // params
    f = hslider("f %i", 1, 0.001, 12, 0.001);
    a = hslider("a %i", 0.001, 0.001, 4, 0.001);
    d = hslider("d %i", 0.1, 0.001, 4, 0.001);
    s = hslider("s %i", 0.2, 0, 1, 0.01);
    r = hslider("r %i", 0.5, 0.001, 4, 0.001);
    fb = hslider("fb %i", 0, 0, 5, 0.01);
    amp = hslider("amp %i", 0.5, 0, 5, 0.01);
};