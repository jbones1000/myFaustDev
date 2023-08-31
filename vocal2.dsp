import("stdfaust.lib");

declare options "[midi:on][nvoices:4]";

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

voiceType = hslider("voiceType", 0, 0, 4, 1);
vowel = hslider("vowel", 0, 0, 4, 0.01) : si.polySmooth(gate, 0.999, 10);
nForm = 5;

process = pm.SFFormantModel( voiceType, vowel, noise, freq, 1, 0) * 10;