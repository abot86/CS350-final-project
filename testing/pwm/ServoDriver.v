module ServoDriver(
    input CLK100MHZ,              // 100 MHz system clock
    input BTNC,            // Reset signal
    input BTNU,
    output servoSignal     // PWM signal for the servo
    );

    wire clk25mhz;
    wire clk;
    wire locked;
    
    assign clk = clk25mhz;
    
    // // PLL Clocking - REDO PLL LATER, NOT PUSHED TO GIT
    clk_wiz_0 PLL(
        .clk_out1(clk25mhz),
        .reset(BTNC),
        .locked(locked),
        .clk_in1(CLK100MHZ));

    reg [9:0] duty_cycle; // Duty cycle input (0-1023, scaled to 0-100%)
    always @(posedge clk) begin
        if (BTNU == 0) begin
            duty_cycle <= 9'd21;
        end
        else if (BTNU == 1) begin
            duty_cycle <= 9'd102;
        end
    end
    // Instantiate the PWMSerializer
    PWMSerializer #(
        .PERIOD_WIDTH_NS(20_000_000), // 20 ms period for servo
        .SYS_FREQ_MHZ(25)            // 25 MHz system clock
    ) pwm_gen (
        .clk(clk),                    // Connect system clock
        .reset(BTNC),                // Connect reset signal
        .duty_cycle(duty_cycle),      // Pass in duty cycle
        .signal(servoSignal)         // Connect to output PWM signal
    );
    
endmodule
