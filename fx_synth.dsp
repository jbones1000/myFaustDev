
// simple saw synth with effects

declare options "[midi:on][nvoices:12]";
// faust library
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0.5, 0, 1, 0.001) : si.polySmooth(gate, 0.999, 64);

a = hslider("a", 0.001, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 0.2, 0, 1, 0.01);
r = hslider("r", 0.5, 0.001, 4, 0.001);

lfoA = hslider("lfoA", 8, 0.01, 8, 0.01);
lfoD = hslider("lfoD", 1, 0.001, 4, 0.001);
lfoS = hslider("lfoS", 1, 0, 1, 0.01);
lfoR = hslider("lfoR", 4, 0.01, 8, 0.01);

displace = hslider("displace", 0.1, 0, 10, 0.001);

number = hslider("lfoR", 8, 1, 32, 1);


trig_delay(num, time, del, dir, curve) = env <: sum(i, num, del_voice((i*time)+del, vol(i) * 0.8 )) :> _
with {
    vol(x) = pow( dir - (x/num), curve);
    a = hslider("aTrig", 0.001, 0.001, 4, 0.001);
    d = hslider("dTrig", 0.1, 0.001, 4, 0.001);
    s = hslider("sTrig", 0, 0, 1, 0.01);
    r = hslider("rTrig", 0.5, 0.001, 4, 0.001);
    env = _ * en.adsre(a,d,s,r, gate);
    del_voice(ms,g) = _ : @ (ms*(ma.SR*0.001)) : _ *(g);
};


flangeDepth = hslider("flangeDepth", 1, 0, 1, 0.01);
flangeFb = hslider("flangeFb", 0.98, 0, 0.99, 0.01);
flangeRate = hslider("flangeRate", 2000, 0, 2000, 0.01);

oss(d) = (os.sawtooth(freq) * 0.1) + (os.sawtooth(freq+d) * 0.1);

synth = (oss(displace) * 0.5) * en.adsre(a,d,s,r, gate);



lfo(f,d) = ((os.osc(f)/2) + 0.5) * d;
oscEnv(d) = en.adsre(lfoA,lfoD,lfoS,lfoR, gate) * d;
filt = fi.resonlp( lfo(oscEnv(5),freq*2)+freq, 2, 0.5);

combFb(maxDel,del) =  fi.fb_comb(maxDel, del, 0.5, amt)
with {
    maxDel = 2000;
    del = hslider("del", 10, 0, maxDel, 0.01);
    amt = hslider("amt", 0.8, 0, 0.95, 0.01);
};

flange = pf.flanger_stereo( 2000, oscEnv(flangeRate), oscEnv(max(flangeRate-10,0)), flangeDepth, flangeFb, 0);


process = synth <: trig_delay(8,250,125,1,1) *(gain), trig_delay(8,250,0,1,1) *(gain);