/*

Granola was made by Jean-Louis Paquelin. Thanks Jean-Louis!

https://github.com/jlp6k/faust-things

*/
import("stdfaust.lib");
import("faust-things/Granola.dsp");

BUFFER_DURATION = 10; // Seconds
CONCURRENT_GRAINS = 10;

/*-------------------------------*/

// FREEZE / recording
freeze_ctrl = button("Freeze");

// TODO: Not used. Remove somehow
// writeIndex_disp = hbargraph("writeIndex", 0, ceil(BUFFER_DURATION * 48000) : int);
writeIndex_disp = _;

// Automatic triggering from 0.1 to 1000Hz
density_ctrl = hslider("density", 1, 0.01, 1000, 0.01) : si.smoo;
// Manual triggering
seed_ctrl = button("SEED");
// Input Gain
input_gain_ctrl = vslider("input_gain", 0, -1.5, 1, 0.01) : si.smoo : bipollin2exppos(100);
// Feedback
feedback_ctrl = vslider("feedback", 0, 0, 1, 0.01) : si.smoo;
// Output gain
output_gain_ctrl = vslider("output_gain", 0, -1, 1, 0.01) : si.smoo : bipollin2exppos(100);
// dry (0) / wet (1)
wetting_ctrl = 1;

// position in the table
time_ctrl = hslider("time", 0, 0, 1, 0.001) : si.smoo;
// Grain size
size_ctrl = hslider("size", 0.5, 0.03, BUFFER_DURATION, 0.01) : si.smoo;

// Grain pitch
// TODO: Drop semitone idea
pitch_ctrl = hslider("pitch", 0, -48, 48, 0.5) : ba.semi2ratio;
// Backward playback
reverse_ctrl = button("reverse");

// Grain envelope shape
shape_ctrl = hslider("shape", 0, 0, 1, 0.01);
// In order to reduce the number of control knobs, the window plateau width and plateau position
// are extrapolated from a single shape control. The shape control varies from 0 to 1, smoothly
// morphing the window envelope from a constant 1, to a decreasing ramp, to a triangle and to an
// increasing ramp/saw.
plateau_width_ctrl = 1 - min(shape_ctrl * 3, 1);
plateau_position_ctrl = max((3 * shape_ctrl / 2) - 0.5, 0);

process = _ : Granola(BUFFER_DURATION,CONCURRENT_GRAINS).grains(
		freeze_ctrl,
		writeIndex_disp,
		density_ctrl,
		seed_ctrl,
		input_gain_ctrl,
		feedback_ctrl,
		output_gain_ctrl,
		wetting_ctrl,
		time_ctrl,
		size_ctrl,
		pitch_ctrl,
		reverse_ctrl,
		plateau_width_ctrl,
		plateau_position_ctrl
		) : co.limiter_1176_R4_mono : _;
