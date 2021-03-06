`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.03.2021 10:27:12
// Design Name: 
// Module Name: TOP_stim
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


module TOP_stim(
    );
    
    // inputs
    reg CLK;
    reg RESET;
    reg [15:0] SWITCHES;
    
    // outputs
    wire [3:0] SEG_SELECT;
    wire [7:0] LED_OUT;
    wire [15:0] LIGHTS;
    /*
    wire [1:0] INTERRUPTS_RAISE;
    wire [1:0] INTERRUPTS_ACK;
    wire [7:0] RAM_D;
    wire [7:0] RAM_A;
    wire [7:0] BUS_D;
    wire [7:0] BUS_A;
    wire [7:0] CurrS;
    wire [7:0] NextS;
    wire [7:0] PC_Curr;
    wire [7:0] PC_Next;
    wire [7:0] PCoff_curr;
    wire [7:0] PCoff_next;
    wire [7:0] A_Curr;
    wire [7:0] B_Curr;
    wire [7:0] ALU_output;
    */
    
    // inout
    wire CLK_MOUSE;
    wire DATA_MOUSE;
    
    // Instatiate the uut
    TOP uut (
        .CLK(CLK),
        .RESET(RESET),
        .SEG_SELECT(SEG_SELECT),
        .LED_OUT(LED_OUT),
        .LIGHTS(LIGHTS),
        .SWITCHES(SWITCHES),
        /*
        .INTERRUPTS_RAISE(INTERRUPTS_RAISE),
        .INTERRUPTS_ACK(INTERRUPTS_ACK),
        .RAM_D(RAM_D),
        .RAM_A(RAM_A),
        .BUS_D(BUS_D),
        .BUS_A(BUS_A),
        .CurrS(CurrS),
        .NextS(NextS),
        .PC_Curr(PC_Curr),
        .PC_Next(PC_Next),
        .PCoff_curr(PCoff_curr),
        .PCoff_next(PCoff_next),
        .A_Curr(A_Curr),
        .B_Curr(B_Curr),
        .ALU_output(ALU_output),
        */
        
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE)
    );
    
    always begin
        #10 CLK = ~CLK;
    end
    
    /*
    initial begin
        $monitor("Time = %d \t SEG_SELECT = %b \t LED_OUT = %b \t LIGHTS = %b \t INTERRUPTS_RAISE = %b \t INTERRUPTS_ACK = %b \t RAM_D = %b \t RAM_A = %b \t BUS_D = %b \t BUS_A = %b \t CurrS = %b \t NextS = %b \t PC_Curr = %b \t PC_Next = %b \t PCoff_curr = %b \t PCoff_next = %b \t A_Curr = %b \t B_Curr = %b \t ALU_output = %b", $time, SEG_SELECT, LED_OUT, LIGHTS, INTERRUPTS_RAISE, INTERRUPTS_ACK, RAM_D, RAM_A, BUS_D, BUS_A, CurrS, NextS, PC_Curr, PC_Next, PCoff_curr, PCoff_next, A_Curr, B_Curr, ALU_output);
    end
    */
    initial begin
        $monitor("Time = %d \t SEG_SELECT = %b \t LED_OUT = %b \t LIGHTS = %b \t Switches = %b", $time, SEG_SELECT, LED_OUT, LIGHTS, SWITCHES);
    end
    
    initial begin
        // Initialize inputs
        CLK = 0;
        RESET = 0;
        SWITCHES = 0;
        
        $display("Begin");
        #100;
        RESET = 1;
        #100;
        RESET = 0;
        #1000000000;
        $display("End");
    end
        
    
endmodule
