import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

tau = hslider("tau", 0.01, 0, 2, 0.001);
track = an.pitchTracker(3, tau);

process = track;