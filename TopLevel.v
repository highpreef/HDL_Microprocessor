`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: David Jorge
// 
// Create Date: 10.03.2021 18:19:28
// Design Name: Microprocessor
// Module Name: TopLevel
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: Wrapper module for the microprocessor and peripherals. Ties all
//              inputs and outputs together.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TopLevel(
    //Clock and Reset
    input CLK,
    input RESET,
    //SevenSegment
    output [3:0] SEG_SELECT,
    output [7:0] LED_OUT,
    //LEDs
    output [15:0] LIGHTS,
    //Switches
    input [15:0] SWITCHES,
    //Mouse
    inout CLK_MOUSE,
    inout DATA_MOUSE,
    //IR Transmitter
    output IR_LED,
    //VGA
    output [7:0] VGA_COLOUR,
    output VGA_HS,
    output VGA_VS
    
    // Testbench (NOT USED IN IMPLEMENTATION)
    /*
    output [1:0] INTERRUPTS_RAISE,
    output [1:0] INTERRUPTS_ACK,
    output [7:0] RAM_data,
    output [7:0] RAM_add,
    output [7:0] BUS_data,
    output [7:0] BUS_add,
    output [7:0] Current_S,
    output [7:0] Next_S,
    output [7:0] PC_Curr,
    output [7:0] PC_Next,
    output [7:0] PC_offset_curr,
    output [7:0] A_Curr,
    output [7:0] B_Curr,
    output [7:0] ALU_output
    */
    );
    
    // Instruction and data bus init
    wire [7:0] ROM_ADDRESS;
    wire [7:0] ROM_DATA;
    wire [7:0] BUS_DATA;
    wire [7:0] BUS_ADDR;
    wire BUS_WE; // indicates processor is writing to peripheral
       
    // Interrupt raise and ack lines init
    wire [1:0] BUS_INTERRUPTS_RAISE;
    wire [1:0] BUS_INTERRUPTS_ACK;
    
    // Instantiate the processor module
    Processor CPU (
        //Standard Signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        // ROM signals
        .ROM_ADDRESS(ROM_ADDRESS),
        .ROM_DATA(ROM_DATA),
        // INTERRUPT signals
        .BUS_INTERRUPTS_RAISE(BUS_INTERRUPTS_RAISE),
        .BUS_INTERRUPTS_ACK(BUS_INTERRUPTS_ACK)
        
        //Testbench
        /*
        .Current_State(Current_S),
        .Next_State(Next_S),
        .Current_PC(PC_Curr),
        .Next_PC(PC_Next),
        .Current_PC_offset(PC_offset_curr),
        .Current_Register_A(A_Curr),
        .Current_Register_B(B_Curr),
        .ALU_OUT(ALU_output)
        */
    );
    
    // Instantiate the ROM module
    ROM Rom (
        //Clock signal
        .CLK(CLK),
        //BUS Signals
        .DATA(ROM_DATA),
        .ADDR(ROM_ADDRESS)
    );
    
    // Instantiate the RAM module
    RAM Mem (
        //Clock signal
        .CLK(CLK),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE)
    );
    
    // Instantiate the SevenSeg Bus Interface module
    Bus_Interface_SevenSeg Seg7 (
        //Clock signal
        .CLK(CLK),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        //SevenSeg I/O
        .SEG_SELECT(SEG_SELECT),
        .LED_OUT(LED_OUT)
    );
    
    // Instantiate the LEDs Bus Interface module
    Bus_Interface_LEDs LEDs (
        //Clock signal
        .CLK(CLK),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        //LEDs I/O
        .LEDs(LIGHTS)
    );
    
    // Extra functionality - Instantiate the Switches Bus Interface module
    Bus_Interface_Switches Switches (
        //Clock signal
        .CLK(CLK),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        //Switches
        .Switches(SWITCHES)
    );
    
    // Instantiate the Timer module
    Timer timer_100ms (
        //Clock and Rest signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        //Interrupts
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPTS_RAISE[1]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPTS_ACK[1])
    );
    
    // Instantiate the Mouse Bus Interface module
    Bus_Interface_Mouse Mouse (
        //Clock and Reset signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS Signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        //Mouse ports
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        //Interrupts
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPTS_RAISE[0]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPTS_ACK[0])
    );
    
    // Instantiate the IR transmitter Bus Interface module
    IRTransmitter IR0 (
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .IR_LED(IR_LED)
    );  
    
    // Instantiate the VGA Bus Interface module
    VGA_Controller VGA (
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS),
        .VGA_COLOUR(VGA_COLOUR)
    );
    
    // Testbench interrupt assignment (NOT USED IN IMPLEMENTATION)
    /*
    assign INTERRUPTS_RAISE = BUS_INTERRUPTS_RAISE;
    assign INTERRUPTS_ACK = BUS_INTERRUPTS_ACK;
    */
    
endmodule

