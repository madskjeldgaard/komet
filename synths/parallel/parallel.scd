//------------------------------------------------------------------//
//                2 band parallel processing effects                //
//           split input into two bands and process each            //
//                    through a different effect                    //
//------------------------------------------------------------------//
(
K_FX.addParallel2(\comb, \vocoder8bands, \channelized);
K_FX.addParallel2(\vocoder8bands, \comb, \channelized);
K_FX.addParallel2(\freqshift, \comb, \channelized);
K_FX.addParallel2(\klank, \comb, \channelized);
K_FX.addParallel2(\freqshift, \pitchshift1, \channelized);
)
