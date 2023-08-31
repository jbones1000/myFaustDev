// delay effect

// faust library
declare options "[midi:on][nvoices:4]";
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

gate = button("gate");
stop = button("stop");
gain = hslider("gain", 0.5, 0, 1, 0.001);

delTime = hslider("delTime", 125, 1, 2000, 1);
feedback = hslider("feedback", 0.75, 0, 0.99, 0.01);

trig_delay(time, fb) = _ : env : +~ de.fdelay( (2*ma.SR), time*(ma.SR*0.001) ) * (fb*(1-stop))
with {
    a = hslider("a", 0.001, 0.001, 4, 0.001);
    d = hslider("d", 0.8, 0.001, 4, 0.001);
    s = hslider("s", 0, 0, 1, 0.01);
    r = hslider("r", 0.5, 0.001, 4, 0.001);
    env = _ * en.adsre(a,d,s,r, gate);
    
    
};

process = trig_delay(delTime, feedback) *(gain);