`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 11/23/2016 04:59:16 PM
// Design Name: 
// Module Name: time_text
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


module time_text(
input wire clk, reset, pause,
input wire refresh_tick,
input wire [9:0] pix_x, pix_y,
output wire time_on,
output wire [2:0] bit_addr,
output wire [10:0] rom_addr);
    
//variables 
wire [3:0] row_addr;    
reg [6:0] char_addr;
reg [23:0] time_tick;
reg [9:0] raceTime;
reg [3:0] dig_10th, dig_1s, dig_10s;

assign time_on = (pix_y [9: 5] ==0) && (pix_x [9: 4] <9) ;
assign row_addr = pix_y [4:1];
assign bit_addr = pix_x [3:1];
assign rom_addr = {char_addr, row_addr};
 
//measure time in miliseonds
always@(posedge clk)
begin
time_tick <= time_tick + 1;
if(reset)
    raceTime<=0;
else if(pause)
    raceTime <=raceTime;
else if(time_tick==10000000) //0.1 second
begin
    time_tick<=0;
    raceTime <= raceTime + 1;
end

//calculate decimal digits
if(refresh_tick)
    begin
    dig_10th <= raceTime%10;
    dig_1s <= (raceTime%100)/10;
    dig_10s <= (raceTime%1000)/100;
    end
end 


always @*
case (pix_x [7:4])
4'h0: char_addr = 7'h54; // T
4'h1: char_addr = 7'h69; // i
4'h2: char_addr = 7'h6d; // m
4'h3: char_addr = 7'h65; // e
4'h4: char_addr = 7'h3a; // :
4'h5: char_addr = {3'b011, dig_10s}; // d i g i t 10
4'h6: char_addr = {3'b011, dig_1s}; // d i g i t 1
4'h7: char_addr = 7'h2e; // .
4'h8: char_addr = {3'b011, dig_10th}; // d i g i t 10th
default: char_addr = 7'h00; // 
endcase


endmodule
