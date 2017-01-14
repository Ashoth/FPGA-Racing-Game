`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 10/27/2016 06:10:10 PM
// Design Name: 
// Module Name: text
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


module text(
input wire clk, reset, pause,
input wire refresh_tick,
input wire start_en, crash_en, finish_en,
input wire [9:0] pix_x, pix_y,
output wire text_on,
output reg [11:0] text_rgb);

// signal declaration
wire [7:0] font_word;
wire font_bit, time_on, start_on, crash_on, finish_on;
wire [10:0] time_rom_addr, start_rom_addr, 
        crash_rom_addr, finish_rom_addr;
wire [2:0] time_bit_addr, start_bit_addr, 
        crash_bit_addr, finish_bit_addr;
reg [10:0] rom_addr;
reg [2:0] bit_addr;


assign font_bit = font_word[~bit_addr];

assign text_on = time_on | (start_on&font_bit)
             |  (crash_on&font_bit) | (finish_on&font_bit);

// instantiate modules
font_rom font_unit
(.clk(clk), .addr(rom_addr), .data(font_word));

time_text mytime(clk, reset, pause, refresh_tick, 
    pix_x, pix_y, time_on, time_bit_addr, time_rom_addr);

start mystart(clk, start_en, pix_x, pix_y, start_on, 
            start_bit_addr, start_rom_addr);

finish myfinish(clk, finish_en, pix_x, pix_y, finish_on, 
            finish_bit_addr, finish_rom_addr);

game_over crash(clk, crash_en, pix_x, pix_y, crash_on, 
            crash_bit_addr, crash_rom_addr);


always @*
begin
    if(time_on)
        begin
        bit_addr <= time_bit_addr;
        rom_addr <= time_rom_addr;
        text_rgb <= 12'h110; // background yellow
        if (font_bit)
        text_rgb <= 12'h001; //font color
        end
    else if(start_on)
        begin
        bit_addr <= start_bit_addr;
        rom_addr <= start_rom_addr;
        text_rgb <= 12'h501; //font color
        end  
    else if(crash_on)
        begin
        bit_addr <= crash_bit_addr;
        rom_addr <= crash_rom_addr;
        text_rgb <= 12'h501; //font color
        end
    else if(finish_on)
        begin
        bit_addr <= finish_bit_addr;
        rom_addr <= finish_rom_addr;
        text_rgb <= 12'h501; //font color
        end

    
end

endmodule
