`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2021 21:20:02
// Design Name: 
// Module Name: Bus_Interface_SevenSeg
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


module Bus_Interface_SevenSeg(
    //Standard signals
	input CLK,
	//BUS signals
	inout [7:0] BUS_DATA,
	input [7:0] BUS_ADDR,
	input BUS_WE, // This signal goes high when the CPU wants to write to the IO device
	//SevenSeg signals
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
        
    // Initialise the memory for data preloading, initialising variables, and declaring constants
    initial  $readmemh("C:/Users/DAVID/Microprocessor_Submission/Microprocessor_Submission.srcs/sources_1/new/SevenSeg.txt", Mem);
    
    always@(posedge CLK) begin
        // Get current mouse data
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
            
        Out <= Mem[BUS_ADDR[3:0]];
    end
    
endmodule
