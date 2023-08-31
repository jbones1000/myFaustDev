import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);


filterF = hslider("filterF", 1000, 300, 8000, 0.1);
filterQ = hslider("filterQ", 1, 1, 4, 0.01);

att = hslider("att", 0.001, 0.001, 1, 0.001);
dec = hslider("dec", 0.05, 0.001, 4, 0.001);


operator(f, a, d, s, r, amp) =  os.oscp(f) * en.adsre(a,d,s,r,gate) * amp;


ring = os.osc(freq*9)* 0.5, en.adsre(att, dec, 0, dec, gate) : *;

noiser = 0 : operator( freq*4.1, 0.01, 10, 0, 10, 10 ) * gain : operator( freq*1, 0.01, 10, 0,10, 60) * gain: operator( freq* 6, att, dec, 0, dec, 0.15 );


process = noiser : * ((gain*0.5) + 0.5);