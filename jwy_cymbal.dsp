import("stdfaust.lib");

declare options "[midi:on][nvoices:4]";

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

freqLP = hslider("freqLP", 4040, 20, 10000, 1);
qLP = hslider("qLP", 1, 1, 100, 0.1);
freqHP = hslider("freqHP", 5200, 20, 10000, 1);
qHP = hslider("qHP", 1, 1, 100, 0.1);

strikeAmt = hslider("strikeAmt", 0.5, 0, 1, 0.001);

att = hslider("att", 0.001, 0.001, 1, 0.001);
dec = hslider("dec", 1, 0.001, 8, 0.001);

op1F = hslider("op1F", 799, 0, 18000, 1);
op2F = hslider("op2F", 1269, 0, 18000, 1);
op3F = hslider("op3F", 1768, 0, 18000, 1);

ringF = hslider("ringF", 2000, 500, 9000, 1);

operator(f, a, d, s, r, amp) =  os.oscp(f) * en.adsre(a,d,s,r,gate) * amp;

ringer = 0 : operator( ringF-400, 0.001, 10, 1, 10, 10) :
operator( ringF+(505), 0.002, 0.4,0, 0.4, 5) * gain :
operator( ringF, 0.003, 0.4,0, 0.4, 0.5) * gain;

noiser = 0 : operator( op1F, 0.01, dec*4, 1, dec*4, 12) * gain : 
operator( op2F, 0.01, dec*4, 1, dec*4, 12) * gain : 
operator( op3F, att, dec, 0, dec, 0.2) * gain; 


process = noiser, ((ringer*0.5)*strikeAmt) :> fi.resonlp(freqLP, qLP, 0.5) : fi.resonhp(freqHP, qHP, 0.5);