import("stdfaust.lib");

declare options "[midi:on][nvoices:4]";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

modIt = hslider("modIt", 0, 0, 1, 0.01);
decay = hslider("decay", 0.03, 0.001, 0.2, 0.001);
space = hslider("space", 300, 1, 2000, 0.1);


freqDepth = hslider("freqDepth", 10000, -10000, 10000, 0.1);


ballFreq = hslider("ballFreq", 33, 20, 2000, 0.01);
ampEnv = _, en.ar(0.003, 0.003, gate) : *;
smack = (en.ar(0.001, 0.003, gate) * freqDepth) + freq, 0 : os.oscp*(0.25) : ampEnv;


pop = no.pink_noise*0.5 : ampEnv;

modeFilter(freq,t60,gain) = fi.tf2(b0,b1,b2,a1,a2)*gain
with{
    b0 = 1;
    b1 = -1;
    b2 = 0;
    w = 2*ma.PI*freq/ma.SR;
    r = pow(0.001,1/float(t60*ma.SR));
    a1 = -2*r*cos(w);
    a2 = r^2;
};

bounce(f, ang) = _ <: par(i,nModes,modeFilter(modeFreqs(i),modeT60s(i),modeGains(i))) :> /(nModes)
with{
    nModes = 3;
    theta = ang; // angle
    //modeFreqs(i) = freq * ( i+(1*i));
    modeFreqs(i) = f * (i+2.01);
    modeT60s(i) = (nModes-i)*decay;
    mod(i) =  ma.modulo(i+theta, nModes);
    modeGains(i) = 1/(mod+1);
    //modeGains(i) = cos((i+1)*theta)/float(i+1)*(1/(i+1));
};


overtone(f, ang) = _ <: par(i,nModes,modeFilter(modeFreqs(i),modeT60s(i),modeGains(i))) :> /(nModes)
with{
    nModes = 20;
    theta = ang; // angle
    //modeFreqs(i) = freq * ( i+(1*i));
    modeFreqs(i) = f + (700*i);
    modeT60s(i) = (nModes-i)*decay;
    mod(i) =  ma.modulo(i+theta, nModes);
    modeGains(i) = 1/(mod+1);
    //modeGains(i) = cos((i+1)*theta)/float(i+1)*(1/(i+1));
};


//process = pop*0.1, smack :> _ <: sum(i,10, fi.tf22(0,0,-1,0.1,i/10) ) /(10);



process = smack*(0.7) <: bounce(freq, modIt), overtone(2000,modIt)*0.5;
