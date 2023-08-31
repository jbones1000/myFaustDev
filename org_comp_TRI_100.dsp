import("stdfaust.lib");
declare options "[midi:on][nvoices:8]";

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);
mainSkew = hslider("skew", 0, 0, 1, 0.001) : si.polySmooth(gate,0.999,10);
partialSpace = hslider("partialSpace", 1, 0.1, 5, 0.001) : si.polySmooth(gate,0.999,10);

filter = hslider("filter", 1, 1, 5, 0.001) : si.polySmooth(gate,0.999,10);



osc(i, amp, a,d,s,r, lfoR, lfoD, p) = ( _ + i ) + ( os.osc(lfoR)*lfoD ) : ba.midikey2hz : (os.osc*0.1) * en.adsre(a,d,s,r,gate) * amp <: _*(1-p), _*p;



wave(skew, p) = _ + skew <: osc( 7 , 0.5/4, 0.05, 0.01, 0.5, 0.5, 2, .01, p ), 
                        osc(  0, 0.5/4, 0.03, 0.01, 0.5, 0.4, 2, .1, p ),
                        osc( 11.99 , 0.25/4, 0.01, 0.01, 0.5, 0.6, 4, 0.5, p ),
                        osc( 24.1 , 0.15/4, 0.01, 0.01, 0.5, 0.1, 2, .1, p )

;


process = ba.hz2midikey(freq) <: par(i, 4, wave( mainSkew*(i*0.5), (i/4) * 0.5 + 0.25 ) ) :> _,_ ;
                