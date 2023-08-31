// signal controlled filter with 0-1 float frequency, 0-1 float resonance Q
// outputs Bandstop, Bandpass, Highpass, Lowpass in that order.

import("stdfaust.lib");

declare author "Critter&Guitari";
declare description "signal controlled filter oberheim filter";
declare copyright "GRAME";
declare license "LGPL with exception";

gate = button("gate");

f = hslider("f", 0.5, 0, 1, 0.001) : si.polySmooth(gate, 0.999, 64);
q = hslider("q", 1, 1, 1000, 0.01) : si.polySmooth(gate, 0.999, 64);

process = _ : ve.oberheim( f, max(q,1) ) : _, _, _, _;