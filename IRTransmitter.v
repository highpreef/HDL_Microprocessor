`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/11 11:36:52
// Design Name: 
// Module Name: IRTrasmitter
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


module IRTransmitter(
    input RESET,    
    input CLK,//100MHz
    input [7:0] BUS_DATA,// [3:0] represent right,left,backward,forward
    input [7:0] BUS_ADDR,
    output IR_LED //IR LED signal
);

    // when BUS_ADDR==IRBaseAddr, BUS_DATA will be written into Command
    parameter IRBaseAddr=8'h90;

    wire SEND_PACKET; //10Hz 
    wire [3:0] COMMAND;//direction, [3:0]right,left,backward,forward
    reg [3:0] COMMAND_REG;// hold direction
    
    
    //change direction according to BUS_DATA
    always@(posedge CLK) begin
        if(RESET)//stop when RESET
            COMMAND_REG<=4'b0000;
        else begin
            if(BUS_ADDR==IRBaseAddr)//set BUS_DATA[3:0] as address, when Addr matched
                COMMAND_REG<=BUS_DATA[3:0];
        end
    end
             
    assign COMMAND=COMMAND_REG;
    
    //10Hz counter
    TenHz_cnt SP(
    .CLK(CLK),
    .RESET(RESET),
    .SEND_PACKET(SEND_PACKET)
    );    
    
    //IR state machine
    IRTransmitterSM IRSM(
    .RESET(RESET),
    .CLK(CLK),
    .COMMAND(COMMAND),
    .SEND_PACKET(SEND_PACKET),
    .IR_LED(IR_LED)
    );       

endmodule
