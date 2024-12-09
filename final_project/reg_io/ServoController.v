`timescale 1ns / 1ps

module ServoController(clk25mhz, reset, r2case, servoSignal, testing);
    input clk25mhz;
    input reset;
    input [2:0] r2case;
    output servoSignal;

    output [15:0] testing;
    assign testing[5:0] = treg[5:0];
    
    reg [5:0] treg; 

    reg [29:0] counter;
    reg[9:0] duty_cycle_input_reg;
    wire[9:0] duty_cycle_input;
    
    assign duty_cycle_input = duty_cycle_input_reg;
    
    reg [4:0] r2case_reg;
    always @(posedge clk25mhz) r2case_reg <= r2case ;

    always @(posedge clk25mhz) begin
        if (reset != 0) begin
            duty_cycle_input_reg <= 45;
            counter <= 0;
        end
        else if (r2case_reg == 0) begin
            if (counter >= 10000000) begin
                duty_cycle_input_reg <= 45;
                treg <= 1;
            end
            else begin
                duty_cycle_input_reg <= 20;
                counter <= counter + 1;
                treg <= 2;
            end
        end
        else if (r2case_reg == 1) begin
            if (counter >= 10000000) begin
                duty_cycle_input_reg <= 45;
                treg <= 3;
            end
            else begin
                duty_cycle_input_reg <= 70;
                counter <= counter + 1;
                treg <= 4;
            end
        end
        else if (r2case_reg == 2) begin
            counter <= 0;
            duty_cycle_input_reg <= 70;
            treg <= 5;
        end
        else if (r2case_reg == 3) begin
            counter <= 0;
            duty_cycle_input_reg <= 20;
            treg <= 6;
        end
        // LAST CASE FOR TESTING ONLY
        else if (r2case_reg == 5) begin
            duty_cycle_input_reg <= 45;
            treg <= 7;
        end
    end

	ServoDriver PWM_out(.clk25mhz(clk25mhz), .reset(reset), .duty_cycle_input(duty_cycle_input), .servoSignal(servoSignal));

endmodule
