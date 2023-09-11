import("stdfaust.lib");

// declare options "[midi:on][nvoices:12]";

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

operator(i) = _ : norm *(in), 1 -(in) :> _ , ops : * : *(out)
with{
    norm =(_ * 0.5) + 0.5;
    ops = os.osc(freq*f) * en.adsre(a,d,s,r,gate);
    // params
    f = hslider("f%i", 1, 0.001, 12, 0.001) : si.polySmooth(gate,0.999,64);
    a = hslider("a%i", 0.001, 0.001, 4, 0.001);
    d = hslider("d%i", 0.1, 0.001, 4, 0.001);
    s = hslider("s%i", 0.2, 0, 1, 0.01);
    r = hslider("r%i", 0.5, 0.001, 4, 0.001);
    in = hslider("in%i", 0.5, 0, 1, 0.01) : si.polySmooth(gate,0.999,64);
    out = hslider("out%i", 0.8, 0, 1, 0.01) : si.polySmooth(gate,0.999,64);
};


process = 0 : operator(3) : operator(2) : operator(1) * (gain);