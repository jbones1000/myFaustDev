import("stdfaust.lib");

declare options "[midi:on][nvoices:4]";

freq = hslider("freq", 56, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

// freq envelope
freqAtt = hslider("freqAtt", 0.001, 0.001, 1, 0.001);
freqDec = hslider("freqDec", 0.001, 0.001, 1, 0.001);
freqDepth = hslider("freqDepth", 38, -24, 100, 0.1);
freqEnv(d) = en.ar(freqAtt, freqDec, gate) * d;
freqModder = ba.midikey2hz( ba.hz2midikey( freq ) + freqEnv(freqDepth));

ampDec = hslider("ampDec", 0.001, 0.001, 1, 0.001);
slapSpace = hslider("slapSpace", 1, 0, 12, 0.001);

otSpace = hslider("otSpace", 750, 0, 4000, 0.1);
otRing = hslider("otRing", 0.16, 0.001, 2, 0.001);
otRoot = hslider("otRoot", 1298, 20, 2000, 0.01);
otGain = hslider("otGain", 0.05, 0, 1, 0.001);
otDel = hslider("otDel", 0, 0, 1000, 0.01); // in ms

// bandlimited simple osc for additive
osc(f, amp, del, a,d,s,r, rate, depth) = (0 : si.smooth(0.995) ) : os.oscp(pitch) *(0.5) : _ * (amp) : _ * (ampEnv)
with{
    // if freq is above 19,000 output 0
    bLimit(fr,x) = fr < (x), fr : *;
    lfo = os.osc(rate) * depth;
    pitch =  bLimit(f+lfo, 19000);
    ampEnv = en.adsre( a,d,s,r, gate @(del * (ma.SR/1000) ) );
    atten = (ba.hz2midikey(f) / (127)) / 4 : cos;

};
ampEnv = _, en.ar(0.004, 0.3, gate) : *;
pop = no.pink_noise*0.5 : ampEnv;

//freqDepth = hslider("freqDepth", 10000, -10000, 10000, 0.1);


smack(f, dep) = osc * atten(pitch) : ampEnv
with{
    pitch = (en.ar(0.001, 0.001, gate) * dep) + f;
    osc = 0 : os.oscp(pitch) * (0.25);
    ampEnv = _, en.ar(0.003, 0.03, gate) : *;
    atten(f) = (ba.hz2midikey(f) / (127)) / 4 : cos;

};

slap = sum(i, 4, 
osc( freqModder * ((i*slapSpace)+1), 
    0.8/(i+1),
    0, 
    0.01/(i+1), 
    ampDec/(i+1), 
    0, 
    ampDec/(i+1), 
    0.1,
    10 ) 
    ) :> _ ;

overTone = sum(i, 12, osc( otRoot + (i*otSpace), pow( 0.5/(i+1), 1), i*otDel, 0.01, (i+1)*otRing, 0, (i+1)*otRing, 5, 5 ) ) :> _;

process = slap*0.5, overTone*(otGain) :> _ *(gain);

