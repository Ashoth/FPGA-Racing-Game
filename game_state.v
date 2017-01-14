`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 10/27/2016 05:57:13 PM
// Design Name: 
// Module Name: game_state
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


module game_state(
input wire clk, reset, 
input wire video_on, road_on,finish_line, car_on, 
input wire enter_key,key_relese, 
output reg start_en,crash_en, finish_en,
                pause, game_reset);

reg [2:0] state = 3'd0;

always@(posedge clk)
begin
if(reset)
state<=3'b0;
case(state)
//show start page and reset the game,
3'd0: if(enter_key) //when enter is pressed move to playing state
            begin state <= 3'd1; start_en <=1'b0;   
            pause <=1'b0; game_reset <=1'b0; end      
      else //shaow start page, reset the game, wait for enter key
            begin start_en <=1'b1; crash_en <= 1'b0;
            finish_en <=1'b0; pause <= 1'b1; 
            game_reset <= 1'b1; end
            
//race until either the car get's off the road or car reaches finish line
3'd1: if(video_on && car_on && !road_on)
        //if off the road, pause the game.
        begin
        //show crash message
        crash_en <= 1'b1;
        //if enter key is held while crash, 
        //pause and wait for the key to be released
        if(enter_key) 
            state<= 3'd1;
        else
            state <=3'd2;
        pause <=1'b1;
        end
    else if(video_on & car_on & finish_line) //playing
        begin
        //show finish message
        finish_en<=1'b1;
        //if enter key is held while car crosses finish line, 
        //pause and wait for the key to be released
        if(enter_key)
        state<= 3'd1;
        else
        state <=3'd2;
        pause <=1'b1;
        end
//wait for the user to press enter before moving to start page
3'd2:  if(enter_key) begin  state<= 3'd3; end 
//wait for enter to be realesed
3'd3: if(key_relese) state<= 3'd0; 
default: state <= 3'd0;
endcase
end





endmodule
