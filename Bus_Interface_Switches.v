`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: David Jorge
// 
// Create Date: 05.03.2021 16:34:11
// Design Name: Microprocessor
// Module Name: Bus_Interface_Switches
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: This Bus Interface module  was added as an extra functionality
//              to connect the switches peripheral. Handles communications 
//              between the switches and bus lines (cpu).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Bus_Interface_Switches(
    //Clock Signal
    input CLK,
    //BUS Signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    //Switches
    input [15:0] Switches
    );
    
    // Top Address is 0xC3
    // Stores 2*8 bits of data
    parameter BaseAddr = 8'hC2;
    parameter AddrWidth = 1;
    
    //Tristate
    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg BusInterfaceWE;
        
    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (BusInterfaceWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;
        
    //Memory
    reg [7:0] Mem [(2**AddrWidth)-1:0];;
    
    always@(posedge CLK) begin
        // Store current Switches input data to bus interface memory
        Mem[0] <= Switches[7:0]; // Lower 8 Switches
        Mem[1] <= Switches[15:8]; // Upper 8 Switches
    
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
        
        // The 4 lower bits of the address will specify the offset to this memory
        Out <= Mem[BUS_ADDR[3:0]];
    end

endmodule
