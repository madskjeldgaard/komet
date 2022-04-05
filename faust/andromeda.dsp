import("stdfaust.lib");

// Modified version of Liam Wall's original from: https://raw.githubusercontent.com/ljwall/er-301-units/main/faustian/dsp/Andromeda.dsp
declare andromeda author "Liam Wall";
declare andromeda license "MIT-style STK-4.3 license";

andromeda(decay, low_pass, high_pass) = _,_ : + : *(0.5) : diffusion_network : (+~chain) <: chain_l, chain_r with {

  // allpass using delay with fixed size
  allpass_f(t, a) = (+ <: @(t),*(a)) ~ *(-a) : mem,_ : +;
  i_diff1 = 0.75;
  i_diff2 = 0.625;
  diffusion_network = allpass_f(235, i_diff1) : allpass_f(177, i_diff1) : allpass_f(627, i_diff2) : allpass_f(458, i_diff2);

  line = de.fdelayltv(2, 28800);
  taps = (0.047, 0.120, 0.134, 0.146, 0.158, 0.169, 0.180, 0.190, 0.200, 0.209, 0.217, 0.233, 0.240, 0.244, 0.225, 0.247);

  mod = hslider("mod", 50, 0, 100, 0);

  min_mod = 31, 25, 19, 11;
  mid_mod = 130, 63, 43, 20;
  max_mod = 313, 310, 251, 250;

  epsilon = par(i, 4,
    (mod <= 50)*(ba.take(i+1, min_mod) + (mod/50) * (ba.take(i+1, mid_mod) - ba.take(i+1, min_mod))) +
    (mod > 50)*(ba.take(i+1, mid_mod) + (mod/50 - 1) * (ba.take(i+1, max_mod) - ba.take(i+1, mid_mod)))
  );
  e1 = ba.take(1, epsilon) / 1000000;
  e2 = ba.take(2, epsilon) / 1000000;
  e3 = ba.take(3, epsilon) / 1000000;
  e4 = ba.take(4, epsilon) / 1000000;

  mods = x,xq,-x,-xq , y,yq,-y,-yq, z,zq,-z,-zq, a,aq,-a,-aq letrec {
    'xq = os.impulse + xq - e1*x;
    'x = e1 * (xq - e1 *x) + x;

    'yq = os.impulse + yq - e2*y;
    'y = e2 * (yq - e2 *y) + y;

    'zq = os.impulse + zq - e3*z;
    'z = e3 * (zq - e3 *z) + z;

    'aq = os.impulse + aq - e4*a;
    'a = e4 * (aq - e4 *a) + a;
  };
  limiter(x) = 2 * x / sqrt(x*x +4);
  depth = ba.sec2samp(0.004);
  chain = _
       <: par(i, ba.count(taps), line(ba.sec2samp(ba.take(i+1, taps)) + depth*ba.take(1 + (i % (ba.count(mods))), mods)))
       :> /(ba.count(taps))
        : fi.lowpass(1, low_pass)
        : fi.highpass(1, high_pass)
        : *(decay)
        : limiter;

  line_out = de.delay(24000);
  taps_l = (0.060, 0.137, 0.175, 0.190);
  taps_r = (0.077, 0.112, 0.160, 0.212);
  chain_l = _ <: par(i, ba.count(taps_l), line_out(ba.take(i+1, taps_l) : ba.sec2samp)) :> /(ba.count(taps_l));
  chain_r = _ <: par(i, ba.count(taps_r), line_out(ba.take(i+1, taps_r) : ba.sec2samp)) :> /(ba.count(taps_r));
};

process = _,_ : andromeda(decay_ctrl, low_ctrl, high_ctrl)
with {
  decay_ctrl = hslider("Decay", 0.8, 0, 5, 0.001) : si.smoo;
  low_ctrl = hslider("HighCut", 20000, 100, 20000, 100) : min(20000) : max(100);
  high_ctrl = hslider("LowCut", 20, 20, 20000, 100) : min(20000) : max(20);
};
