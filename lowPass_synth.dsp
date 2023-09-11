import("stdfaust.lib");

declare options "[midi:on][nvoices:12]";

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

a = hslider("a", 0.001, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 0.7, 0, 1, 0.01);
r = hslider("r", 0.5, 0.001, 4, 0.001);

freqEnv(f) = f + ( freq_depth * en.adsre(freq_a,freq_d,freq_s,freq_r, gate) )
with{
    freq_depth = hslider("freq_depth", -12, -48, 64, 0.01);
    freq_a = hslider("freq_a", 0.001, 0.001, 4, 0.001);
    freq_d = hslider("freq_d", 0.1, 0.001, 4, 0.001);
    freq_s = hslider("freq_s", 0, 0, 1, 0.01);
    freq_r = hslider("freq_r", 0.001, 0.001, 4, 0.001);
};

spaceLP = hslider("spaceLP", 12, 0, 24, 0.001) : si.polySmooth(gate, 0.999, 64);
spaceHP = hslider("spaceHP", -12, -24, 0, 0.001) : si.polySmooth(gate, 0.999, 64);

q = hslider("q", 1, 1, 100, 0.1) : si.polySmooth(gate, 0.999, 64);

amp = hslider("amp", 1, 0, 4, 0.001);

spaceMIDI_LP = ba.midikey2hz( ba.hz2midikey(freqEnv(freq)) + spaceLP );
spaceMIDI_HP = ba.midikey2hz( ba.hz2midikey(freqEnv(freq)) + spaceHP );

process = no.noise * 0.2 : *(en.adsre(a,d,s,r,gate)): fi.resonhp(spaceMIDI_HP,q,amp) : fi.resonlp(spaceMIDI_LP,q,amp) * (gain);