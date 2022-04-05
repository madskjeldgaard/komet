// Named control with prefix and suffix
K_NC {

  *new1{arg rate, name, values, lags, fixedLag = false, spec, suffix="", prefix="";
    name = this.fixedName(name, prefix, suffix);
    ^NamedControl.new(name, values, rate, lags, fixedLag, spec)
  }

	*kr{arg name, values, lags, fixedLag = false, spec, suffix="", prefix="";
      ^this.new1(\control, name, values, lags, fixedLag, spec, suffix, prefix)
    }

    *ir{arg name, values, lags, fixedLag = false, spec, suffix="", prefix="";
      ^this.new1(\scalar, name, values, lags, fixedLag, spec, suffix, prefix)
    }

*ar{arg name, values, lags, fixedLag = false, spec, suffix="", prefix="";
      ^this.new1(\audio, name, values, lags, fixedLag, spec, suffix, prefix)
    }

	*fixedName{|name,prefix="",suffix=""|
		^(prefix.asString ++ name.asString ++ suffix.asString).asSymbol;

	}
}
