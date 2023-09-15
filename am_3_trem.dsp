import("stdfaust.lib");

// declare options "[midi:on][nvoices:12]";

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

// tremolo with envelopes synced to gate
tremolo(i) = (lfo * depth_env) + (1-depth_env)
with{
    //params
    rootHz = hslider("rootHz%i", 1, 0, 20, 0.001);
    maxHz = hslider("maxHz%i", 5, 0, 40, 0.001);
    // adsr for rate(hz)
    delHz = hslider("delHz%i", 0, 0, 5, 0.001);
    aHz = hslider("aHz%i", 10, 0.001, 25, 0.001);
    dHz = hslider("dHz%i", 2, 0.001, 5, 0.001);
    sHz = hslider("sHz%i", 0.5, 0.001, 5, 0.001);
    rHz = hslider("rHz%i", 2, 0.001, 5, 0.001);
    // adsr for depth
    delDpth = hslider("delDpth%i", 0, 0, 5, 0.001);
    aDpth = hslider("aDpth%i", 2, 0.001, 5, 0.001);
    dDpth = hslider("dDpth%i", 0.1, 0.001, 5, 0.001);
    sDpth = hslider("sDpth%i", 1, 0.001, 5, 0.001);
    rDpth = hslider("rDpth%i", 2, 0.001, 5, 0.001);
    
    rate_env = (en.adsre(aHz,dHz,sHz,rHz,gate@(delHz)) * maxHz) + rootHz;
    depth_env = en.adsre(aDpth,dDpth,sDpth,rDpth,gate@(delDpth));

    lfo = (os.osc(rate_env) * 0.5) + 0.5;
    
    
};
// outputs a rough amplitude balance for the freq spectrum
band_bal(f) = clip /(160) : shape
with{
    clip = min( ba.hz2midikey(f), 127) ;
    //shape = ( _/(2) ) * (ma.PI) : cos;
    shape = 1, _ : -;
};

operator(i) = _ : norm *(in), 1 -(in) :> _ , ops : * : *(out)
with{
    norm =(_ * 0.5) + 0.5;
    ops = ( os.osc(convertF) * band_bal(convertF) ) * en.adsre(a,d,s,r,gate);
    // params
    f = hslider("f%i", 0, -24, 36, 0.01) : si.polySmooth(gate,0.999,64);
    convertF = ba.midikey2hz( ba.hz2midikey(freq) + f );
    a = hslider("a%i", 0.01, 0.001, 4, 0.001);
    d = hslider("d%i", 0.1, 0.001, 4, 0.001);
    s = hslider("s%i", 0.2, 0, 1, 0.01);
    r = hslider("r%i", 0.5, 0.001, 4, 0.001);
    in = hslider("in%i", 0.5, 0, 1, 0.01) : si.polySmooth(gate,0.999,64);
    out = hslider("out%i", 0.8, 0, 2, 0.01) : si.polySmooth(gate,0.999,64);
};


process = 0 : operator(3) :operator(2) : operator(1)*(gain), tremolo(1) : *;