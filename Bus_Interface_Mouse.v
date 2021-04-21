`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: David Jorge
// 
// Create Date: 23.02.2021 17:14:48
// Design Name: Microprocessor
// Module Name: Bus_Interface_Mouse
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: This is the Bus Interface module for the mouse peripheral. Handles
//              communications between mouse and bus lines (cpu).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Bus_Interface_Mouse(
    //Clock and Reset signals
    input CLK,
    input RESET,
    //BUS Signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    //Mouse
    inout CLK_MOUSE,
    inout DATA_MOUSE,
    //Interrupt & Acknowledge
    output BUS_INTERRUPT_RAISE,
    input BUS_INTERRUPT_ACK
	);
    
    // Mouse Outputs
	wire [7:0] MouseStatusFull;
	wire [7:0] MouseX;
	wire [7:0] MouseDx;
	wire [7:0] MouseY;
	wire [7:0] MouseDy;
	wire [7:0] MouseScroll;

    // Mouse Interrupt signal
	wire SendInterrupt;

	MouseTransceiver T (
		//Clock and Reset Inputs
		.CLK(CLK),
		.RESET(RESET),
		//Mouse bidirectional ports
		.CLK_MOUSE(CLK_MOUSE),
		.DATA_MOUSE(DATA_MOUSE),
		// Mouse outputs
		.MouseStatusFull(MouseStatusFull),	
		.MouseX(MouseX),
		.MOUSE_DX(MouseDx),
		.MouseY(MouseY),
		.MOUSE_DY(MouseDy),
		.MouseScroll(MouseScroll),
		// Interrupt
		.SendInterrupt(SendInterrupt)
	);

	// Raise interrupt signal; goes high when interrupt is raised from mouse
	reg Raise_Interrupt;
	
	// Check whether mouse sends interrupt and raise it to cpu. Reset interrupt signal 
	// when interrupt is acknowledged by cpu.
	always@(posedge CLK) begin
        if(RESET)
            Raise_Interrupt <= 1'b0;
        else if(SendInterrupt)
            Raise_Interrupt <= 1'b1;
        else if(BUS_INTERRUPT_ACK)
            Raise_Interrupt <= 1'b0;
    end
    
    // Interrupt assignment
	assign BUS_INTERRUPT_RAISE = Raise_Interrupt; 

    // Top address changed to A7
    // Stores 8*8 bits of data
	parameter BaseAddr = 8'hA0;
	parameter AddrWidth = 3; 
	
	//Tristate
	wire [7:0] BufferedBusData;
	reg [7:0] Out;
	reg BusInterfaceWE;
	
	// Data is only passed onto the bus if the cpu is not currently writing and is addressing this interface
	assign BUS_DATA = (BusInterfaceWE) ? Out : 8'hZZ;
	assign BufferedBusData = BUS_DATA;
	
	// Interface Mem
	reg [7:0] Mem [(2**AddrWidth)-1:0];
    
    // Sequential logic
    always@(posedge CLK) begin
        // Get current mouse data
        Mem[0] <= MouseStatusFull;
        Mem[1] <= MouseX;
        Mem[2] <= MouseY;
        Mem[3] <= MouseScroll;
        Mem[4] <= MouseDx;
        Mem[5] <= MouseDy;
    
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
