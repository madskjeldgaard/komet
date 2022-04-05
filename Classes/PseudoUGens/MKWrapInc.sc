/*
 * This is similar to Wrap except that it includes the upper boundary and so is
 * only different in the special case where the upper boundary is reached:
 *
 * Compare:
 * Wrap.kr(1.0, 0.0, 1.0) == -1.0
 *
 * KWrapInc.kr(1.0, 0.0, 1.0) == 1
 *
 *
 * See https://scsynth.org/t/what-is-the-intended-behaviour-of-wrapping/4911/5
 *
 * For more information.
 *
 */

KWrapInc{
  *new1{|rate, in, wrapMin, wrapMax|
    ^this.init(rate, in, wrapMin, wrapMax)
  }

  *ar{|in, wrapMin=0.0, wrapMax=1.0|
    ^if(in.asUGenInput.rate != \audio, {
      "%: input not audio rate".format(this.name).error;
        nil
      }, {
        this.new1('ar', in, wrapMin, wrapMax)
    })
  }

  *kr{|in, wrapMin=0.0, wrapMax=1.0|
    ^if(in.asUGenInput.rate != \control, {
      "%: input not control rate".format(this.name).error;
        nil
      }, {
        this.new1('kr', in, wrapMin, wrapMax)
    })
  }

  *init{|rate, in, wrapMin, wrapMax|
    var wrapped;
    var hasReachedMax = BinaryOpUGen('==', in, wrapMax);

    wrapped = Select.perform(rate, hasReachedMax, [ Wrap.perform(rate, in, wrapMin, wrapMax), DC.ar(wrapMax) ])

    ^wrapped;
  }

}
