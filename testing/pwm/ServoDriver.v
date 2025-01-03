module ServoDriver(
    input clk25mhz,              // 100 MHz system clock
    input BTNC,            // Reset signal
    input [9:0] duty_cycle_input,
    output servoSignal     // PWM signal for the servo
    );

    wire clk;
    wire locked;
    
    assign clk = clk25mhz;
    


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
