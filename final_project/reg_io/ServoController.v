`timescale 1ns / 1ps

module ServoController(clk25mhz, reset, r2case, servoSignal, testing);
    input clk25mhz;
    input reset;
    input [2:0] r2case;
    output servoSignal;

    output [15:0] testing;
    assign testing[9:0] = duty_cycle_input_reg;

    reg [29:0] counter;
    reg[9:0] duty_cycle_input_reg;
    wire[9:0] duty_cycle_input;
    

    assign duty_cycle_input = duty_cycle_input_reg;
    
    reg [4:0] r2case_reg;
    always @(posedge clk25mhz) r2case_reg <= r2case ;

    always @(posedge clk25mhz) begin
        if (r2case_reg == 0) begin
            if (counter >= 1000000000) begin
                duty_cycle_input_reg <= 77;
            end
            else begin
                duty_cycle_input_reg <= 51;
                counter <= counter + 1;
            end
        end
        if (r2case_reg == 1) begin
            if (counter >= 1000000000) begin
                duty_cycle_input_reg <= 77;
            end
            else begin
                duty_cycle_input_reg <= 92;
                counter <= counter + 1;
            end
        end
        if (r2case_reg == 2) begin
            counter <= 0;
            duty_cycle_input_reg <= 92;
        end
        if (r2case_reg == 3) begin
            counter <= 0;
            duty_cycle_input_reg <= 51;
        end
    end

	ServoDriver PWM_out(.clk25mhz(clk25mhz), .reset(reset), .duty_cycle_input(duty_cycle_input), .servoSignal(servoSignal));

endmodule
