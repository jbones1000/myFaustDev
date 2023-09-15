// cricket model
import("stdfaust.lib");

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);

diff = hslider("diff", 12, -24, 36, 0.001): si.polySmooth(gate,0.999,64);
modAmt = hslider("modAmt", 0.85, 0, 1, 0.001) : si.polySmooth(gate,0.999,64);
phase = hslider("phase", 5, 0, 10, 0.001) ;

freqEnv(f) = f + ( freq_depth * en.adsre(freq_a,freq_d,freq_s,freq_r, gate) )
with{
    freq_depth = hslider("freq_depth", 24, -48, 64, 0.01);
    freq_a = hslider("freq_a", 0.001, 0.001, 4, 0.001);
    freq_d = hslider("freq_d", 0.05, 0.001, 4, 0.001);
    freq_s = hslider("freq_s", 0, 0, 1, 0.01);
    freq_r = hslider("freq_r", 0.001, 0.001, 4, 0.001);
};

// outputs a rough amplitude balance for the freq spectrum
band_bal(f) = clip /(160) : shape
with{
    clip = min( ba.hz2midikey(f), 127) ;
    //shape = ( _/(2) ) * (ma.PI) : cos;
    shape = 1, _ : -;
};

ringModTri(amt,offset) = (1-amt), ( tri(0)*(0.5) ) + (tri(offset)*(0.5) ) :> _
with {
    tuneDiff(diff) = ba.midikey2hz( ba.hz2midikey(freqEnv(freq)) + diff );
    tri(off) = os.triangle((freqEnv(freq) + tuneDiff(diff)) + off) *(amt);
};

sine = (os.osc(freqEnv(freq)) * 0.5) * band_bal(freqEnv(freq));
tri = (ringModTri(modAmt,phase) * 0.5) * band_bal(freqEnv(freq));
synth =  sine * tri;

a = hslider("a", 0.01, 0.001, 4, 0.001);
d = hslider("d", 0.1, 0.001, 4, 0.001);
s = hslider("s", 1, 0, 1, 0.01);
r = hslider("r", 0.1, 0.001, 4, 0.001);

process = synth *(en.adsre(a,d,s,r,gate));

