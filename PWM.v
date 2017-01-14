`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashot Hambardzumyan
// 
// Create Date: 11/17/2016 09:44:52 PM
// Design Name: 
// Module Name: PWM
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


module PWM(
input clk,
input [7:0] duty,
output reg pwm);

reg [7:0] counter=0;

//simple pwm at 100MHZ/256, with variable duty
always@(posedge clk)
begin
counter <= counter +1;
if(counter<duty)
pwm <= 1;
else
pwm <= 0;
end



endmodule
