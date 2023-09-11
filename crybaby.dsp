// crybaby effect

// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

gain = hslider("gain", 0.5, 0, 1, 0.001);
gate = button("gate");

wah = hslider("wah", 0.5, 0, 1, 0.001) : si.polySmooth(gate,0.999,64);

// inlet 1 modulation (like drums)
// inlet 2 carrier (like a saw wave)
process = _ : ve.crybaby(wah) : _*(gain);