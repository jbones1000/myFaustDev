import("stdfaust.lib");

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

synth = os.osc(freq) * 0.5;
env = _, en.adsre(0.01,0.1,0.5,1,gate) : *;

// outputs a rough amplitude balance for the freq spectrum
band_bal(f) = clip /(12543.9) : shape
with{
    clip = f : min(12543.9);
    shape = ( _/(2) ) * (ma.PI) : cos;
};

process = synth, band_bal(freq) : * : env *(gain);
