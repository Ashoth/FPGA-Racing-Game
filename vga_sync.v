`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CalPoly Pomona
// Engineer: 
// 
// Create Date: 10/04/2016 10:23:49 AM
// Design Name: 
// Module Name: vga_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 _ File Created
// Additional Comments: modified by Ashot Hambardzumyan to support 100M clock. 
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_sync(
input clk, reset,
output wire hsync, vsync, video_on, p_tick,
output wire [9:0] pixel_x, pixel_y);

// constant decleration
// VGA 640-by-480 sync parameters
localparam HD = 640; // horizontal display area
localparam HF = 48; // h . front (left) border
localparam HB = 16; // h . back (right) border
localparam HR = 96; // h . retrace
localparam VD = 480; // vertical display area
localparam VF = 10; // v . front (top) border
localparam VB = 33; // v . back (bottom) border
localparam VR = 2; // v . retrace

// mod-4 counter
reg [1:0] mod4_reg;
//sync counters
reg [9:0] h_count_reg, h_count_next;
reg [9:0] v_count_reg, v_count_next;
//output buffer
reg v_sync_reg, h_sync_reg;
wire v_sync_next, h_sync_next;
//status signal
wire h_end, v_end, pixel_tick;

// body
// registers
always @(posedge clk, posedge reset)
    if (reset)
        begin
        mod4_reg <= 2'b0;
        v_count_reg <= 0;
        h_count_reg <= 0;
        v_sync_reg <= 1'b0;
        h_sync_reg <= 1'b0;
        end
    else
        begin
        mod4_reg <= mod4_reg + 1;
        v_count_reg <= v_count_next;
        h_count_reg <= h_count_next;
        v_sync_reg <= v_sync_next ;
        h_sync_reg <= h_sync_next ;
        end


//status signal
// end of horizontal counter (799)
assign h_end = (h_count_reg==(HD+HF+HB+HR-1)) ;
// end of vertical counter (524)
assign v_end = (v_count_reg==(VD+VF+VB+VR-1)) ;

//next-state logic of mod-800 horizontal sync counter
always @*
    if (p_tick) // 25 MHz pulse
        if (h_end)
            h_count_next = 0;
        else
            h_count_next = h_count_reg + 1;
    else
        h_count_next = h_count_reg;

//next-state logic of mod-525 vertical sync counter
always @*
    if (p_tick & h_end)
        if (v_end)
            v_count_next = 0;
        else
            v_count_next = v_count_reg + 1;
    else
        v_count_next = v_count_reg;

//horizontal and vertical sync, buffered to avaoid glitch
// h_svnc_next asserted between 656 and 751
assign h_sync_next = (h_count_reg>=(HD+HB) &&
                        h_count_reg<=(HD+HB+HR-1));
// vh_sync_next asserted between 490 and 491
assign v_sync_next = (v_count_reg>=(VD+VB) &&
                        v_count_reg<=(VD+VB+VR-1));
// video on/off
assign video_on = (h_count_reg<HD) && (v_count_reg<VD);

// output
assign hsync = h_sync_reg;
assign vsync = v_sync_reg;
assign pixel_x = h_count_reg;
assign pixel_y = v_count_reg;
assign p_tick = &mod4_reg;  //devide the clock by 4

endmodule