`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2021 15:01:57
// Design Name: 
// Module Name: Bus_Interface_LEDs
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


module Bus_Interface_LEDs(
    //Standard Signals
    input CLK,
    //BUS signals
    inout [7:0] BUS_DATA,
    inout [7:0] BUS_ADDR,
    input BUS_WE, // This signal goes high when the CPU wants to write to the IO device
    // LEDs
    output reg [15:0] LEDs
    );
    
    parameter BaseAddr = 8'hC0;
    parameter AddrWidth = 1; // 2 x 8 bits memory
    
    //Tristate
    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg BusInterfaceWE;
        
    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (BusInterfaceWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;
        
    //Memory
    reg [7:0] Mem [(2**AddrWidth)-1:0];;
        
    initial  $readmemh("C:/Users/DAVID/Microprocessor_Submission/Microprocessor_Submission.srcs/sources_1/new/LEDs.txt", Mem);
    
    always@(posedge CLK) begin
        // Get current LEDs data
        LEDs[15:8] <= Mem[0]; // Upper 8 LEDs
        LEDs[7:0] <= Mem[1]; // Lower 8 LEDs
    
        // find if this Device is being targeted
        if((BUS_ADDR >= BaseAddr) & (BUS_ADDR < BaseAddr + 2**AddrWidth)) begin
            if(BUS_WE) begin
                // The 4 lower bits of the address will specify the offset to this memory
                Mem[BUS_ADDR[3:0]] <= BufferedBusData;
                BusInterfaceWE <= 1'b0;
            end else
                BusInterfaceWE <= 1'b1;
        end else
            BusInterfaceWE <= 1'b0;
            
        Out <= Mem[BUS_ADDR[3:0]];
    end
    
endmodule
