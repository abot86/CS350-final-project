    // // PLL Clocking - REDO PLL LATER, NOT PUSHED TO GIT
    clk_wiz_0 PLL(
        .clk_out1(clk25mhz),
        .reset(BTNC),
        .locked(locked),
        .clk_in1(CLK100MHZ));