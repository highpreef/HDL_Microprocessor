`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.02.2021 21:28:55
// Design Name: Microprocessor
// Module Name: TOP
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: Wrapper for the microprocessor.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TOP(
    //Standard Signals
    input CLK,
    input RESET,
    //SevenSeg
    output [3:0] SEG_SELECT,
    output [7:0] LED_OUT,
    //LEDs
    output [15:0] LIGHTS,
    //Switches
    input [15:0] SWITCHES,
    //Mouse
    inout CLK_MOUSE,
    inout DATA_MOUSE
    
    // Testbench
    /*
    output [1:0] INTERRUPTS_RAISE,
    output [1:0] INTERRUPTS_ACK,
    output [7:0] RAM_D,
    output [7:0] RAM_A,
    output [7:0] BUS_D,
    output [7:0] BUS_A,
    output [7:0] CurrS,
    output [7:0] NextS,
    output [7:0] PC_Curr,
    output [7:0] PC_Next,
    output [7:0] PCoff_curr,
    output [7:0] PCoff_next,
    output [7:0] A_Curr,
    output [7:0] B_Curr,
    output [7:0] ALU_output
    */
    );
    
    // IO bus init
    wire [7:0] BUS_DATA;
    wire [7:0] BUS_ADDR;
    wire BUS_WE;
    
    // Instruction bus init
    wire [7:0] ROM_ADDRESS;
    wire [7:0] ROM_DATA;
    
    // Interrupt init
    wire [1:0] BUS_INTERRUPTS_RAISE;
    wire [1:0] BUS_INTERRUPTS_ACK;
    
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
        .C_State(CurrS),
        .N_State(NextS),
        .Curr_PC(PC_Curr),
        .Next_PC(PC_Next),
        .Curr_PCoff(PCoff_curr),
        .Next_PCoff(PCoff_next),
        .Curr_A(A_Curr),
        .Curr_B(B_Curr),
        .ALU_OUT(ALU_output)
        */
    );
    
    RAM Mem (
        //Standard Signals
        .CLK(CLK),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE)
    );
    
    ROM Rom (
        //Standard Signals
        .CLK(CLK),
        //BUS Signals
        .DATA(ROM_DATA),
        .ADDR(ROM_ADDRESS)
    );
    
    Bus_Interface_SevenSeg Seg7 (
        //standard signals
        .CLK(CLK),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE), // This signal goes high when the CPU wants to write to the IO device
        //SevenSeg signals
        .SEG_SELECT(SEG_SELECT),
        .LED_OUT(LED_OUT)
    );
    
    Bus_Interface_LEDs LEDs (
        //standard signals
        .CLK(CLK),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE), // This signal goes high when the CPU wants to write to the IO device
        // LED signals
        .LEDs(LIGHTS)
    );
    
    Bus_Interface_Switches Switches (
        //standard signals
        .CLK(CLK),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE), // This signal goes high when the CPU wants to write to the IO device
        // Switch signals
        .Switches(SWITCHES)
    );
    
    Timer timer_100ms (
        //standard signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPTS_RAISE[1]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPTS_ACK[1])
    );
    
    Bus_Interface_Mouse Mouse (
        //standard signals
        .CLK(CLK),
        .RESET(RESET),
        //BUS signals
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),            // This signal goes high when the CPU wants to write to the IO device
        // PS2 serial connections
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        // interrupt signals
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPTS_RAISE[0]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPTS_ACK[0])
    );
    
    // Testbench interrupt assignment
    /*
    assign INTERRUPTS_RAISE = BUS_INTERRUPTS_RAISE;
    assign INTERRUPTS_ACK = BUS_INTERRUPTS_ACK;
    */
    
endmodule
