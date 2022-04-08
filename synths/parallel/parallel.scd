//------------------------------------------------------------------//
//                2 band parallel processing effects                //
//           split input into two bands and process each            //
//                    through a different effect                    //
//------------------------------------------------------------------//
(
KometFXFactory.addParallel2(\comb, \vocoder8bands, \channelized);
KometFXFactory.addParallel2(\vocoder8bands, \comb, \channelized);
KometFXFactory.addParallel2(\freqshift, \comb, \channelized);
KometFXFactory.addParallel2(\klank, \comb, \channelized);
KometFXFactory.addParallel2(\freqshift, \pitchshift1, \channelized);
)
