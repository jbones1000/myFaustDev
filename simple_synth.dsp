declare options "[midi:on][nvoices:1]";
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 7000, 20, 8000, 0.001);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001);

balance = hslider("balance", 0.5, 0, 1, 0.001);

xfade(b) = _ * ch1, _ * ch2 :> _
with {
    bClip = min(max(b,0),1);
    ch1 = (b/2) * ma.PI;
    ch2 = ((1-b)/2) * ma.PI;
};



multiOp(f,bal) = si.bus(2,os.osc(f)*0.5, os.square(f)*0.23) : xfade(bal) :> _;
process = (multiOp(freq,balance) * gain) * en.adsre(0.01,0.3,0.6,0.3, gate);