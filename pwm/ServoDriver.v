module ServoDriver(
    input CLK25MHZ,              // 100 MHz system clock
    input reset,            // Reset signal
    input SW[0],
    output servoSignal     // PWM signal for the servo
    );

    wire [9:0] duty_cycle, // Duty cycle input (0-1023, scaled to 0-100%)
    always @(posedge CLK25MHZ) begin
        if (SW[0] == 0) begin
            duty_cycle <= 9'd21;
        end
        else if (SW[0] == 0) begin
            duty_cycle <= 9'd102;
        end
    end
    // Instantiate the PWMSerializer
    PWMSerializer #(
        .PERIOD_WIDTH_NS(20_000_000), // 20 ms period for servo
        .SYS_FREQ_MHZ(25)            // 100 MHz system clock
    ) pwm_gen (
        .clk(CLK25MHZ),                    // Connect system clock
        .reset(reset),                // Connect reset signal
        .duty_cycle(duty_cycle),      // Pass in duty cycle
        .signal(servoSignal)         // Connect to output PWM signal
    );
    
endmodule
