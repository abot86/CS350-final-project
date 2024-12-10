`timescale 1ns / 1ps

module ServoController(clk25mhz, reset, r26, servoSignal, testing);
    input clk25mhz;
    input reset;
    input [4:0] r26;
    output servoSignal;

     output [15:0] testing;
//     assign testing[3:0] = treg[3:0];
     assign testing[9:0] = duty_cycle_input_reg[9:0];
     assign testing[11:10] = state;
     assign testing[15] = r26_reg;
    
    reg [5:0] treg; 

    reg [29:0] counter;
    reg[9:0] duty_cycle_input_reg;
    wire[9:0] duty_cycle_input;
    
    assign duty_cycle_input = duty_cycle_input_reg;
    
    reg [4:0] r26_reg;
    reg [1:0] state;
    
    always @(posedge clk25mhz) r26_reg <= r26[4:0];
    assign HIGH = &r26_reg;
    assign LOW = &(!r26_reg);
    
    always @(posedge clk25mhz) begin
        if (reset != 0) begin
            duty_cycle_input_reg <= 45;
            counter <= 0;
            state = 2'b00;
        end
        
        // OPEN
        else if (state == 2'b00) begin
            counter <= 0;
            duty_cycle_input_reg <= 45;
            if (HIGH == 1'b1) begin
                state <= 2'b01;
            end
        end
        
        // CLOSED
        else if (state == 2'b11) begin
            counter <= 0;
            duty_cycle_input_reg <= 45;
            if (LOW == 1'b1) begin
                state <= 2'b10;
            end
        end
        
        // CLOSING
        else if (state == 2'b01) begin
            counter <= counter+1;
            duty_cycle_input_reg <= 20; 
            if (counter >= 80000000) begin     
                state <= 2'b11;
            end
        end
        
        // OPENING
        else if (state == 2'b10) begin
            counter <= counter+1;
            duty_cycle_input_reg <= 68;
            if (counter >= 80000000) begin
                state <= 2'b00;
            end
        end
    end
    
    
    
//    always @(posedge clk25mhz) begin
//        if (reset != 0) begin
//            duty_cycle_input_reg <= 45;
//            counter <= 0;
//        end
//        else if (r2case_reg == 1) begin
//            if (counter >= 40000000) begin
//                duty_cycle_input_reg <= 45;
//                treg <= 1;
//            end
//            else begin
//                duty_cycle_input_reg <= 20;
//                counter <= counter + 1;
//                treg <= 2;
//            end
//        end
//        else if (r2case_reg == 2) begin
//            if (counter >= 40000000) begin
//                duty_cycle_input_reg <= 45;
//                treg <= 3;
//            end
//            else begin
//                duty_cycle_input_reg <= 70;
//                counter <= counter + 1;
//                treg <= 4;
//            end
//        end
//        else if (r2case_reg == 3) begin
//            counter <= 0;
//            duty_cycle_input_reg <= 70;
//            treg <= 5;
//        end
//        else if (r2case_reg == 4) begin
//            counter <= 0;
//            duty_cycle_input_reg <= 20;
//            treg <= 6;
//        end
//        // LAST CASE FOR TESTING ONLY
//        else if (r2case_reg == 5) begin
//            duty_cycle_input_reg <= 45;
//            treg <= 7;
//        end
//    end

	ServoDriver PWM_out(.clk25mhz(clk25mhz), .reset(reset), .duty_cycle_input(duty_cycle_input), .servoSignal(servoSignal));

endmodule
