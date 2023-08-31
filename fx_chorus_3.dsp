// three part chorus
import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

gain = hslider("gain", 0.5, 0, 1, 0.001);
gate = button("gate");

pShift(shift) =  _ <: dLine(mainPhase), dLine( ma.modulo(mainPhase+0.5,1) ) : + : _ *(gain)
with {
    windowRaw = hslider("window-ms", 45, 1, 10000, 1);
    window = max(windowRaw, 1);
    delayRaw = hslider("delay-ms", 1.5, 1.5, 1000, 0.1);
    delay = max(delayRaw, 1.5);
    
    // 5000 ms of max delay time (max window time)
    maxD = 5 * ma.SR; // in samples

    // envelope
    env(ph) = sin( ph * 0.5 * (2*ma.PI) );

    // ms to samples
    ms2samp(i) = (ma.SR*0.001) * i;

    // tpose math
    math1 = shift * 0.05776;
    math2 = math1 : exp;
    math3 = (math2 - 1) * -1;
    toPhase = math3 / (window*0.001);

    // main phasor
    mainPhase = os.phasor(1,toPhase);

    // delay line
    dLine(phz) = de.fdelay(maxD, ms2samp( (phz*window)+delay ) ) * env(phz);
};

shift1 = hslider("shift1", 5, -24, 24, 0.01) : si.polySmooth(gate, 0.999, 64);
shift2 = hslider("shift2", 12, -24, 24, 0.01) : si.polySmooth(gate, 0.999, 64);
shift3 = hslider("shift3", 24, -24, 24, 0.01) : si.polySmooth(gate, 0.999, 64);

process = _ <: pShift(shift1) *(0.25), pShift(shift2) *(0.25), pShift(shift3) *(0.25), _ *(0.25) ;
