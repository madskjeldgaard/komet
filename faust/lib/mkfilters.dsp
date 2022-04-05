import("stdfaust.lib");

mkf = environment {

	  // OnePole LPF by Dario Sanfilippo: https://www.dariosanfilippo.com/blog/2020/faust_recursive_circuits/
	onepolelpf(cf, x) = b0 * x : + ~ *(-a1)
		with {
			b0 = 1 + a1;
			a1 = exp(-w(cf)) * -1;
			w(f) = 2 * ma.PI * f / ma.SR;
		};

};
