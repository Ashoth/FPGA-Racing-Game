`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 10/27/2016 05:57:13 PM
// Design Name: 
// Module Name: car
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


module car(
input wire clk, reset, refresh_tick,
input wire left_key, right_key, pause,
input wire [9:0] pixel_x, pixel_y,
output wire car_on,
output wire [11:0] car_rgb
);

//variables 
//square canvas for the road 
localparam MAX_X = 640;
localparam MAX_Y = 480;
localparam CAR_MAX_X = 32;
localparam CAR_MAX_Y = 64;
localparam car_y_t = 410;
localparam car_y_b = car_y_t + CAR_MAX_Y-1;
localparam CAR_VELOCITY = 3'd02;


wire [3:0] car_rom_addr; //16 lines
wire [2:0] car_rom_col; //8 lines
reg [0:7] car_rom_data; //8 bit data length
wire car_rom_bit, canvas_on;
reg [9:0] car_x_l = 304;
wire [9:0] car_x_r;

assign car_rgb = 12'h005; //car color
assign canvas_on =  (car_x_l<=pixel_x) && (pixel_x<=car_x_r)
                && (car_y_t <= pixel_y) && (pixel_y<=car_y_b);
//Car is 2X the size of bitmap
assign car_rom_addr = pixel_y[5:2] - car_y_t[5:2];
//can't ignore bit 0,1 like the line above
assign car_rom_col = (pixel_x - car_x_l)>>2; 
assign car_rom_bit = car_rom_data[car_rom_col];
assign car_on = canvas_on & car_rom_bit;
assign car_x_r = car_x_l + CAR_MAX_X-1;


//movement
always @(posedge clk)
begin
if (reset)
    begin
    car_x_l <= 304;
    end
else if (refresh_tick & !pause)
    begin
    if (right_key & (car_x_r < (MAX_X-1-CAR_VELOCITY)))
        begin
        car_x_l <= car_x_l + CAR_VELOCITY; // move right
        end
    else if (left_key & (car_x_l > CAR_VELOCITY))
        begin
        car_x_l <= car_x_l - CAR_VELOCITY; // move left 
        end
     end  
       
end

//the car bitmap
always @*
  case(car_rom_addr)
    4'h0: car_rom_data = 8'b00000000; // 0
    4'h1: car_rom_data = 8'b00000000; // 1
    4'h2: car_rom_data = 8'b00000000; // 2
    4'h3: car_rom_data = 8'b00011000; // 3
    4'h4: car_rom_data = 8'b00111100; // 4
    4'h5: car_rom_data = 8'b10111101; // 5
    4'h6: car_rom_data = 8'b11111111; // 6
    4'h7: car_rom_data = 8'b10111101; // 7
    4'h8: car_rom_data = 8'b00111100; // 8
    4'h9: car_rom_data = 8'b00111100; // 9
    4'ha: car_rom_data = 8'b00111100; // a
    4'hb: car_rom_data = 8'b11111111; // b
    4'hc: car_rom_data = 8'b11111111; // c
    4'hd: car_rom_data = 8'b11111111; // d
    4'he: car_rom_data = 8'b00111100; // e
    4'hf: car_rom_data = 8'b00011000; // f
endcase

endmodule
