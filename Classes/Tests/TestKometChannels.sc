TestKometChannels : KometTest {
    test_check_wrongobj{
        this.assert(KometChannels.new(Slider.new).check() == false, "Slider as input not accepted")
    }

    test_objextension{
        this.assert(6.isKometChannel == false,"integer is not a komet channel");
        this.assert(KometChannels.new(2).isKometChannel == true,"komet channel is a komet channel");
    }

    test_ambisonics{
        var order = 3;
        var kom = KometChannels.new(HoaOrder(order));
        var expectedChannels = order.asHoaOrder.size;

        this.assert(kom.isAmbisonics, "Detected as ambisonics");
        this.assert(kom.check(), "check is okay");
        this.assert(kom.hoaOrder() == order, "order is correct");
        this.assert(kom.numChannels() == expectedChannels, "num channels is correct");

    }
}
