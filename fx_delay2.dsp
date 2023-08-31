// delay effect

// faust library
declare options "[midi:on][nvoices:4]";
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001);

delTime = hslider("delTime", 125, 1, 2000, 1);
beginDel = hslider("beginDel", 125, 1, 2000, 1);
globalCurve = hslider("curve", 1, 1, 12, 1);
direction = hslider("direction", 1, 0, 1, 1);

trig_delay(num, time, del, dir, curve) = env <: sum(i, num, del_voice((i*time)+del, vol(i) * 0.8 )) :> _
with {
    vol(x) = pow( dir - (x/num), curve);
    a = hslider("a", 0.001, 0.001, 4, 0.001);
    d = hslider("d", 0.1, 0.001, 4, 0.001);
    s = hslider("s", 0, 0, 1, 0.01);
    r = hslider("r", 0.5, 0.001, 4, 0.001);
    env = _ * en.adsre(a,d,s,r, gate);
    del_voice(ms,g) = _ : @ (ms*(ma.SR*0.001)) : _ *(g);
};

process = trig_delay(32,delTime,beginDel,direction,globalCurve) *(gain);