`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: David Jorge
// 
// Create Date: 23.02.2021 12:40:16
// Design Name: Microprocessor
// Module Name: RAM
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: This is the RAM module which has 128 bytes of memory for cpu use.
//              Handles communication with cpu through bus lines (separate from 
//              instruction memory)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RAM(
    //Clock signal
    input CLK,
    //BUS signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE
 );
 
    parameter RAMBaseAddr = 0;
    parameter RAMAddrWidth = 7; // 128 x 8-bits memory
    
    //Tristate
    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg RAMBusWE;
    
    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (RAMBusWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;
    
    //Memory
    reg [7:0] Mem [2**RAMAddrWidth-1:0];
    
    // Initialise the memory for data preloading, initialising variables, and declaring constants
    initial $readmemh("Complete_Demo_RAM.txt", Mem);
    
    //single port ram
    always@(posedge CLK) begin
        // find if this Device is being targeted
        if((BUS_ADDR >= RAMBaseAddr) & (BUS_ADDR < RAMBaseAddr + 128)) begin
            if(BUS_WE) begin
                Mem[BUS_ADDR[6:0]] <= BufferedBusData;
                RAMBusWE <= 1'b0;
            end else
                RAMBusWE <= 1'b1;
        end else
            RAMBusWE <= 1'b0;
            
        Out <= Mem[BUS_ADDR[6:0]];
    end
endmodule
