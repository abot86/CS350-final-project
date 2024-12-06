`timescale 1ns / 1ps

module ServoController(clk25mhz, reset, set_high_low, servoSignal);
    input clk25mhz;
    input reset;
    input set_high_low;
    output servoSignal;

    reg[9:0] duty_cycle_input_reg;
    wire[9:0] duty_cycle_input;

    assign duty_cycle_input = duty_cycle_input_reg;

    reg set_high_low_delayed;
    // prev state stored from main.s file


    always @(posedge clock) begin
        if (set_high_low == 1 && set_high_low_delayed == 0) begin
            duty_cycle_input_reg <= 51;     // duty cycle = 5
            #10;                            // wait
            duty_cycle_input_reg <= 77;     // duty cycle = 7.5
        end
        if (set_high_low == 0 && set_high_low_delayed == 1) begin
            duty_cycle_input_reg <= 92;     // duty cycle = 9
            #10;                            // wait
            duty_cycle_input_reg <= 77;     // duty cycle = 7.5
        end
        else begin
            duty_cycle_input_reg <= 77;     // duty cycle = 7.5
        end
    end

	ServoDriver PWM_out(.clk25mhz(clk25mhz), .reset(reset), .duty_cycle_input(duty_cycle_input), .servoSignal(servoSignal));


endmodule
