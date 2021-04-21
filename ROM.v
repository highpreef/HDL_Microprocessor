`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: David Jorge
// 
// Create Date: 23.02.2021 13:46:48
// Design Name: Microprocessor
// Module Name: ROM
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: This is the ROM module which has 256 bytes of instruction memory 
//              which are passed to the cpu through the RAM data and addr lines.
//              (Direct connection)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ROM(
    //Clock signal
    input CLK,
    //BUS Signals
    output reg [7:0] DATA,
    input [7:0] ADDR
    );
 
    parameter RAMAddrWidth = 8; // 256 bytes of instruction memory
    
    //Memory
    reg [7:0] ROM [2**RAMAddrWidth-1:0];
    
    // Load program
    initial $readmemh("Complete_Demo_ROM.txt", ROM);
    
    //single port ram
    always@(posedge CLK)
        DATA <= ROM[ADDR];
    
endmodule
