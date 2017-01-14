`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 11/23/2016 04:58:38 PM
// Design Name: 
// Module Name: start
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


module start(
input wire clk, enable,
input wire [9:0] pix_x, pix_y,
output wire start_on,
output wire [2:0] bit_addr,
output wire [10:0] rom_addr);


wire [3:0] row_addr;
reg [6:0] char_addr;

assign row_addr = pix_y [6:3];
//each char is 64 pixel in x direction, full screen can have 10 chars
//to put the text in the middle, I have 2.5 chars spcae on each side
//I need to shift the bit_addr
assign bit_addr = pix_x [5:3]-3'd4; 
assign rom_addr = {char_addr, row_addr};
assign start_on = (pix_y [9: 7] ==1) && (pix_x [9: 5] <15)
                     && (pix_x [9: 5] >4) && enable;
 
always @*
case (pix_x [9:5])
5'h5,5'h6: char_addr = 7'h53; // S
5'h7,5'h8: char_addr = 7'h74; // t
5'h9,5'ha: char_addr = 7'h61; // a
5'hb,5'hc: char_addr = 7'h72; // r
5'hd,5'he: char_addr = 7'h74; // t
default: char_addr = 7'h00; // 
endcase

endmodule
