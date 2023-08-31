import("stdfaust.lib");

declare options "[midi:on][nvoices:4]";

freq = hslider("freq", 56, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

// freq envelope
freqAtt = hslider("freqAtt", 0.001, 0.001, 1, 0.001);
freqDec = hslider("freqDec", 0.05, 0.001, 1, 0.001);
freqDepth = hslider("freqDepth", 12, -24, 24, 0.1);
freqEnv(d) = en.adsre(freqAtt, freqDec, 0, freqDec, gate) * d;
freqModder = ba.midikey2hz( ba.hz2midikey( freq ) + freqEnv(freqDepth));

// amplitude envelope
att = hslider("att", 0.01, 0.001, 4, 0.001);
dec = hslider("dec", 0.01, 0.001, 4, 0.001);
sus = hslider("sus", 0.5, 0, 1, 0.001);
rel = hslider("rel", 0.1, 0.001, 4, 0.001);





// bandlimited simple osc for additive
osc(f, amp, del, a,d,s,r, rate, depth) = 0 : os.oscp(pitch) *(0.5) : _ * (amp) : _ * (ampEnv)
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


slap = sum(i, 4, 
osc( freqModder * ((i*2)+1), 
    0.8/(i+1),
    0, 
    0.01/(i+1), 
    0.1/(i+1), 
    0, 
    0.1/(i+1), 
    0.1,
    10) 
    ) :> _ ;

oTone(f, q, g, a, d, s, r) =  _ : fi.resonbp( f, q, g ) : _, en.adsre(a,d,s,r,gate) : *;

overtone = no.noise <: sum(i, 10, oTone( (i*500)+5000, 150, 0.15/(i+1), 0.01, rel/(i+1), 0, rel/(i+1) ) );




process = slap*(0.1), overtone*(0.2) :> _;
