import("stdfaust.lib");

declare author "Critter&Guitari";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);


ar(at,rt,gate) = AR : max(0)
with {

    // Durations in samples
    an = max(1, at*ma.SR);
    rn = max(1, rt*ma.SR);

    // Deltas per samples
    adelta = 1/an;
    rdelta = 1/rn;

    // Attack time (starts at gate upfront and raises infinitely)
    atime = (raise*reset + upfront) ~ _
    with {
        upfront = gate > gate';
        
        reset = 1;
        //reset = gate <= gate';
        raise(x) = (x + (x > 0));
    };

    // Attack curve
    A = atime * adelta;

    // Release curve
    D0 = 1 + an * rdelta;
    D = D0 - atime * rdelta;

    // AR part
    AR = min(A, D);

};


process = (os.osc(freq) * ar(0.01, 0.1, gate)) * (gain);