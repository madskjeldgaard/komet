+ UGen {
   .klag{ arg time=0.1;
        var curvature = (-3);
        var warp = 5;
        var start = 0;
        ^VarLag.multiNew(this.rate, this, time, curvature, warp, start)
    }
}
