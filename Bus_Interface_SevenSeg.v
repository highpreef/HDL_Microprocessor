`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: David Jorge
// 
// Create Date: 23.02.2021 21:20:02
// Design Name: Microprocessor
// Module Name: Bus_Interface_SevenSeg
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: This is the Bus Interface module for the SevenSeg peripheral. Handles
//              communications between Seven Segment Display and bus lines (cpu).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Bus_Interface_SevenSeg(
    //Clock signal
	input CLK,
	//BUS Signals
	inout [7:0] BUS_DATA,
	input [7:0] BUS_ADDR,
	input BUS_WE,
	//SevenSeg
	output wire	[3:0] SEG_SELECT,
    output wire [7:0] LED_OUT
	);

	reg	[15:0] Seg7;
	
	Seg7Wrapper SevengSeg (
        .CLK(CLK),
        .DIGIT0(Seg7[11:8]),
        .DIGIT1(Seg7[15:12]),
        .DIGIT2(Seg7[3:0]),
        .DIGIT3(Seg7[7:4]),
        .LED_OUT(LED_OUT),
        .SEG_SELECT(SEG_SELECT)
    );
    
    // Top Address is 0xD1
    // Stores 2*8 bits of data
    parameter BaseAddr = 8'hD0;
    parameter AddrWidth = 1; 
    
    //Tristate
    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg BusInterfaceWE;
        
    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (BusInterfaceWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;
    
    //Memory
    reg [7:0] Mem [(2**AddrWidth)-1:0];
    
    always@(posedge CLK) begin
        // Get current SegSeven data from bus interface memory
        Seg7[7:0] <= Mem[0]; // Left 2 Seg7 Displays
        Seg7[15:8] <= Mem[1]; // Right 2 Seg7 Displays
    
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
