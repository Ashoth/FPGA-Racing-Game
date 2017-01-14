`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 11/23/2016 08:18:44 PM
// Design Name: 
// Module Name: finish
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


module finish(
input wire clk, enable,
input wire [9:0] pix_x, pix_y,
output wire finish_on,
output wire [2:0] bit_addr,
output wire [10:0] rom_addr);


wire [3:0] row_addr;
reg [6:0] char_addr;

assign row_addr = pix_y [6:3];
assign bit_addr = pix_x [5:3];
assign rom_addr = {char_addr, row_addr};
assign finish_on = (pix_y [9: 7] ==1) && (pix_x [9: 6] <8)
                     && (pix_x [9: 6] >1) && enable;
 
always @*
case (pix_x [9:6])
4'h2: char_addr = 7'h46; // F
4'h3: char_addr = 7'h69; // i
4'h4: char_addr = 7'h6e; // n
4'h5: char_addr = 7'h69; // i
4'h6: char_addr = 7'h73; // s
4'h7: char_addr = 7'h68; // h
default: char_addr = 7'h00; // 
endcase

endmodule
