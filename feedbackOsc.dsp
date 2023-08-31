
// simple 2 operator fm synth

// declare options "[midi:on][nvoices:12]";
// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001);
feedB = hslider("feedB", 0.5, 0, 5, 0.001);


phaseMod(f,fb, modd) = modd : op(f)~ *(fb)
with{
    op(f, mod) = _, mod : + : os.oscp(f) *(0.25);
};



process = phaseMod(freq,feedB,0);