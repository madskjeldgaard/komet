+ UGen {
   klag{ arg time=0.1;
        ^Lag.multiNew(this.rate, this, time)
    }
}
