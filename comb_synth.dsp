import("stdfaust.lib");

declare options "[midi:on][nvoices:12]";

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

a = hslider("a", 0.001, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 0.7, 0, 1, 0.01);
r = hslider("r", 0.5, 0.001, 4, 0.001);

combFb =  fi.fb_comb(maxDel, modDel_clip, 0.5, amt)
with {
    maxDel = 2000;
    del = freq; //hslider("del", 10, 0, maxDel, 0.01) : si.polySmooth(gate, 0.999, 64);
    amt = hslider("amt", 0.8, 0, 0.95, 0.01);
    modDepth = hslider("modDepth", 1, 0, 100, 0.01);
    modRate = hslider("modRate", 0, 0, 10, 0.01);
    // mod the del amt
    modDel = (os.osc(modRate) * modDepth) + del;
    modDel_clip = min( max( modDel, 0), 2000);
};

q = hslider("q", 1, 1, 100, 0.1) : si.polySmooth(gate, 0.999, 64);

amp = hslider("amp", 1, 0, 4, 0.001);


process = no.noise * 0.2 : *(en.adsre(a,d,s,r,gate)) : combFb * (gain);