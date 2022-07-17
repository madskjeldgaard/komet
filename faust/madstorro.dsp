declare name "madstorro";
declare version "0.1";
declare author "Jakob Zerbian";
declare author "Mads Kjeldgaard";
declare description "Dattorro reverb, mono";

import("stdfaust.lib");

/*

This is a modified version of the datorro reverb that comes with faust.
The modification is to make it mono

*/

madstorro_rev(pre_delay, bw, i_diff1, i_diff2, decay, d_diff1, d_diff2, damping) =
    si.bus(1) : *(0.5) : predelay : bw_filter : diffusion_network <: ((si.bus(2) :> _) ~ (reverb_network : ro.cross(1)))
with {
    // allpass using delay with fixed size
    allpass_f(t, a) = (+ <: @(t),*(a)) ~ *(-a) : mem,_ : +;

    // input pre-delay and diffusion
    predelay = @(pre_delay);
    bw_filter = *(bw) : +~(mem : *(1-bw));
    diffusion_network = allpass_f(142, i_diff1) : allpass_f(107, i_diff1) : allpass_f(379, i_diff2) : allpass_f(277, i_diff2);

    // reverb loop
    reverb_network = par(i, 1, block(i)) with {
        d = (672, 908, 4453, 4217, 1800, 2656, 3720, 3163);
        block(i) = allpass_f(ba.take(i+1, d),-d_diff1) : @(ba.take(i+3, d)) : damp :
            allpass_f(ba.take(i+5, d), d_diff2) : @(ba.take(i+5, d)) : *(decay)
        with {
            damp = *(1-damping) : +~*(damping) : *(decay);
        };
    };
};

madstorrodemo = _ <: madstorro_rev(pre_delay, bw, i_diff1, i_diff2, decay, d_diff1, d_diff2, damping)
with {
    pre_delay = 0;
    bw = hslider("Prefilter",0.7,0.0,1.0,0.001) : si.smoo;
    i_diff1 = hslider("InputDiffusion1",0.625,0.0,1.0,0.001) : si.smoo;
    i_diff2 = hslider("InputDiffusion2",0.625,0.0,1.0,0.001) : si.smoo;

    d_diff1 = hslider("DecayDiffusion1",0.625,0.0,1.0,0.001) : si.smoo;
    d_diff2 = hslider("DecayDiffusion2",0.625,0.0,1.0,0.001) : si.smoo;
    decay = hslider("DecayRate",0.7,0.0,1.0,0.001) : si.smoo;
    damping = hslider("Damping",0.625,0.0,1.0,0.001) : si.smoo;
};

process = madstorrodemo;
