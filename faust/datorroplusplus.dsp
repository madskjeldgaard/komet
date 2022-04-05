import("stdfaust.lib");

// Modified by Mads Kjeldgaard. Original is here: https://raw.githubusercontent.com/ljwall/er-301-units/main/faustian/dsp/DattorroPlusPlus.dsp
declare dattorro_rev_2 author "Jakob Zerbian, Liam Wall";
declare dattorro_rev_2 license "MIT-style STK-4.3 license";

dattorro_rev_2(pre_delay, bw, i_diff1, i_diff2, decay, d_diff1, d_diff2, damping) =
    si.bus(2) : + : *(0.5) : predelay : bw_filter : diffusion_network : reverb_loop
with {
    // allpass using delay with fixed size
    allpass_f(t, a) = (+ <: @(t),*(a)) ~ *(-a) : mem,_ : +;
    // allpass using delay with fixed size, and two extra taps
    allpass_f_taps(t, a, tap_1, tap_2) = (+ <: @(t),*(a),@(tap_1),@(tap_2)) ~ *(-a) : mem,_,_,_ : +,_,_;
    // allpass using delay with excursion
    allpass_exc(t, a, i) = (+ <: de.fdelayltv(2, t+20, t + 16*ba.take(i, mods)),*(a)) ~ *(-a) : mem,_ : +
    with {
      epsilon = 0.00013; // Around 1Hz
      mods = y,yq letrec {
          'yq = os.impulse + yq - epsilon*y;
          'y = epsilon * (yq - epsilon *y) + y;
      };
    };

    // input pre-delay and diffusion
    predelay = de.delay(9600, pre_delay);
    bw_filter = *(bw) : +~(mem : *(1-bw));
    diffusion_network = allpass_f(235, i_diff1) : allpass_f(177, i_diff1) : allpass_f(627, i_diff2) : allpass_f(458, i_diff2);
    damp = (*(1-damping) : +~*(damping) : *(decay)), _,_;

    // /********* left  output,  all  wet  *********/
    // [x] accumulator =  0.6  X  node48_54[266]
    // [x] accumulator +=  0.6  x  node48_54[2974]
    // [x] accumulator -=  0.6  X  node55_59[1913]
    // [x] accumulator +=  0.6  X  node59_63[1996]
    // [x] accumulator -=  0.6  X  node24_30[1990]
    // [x] accumulator -=  0.6  x  node31_33[187]
    // [x] YL  =  accumulator -  0.6  X  node33_39[1066]

    // /********* right  output,  all  wet  *********/
    // [x] accumulator =  0.6  X  node24_30[353]
    // [x] accumulator +=  0.6  X  node24_30[3627]
    // [x] accumulator -=  0.6  X  node31_33[1228]
    // [x] accumulator +=  0.6  X  node33_39[2673]
    // [x] accumulator -=  0.6  X  node48_54[2111]
    // [x] accumulator -=  0.6  X  node55_59[335]
    // [x] YR  =  accumulator -  0.6  X  node59_63[121]

    // Contains node23_24
    decay_diffusion_1a = allpass_exc(1112,-d_diff1, 1),_,_;

    // node24_30
    z_4453 = (_ <: @(7370), @(3293), @(584), @(6003) : _,_,+ : _,*(-0.6),*(0.6)),_,_ : _,_,ro.cross(2),_ : _,+,+;

    // Contains node31_33
    decay_diffusion_2a = (allpass_f_taps(2979, d_diff2, 309, 2032) : _,*(-0.6),*(-0.6)),_,_ : _,_,ro.cross(2),_ : _,+,+;

    // node33_39
    z_3720 = (_ <: @(6157), @(1764), @(4424) : _,*(-0.6),*(0.6)),_,_ : _,_,ro.cross(2),_ : _,+,+;

    // Contains node46_48
    decay_diffusion_1b = allpass_exc(1502,-d_diff1, 2),_,_;

    // node48_54
    z_4217 = (_ <: @(6979), @(440), @(4922), @(3494) : _,+,_ : _,*(0.6),*(-0.6)),_,_ : _,_,ro.cross(2),_ : _,+,+;

    // Contains node55_59
    decay_diffusion_2b = (allpass_f_taps(4396, d_diff2, 3166, 554): _,*(-0.6),*(-0.6)),_,_ : _,_,ro.cross(2),_ : _,+,+;

    // node59_63
    z_3163 = (_ <: @(5235), @(3303), @(200) : _,*(0.6),*(-0.6)),_,_ : _,_,ro.cross(2),_ : _,+,+ ;

    // Three channels: (1) is the output to loop, (2) is Left, and (3) is right.
    reverb_chain(loop_in, in)
         = (loop_in+in)
        <: (_,_,_)
         : decay_diffusion_1a
         : z_4453
         : damp
         : decay_diffusion_2a
         : z_3720
         : (*(decay),_,_)
         : (+(in),_,_)
         : decay_diffusion_1b
         : z_4217
         : damp
         : decay_diffusion_2b
         : z_3163
         : (*(decay),_,_);

    reverb_loop = reverb_chain~_ : (si.block(1),_,_);
};

// Dattorro reverb with difusion parameters as per https://ccrma.stanford.edu/~dattorro/EffectDesignPart1.pdf
reverb(pre_delay, band_width, decay, damping) = dattorro_rev_2(pre_delay, band_width, 0.75, 0.625, decay, 0.7, 0.5, damping);

// Controls (will become parameters in the er-301 object)
pre_delay_ctrl = hslider("Predelay", 10, 0, 100, 0.5) : /(1000) : ba.sec2samp;
band_width_ctrl = hslider("BandWidth", 0.6, 0, 1, 0.001) : si.smoo;
decay_ctrl = hslider("Decay", 0.8, 0, 1, 0.001) : si.smoo;
damping_ctr = hslider("Damping", 0.25, 0, 1, 0.001) : si.smoo;

process = _,_ : reverb(pre_delay_ctrl, band_width_ctrl, decay_ctrl, damping_ctr);
