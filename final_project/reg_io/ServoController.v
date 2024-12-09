`timescale 1ns / 1ps

module ServoController(clk25mhz, reset, set_high_low, servoSignal, testing);
    input clk25mhz;
    input reset;
    input [4:0] set_high_low;
    output servoSignal;
    output [15:0] testing;

    reg[9:0] duty_cycle_input_reg;
    wire[9:0] duty_cycle_input;

    assign duty_cycle_input = duty_cycle_input_reg;
    reg [4:0] set_high_low_reg;
    
    always @(posedge clk25mhz) set_high_low_reg <= set_high_low ;

    assign testing[4:0]  = set_high_low_reg;
    assign testing[14:5] = duty_cycle_input  ;


// do we still need below?
    reg set_high_low_delayed;
    // prev state stored from main.s file


    always @(posedge clk25mhz) begin
        if (set_high_low_reg == 5'd1) begin
            duty_cycle_input_reg <= 51;     // duty cycle = 5
            #1000000000;                     // wait 1s
            duty_cycle_input_reg <= 77;     // duty cycle = 7.5
//            #10;
        end
        if (set_high_low_reg == 5'd2) begin
            duty_cycle_input_reg <= 92;     // duty cycle = 9
            #1000000000;                    // wait 1s
            duty_cycle_input_reg <= 77;     // duty cycle = 7.5
//            #10;
        end
        else begin
            duty_cycle_input_reg <= 77;     // duty cycle = 7.5
        end
    end

	ServoDriver PWM_out(.clk25mhz(clk25mhz), .reset(reset), .duty_cycle_input(duty_cycle_input), .servoSignal(servoSignal));

endmodule
