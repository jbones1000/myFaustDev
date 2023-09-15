// white noise rolling wave like effect
// some notes: 
// - very small changes to these parameters make a realisitic 'waves rolling
// in the distance' sound.
import("stdfaust.lib");

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

gain = hslider("gain", 0.5, 0, 1, 0.001);

lfoRate = hslider("lfoRate", 0.1, 0, 10, 0.01);
lfoDepth = hslider("lfoDepth", 125, 0, 1000, 0.01);
lfoRoot = hslider("lfoRoot", 100, 20, 10000, 0.01) : si.smoo ;

filtQ = hslider("filtQ", 1.1, 1, 100, 0.01) : si.smoo;
lopCut = hslider("lopCut", 800, 20, 10000, 0.01) : si.smoo;

lfo(f,d,r) = min( max( (o * d)+r , 15), 20000)
with{
    o = (os.osc(f) * 0.5) + 0.5;
};

process = no.pink_noise * (0.2) : fi.resonbp(lfo( lfoRate, lfoDepth,lfoRoot), filtQ, 0.5) : fi.lowpass(2,lopCut);

