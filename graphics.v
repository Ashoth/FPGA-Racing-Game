`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 10/27/2016 05:57:13 PM
// Design Name: 
// Module Name: graphics
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


module graphics(
input wire clk, game_reset, pause, 
left_key, right_key, enter_key, video_on,
start_en,crash_en,finish_en,
input wire [9:0] pixel_x, pixel_y,
output wire road_on, finish_line, car_on,
output reg [11:0] rgb_out);

//////variables
reg refresh_tick; reg [1:0] state;
wire [11:0] road_rgb, car_rgb, text_rgb;


///instantiate models

//text
text mytext(clk, game_reset, pause, refresh_tick, 
        start_en,crash_en,finish_en,
         pixel_x, pixel_y, text_on, text_rgb);

//road
road race_road(clk,game_reset,refresh_tick,pause, enter_key,
        pixel_x,pixel_y,road_on, finish_line, road_rgb);

//car
car mycar(clk,game_reset,refresh_tick,left_key,right_key,pause,
            pixel_x,pixel_y,car_on,car_rgb);


// refr_tick: 1-clock tick asserted at start of v-sync
//            i.e., when the screen is refreshed (60 Hz)
//each pixel takes 1/25M sec, our clock is /100M sec, 
always @(posedge clk)
case(state)
0:if((pixel_y==481) && (pixel_x==0))
    begin
    refresh_tick <= 1'b1;
    state <= 2'b1;
    end
1: begin refresh_tick <= 1'b0; state <= 2'b10; end
2: state <= 2'b11;
3: state <= 2'b00;
endcase

//////////////////////////////////////////////
// rgb multiplexing circuit
//////////////////////////////////////////////
 always @*
    if (~video_on)
       rgb_out = 12'b0; // blank
    else
    if(text_on)
        rgb_out = text_rgb;
       else if (car_on)
         rgb_out = car_rgb;
       else if (road_on)
          rgb_out = road_rgb;
        else
          rgb_out = 12'h0e0; //  background

endmodule
