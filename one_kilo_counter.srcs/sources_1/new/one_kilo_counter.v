`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2024 14:25:39
// Design Name: 
// Module Name: one_kilo_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module one_kilo_counter( input clk, rst, output reg [6:0]seg1, output reg [6:0]seg2, output reg [3:0]an1, output reg [3:0]an2

    );
        reg [26:0]ctr;
        reg [16:0]clk_ctr = 17'b0;
    reg clk_indicator = 1'b0;
    //creating a trigger every 100,000 cycles for 1khz clock
    always@(posedge clk) begin
        if(clk_ctr==100000) begin
        clk_ctr<=17'b0;
        clk_indicator <= 1'b1;
        end
        else begin
        clk_ctr<=clk_ctr+1;
        clk_indicator <= 1'b0;
        end
    end
    //creating 1khz clock 
    always@(posedge clk_indicator) begin
        if(rst==1)
        ctr<=27'b0;
        else
        ctr<=ctr+1;
    end
//-----------------------------------------------------------------------------------
        // DISPLAYING CTR IN 7 SEGMENT DISPLAY
//-----------------------------------------------------------------------------------
reg [17:0] refresh_counter;
wire [1:0] activating_ctr;
always@(posedge clk or posedge rst) begin
if(rst==1)
refresh_counter<=1;
else 
refresh_counter<=refresh_counter+1;
end

assign activating_ctr = refresh_counter[17:16];
reg [3:0]single_disp1;
reg [3:0]single_disp2;

always @(*) begin
    case (activating_ctr)
        2'b00: begin
            an1 = 4'b0111;
            single_disp1 = ctr / 10000000;
        end
        2'b01: begin
            an1 = 4'b1011;
            single_disp1 = (ctr%10000000) / 1000000;
        end
        2'b10: begin
            an1 = 4'b1101;
            single_disp1 = ((ctr%10000000) % 1000000) / 100000;
        end
        2'b11: begin
            an1 = 4'b1110;
            single_disp1 = (((ctr%10000000) % 1000000) % 100000) / 10000;
        end
    endcase
end

// For anode 2
always @(*) begin
    case (activating_ctr)
        2'b00: begin
            an2 = 4'b0111;
            single_disp2 = ((((ctr%10000000) % 1000000) % 100000) % 10000) / 1000;
        end
        2'b01: begin
            an2 = 4'b1011;
            single_disp2 = (((((ctr%10000000) % 1000000) % 100000) % 10000) % 1000) / 100;
        end
        2'b10: begin
            an2 = 4'b1101;
            single_disp2 = ((((((ctr%10000000) % 1000000) % 100000) % 10000) % 1000) % 100) / 10;
        end
        2'b11: begin
            an2 = 4'b1110;
            single_disp2 = (((((((ctr%10000000) % 1000000) % 100000) % 10000) % 1000) % 100) % 10);
        end
    endcase
end


//-------Cathode pattern for 7 segment display---------
// for display 1
always@(*) begin
case(single_disp1)
        4'b0000: seg1 = 7'b1000000; // "0"     
        4'b0001: seg1 = 7'b1111001; // "1" 
        4'b0010: seg1 = 7'b0100100; // "2" 
        4'b0011: seg1 = 7'b0110000; // "3" 
        4'b0100: seg1 = 7'b0011001; // "4" 
        4'b0101: seg1 = 7'b0010010; // "5" 
        4'b0110: seg1 = 7'b0000010; // "6" 
        4'b0111: seg1 = 7'b1111000; // "7" 
        4'b1000: seg1 = 7'b0000000; // "8"     
        4'b1001: seg1 = 7'b0010000; // "9" 
        default: seg1 = 7'b1000000; // "0"
        endcase
end

// for display 2
always@(*) begin
case(single_disp2)
        4'b0000: seg2 = 7'b1000000; // "0"     
        4'b0001: seg2 = 7'b1111001; // "1" 
        4'b0010: seg2 = 7'b0100100; // "2" 
        4'b0011: seg2 = 7'b0110000; // "3" 
        4'b0100: seg2 = 7'b0011001; // "4" 
        4'b0101: seg2 = 7'b0010010; // "5" 
        4'b0110: seg2 = 7'b0000010; // "6" 
        4'b0111: seg2 = 7'b1111000; // "7" 
        4'b1000: seg2 = 7'b0000000; // "8"     
        4'b1001: seg2 = 7'b0010000; // "9" 
        default: seg2 = 7'b1000000; // "0"
        endcase
end
//----------------------------------------------------------------
    
endmodule
