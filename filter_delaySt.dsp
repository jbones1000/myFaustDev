import("stdfaust.lib");

delay_max = 2000;
delay_time = hslider("delay_time", 125, 1, 2000, 0.001) : si.smoo;
delay_fb = hslider("delay_fb", 0.75, 0, 0.999, 0.001);
filter_freq = hslider("filter_freq", 0.5, 0, 1, 0.001);
filter_q = hslider("filter_q", 1, 1, 5, 0.1);
preHip_f = hslider("preHip_f", 5, 5, 20000, 1);
wetDry =  hslider("wetDry", 0.5, 0, 1, 0.001) : si.smoo ;
filter_mix = hslider("filter_mix", 0.5, 0, 1, 0.01);
stereo_split = hslider("stereo_split", 0.5, 0, 1, 0.01) * 100 : si.smoo;

obFilter(f,q,m) = _ : ve.oberheim(f,q) <: _*(0), _*(0), _*(sqrt(m)), _*(1-(sqrt(m))) :> _;

filter_delay( m, t, fb, fiF, fiQ, fiM) = +~ (de.fdelay(maxD, time) : filter : *(fb) )
with {
    filter = obFilter(fiF,fiQ,fiM);
    maxD  = m * (ma.SR/1000);
    time = t * (ma.SR/1000);
};

stereo_filter = _,_ : filter_delay(delay_max, delay_time, delay_fb, filter_freq, filter_q, filter_mix), filter_delay(delay_max, delay_time+stereo_split, delay_fb, filter_freq, filter_q, filter_mix);

stereo_hiP(f) = _,_ : fi.highpass(2,f), fi.highpass(2,f);
stereo_lop(f) = _,_ : fi.lowpass(2,f),  fi.lowpass(2,f);


process = _, _ <: stereo_hiP(preHip_f), stereo_lop(preHip_f),_,_ : stereo_filter,_,_,_,_ : _ * wetDry,_ * wetDry, _* wetDry, _ * wetDry, _*(1-wetDry),_*(1-wetDry) :> _,_;