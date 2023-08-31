import("stdfaust.lib");
declare options "[midi:on][nvoices:8]";

declare author "Jeremy WY";
declare copyright "GRAME";
declare license "LGPL with exception";

freq = hslider("freq", 440, 20, 2000, 0.01);
gate = button("gate");
gain = hslider("gain", 0, 0, 1, 0.001);
mainSkew = hslider("skew [midi:ctrl 1 1]", 0, 0, 1, 0.001) : si.polySmooth(gate,0.999,10);
rel = hslider("release", 0.5, 0.001, 8, 0.001);
att = hslider("attack", 0.01, 0.001, 3, 0.001);

partialSpace = hslider("partialSpace", 1, 0.1, 5, 0.001) : si.polySmooth(gate,0.999,10);

filter = hslider("filter", 1, 1, 5, 0.001) : si.polySmooth(gate,0.999,10);



osc(i, amp, a,d,s,r, lfoR, lfoD, p) = ( _ * i ) + ( os.osc(lfoR)*lfoD ) : (os.osc*0.5) * en.adsre(a,d,s,r,gate) * amp <: _*(1-p), _*p;



wave(skew, p) = _ + skew <: osc( 1 , 0.5/4, att, 0.01, 0.5, rel,  2, 0.01, p ), 
                        osc(  2, 0.5/4, att, 0.01, 0.5, rel/1.5,   2, 0.1, p ),
                        osc( 2.99 , 0.25/4, att/1.2, 0.01, 0.45, rel/2,   4, 0.5, p ),
                        osc( 9.1 , 0.15/4, att/1.3, 0.01, 0.35, rel/2.5,   2, .1, p )

;


process = freq <: par(i, 4, wave( mainSkew*(i*2), (i/4) * 0.8 + 0.1 ) ) :> _*gain,_*gain;
                