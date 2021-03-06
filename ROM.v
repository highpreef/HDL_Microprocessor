`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2021 13:46:48
// Design Name: 
// Module Name: ROM
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


module ROM(
    //standard signals
    input CLK,
    //BUS signals
    output reg [7:0] DATA,
    input [7:0] ADDR
    );
 
    parameter RAMAddrWidth = 8;
    
    //Memory
    reg [7:0] ROM [2**RAMAddrWidth-1:0];
    
    // Load program
    //initial $readmemh("Mouse_Demo.txt", ROM);
    initial $readmemh("C:/Users/DAVID/Microprocessor_Submission/Microprocessor_Submission.srcs/sources_1/new/Mouse_Demo.txt", ROM);
    //single port ram
    always@(posedge CLK)
        DATA <= ROM[ADDR];
    
endmodule
