`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/05 20:30:42
// Design Name: 
// Module Name: TenHz_cnt
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


module TenHz_cnt(
    input CLK,//100MHz
    input RESET,
    // Output
    output SEND_PACKET//10Hz
);
// output SEND_PACKET 10Hz, turn 1 for one CLK cycle in one period.


    parameter COUNTER_WIDTH =32;
    parameter COUNTER_MAX=10000000-1;


    reg [COUNTER_WIDTH-1:0] counter_value=0;
    reg send_packet=0;    
    
    // counter increases from 0 to COUNTER_MAX every CLK
    always@(posedge CLK) begin
        if(RESET==1)
            counter_value <=0;
        else begin
            if(counter_value==COUNTER_MAX) 
                counter_value<=0;    
            else 
                counter_value<=counter_value+1;
        end
    end    
    
    // send_packet turns 1 when counter reach COUNTER_MAX, 0 otherwise
    always@(posedge CLK) begin
        if(RESET)
            send_packet <=0;
        else begin
            if(counter_value==COUNTER_MAX) 
                send_packet<= 1;    
            else 
                send_packet<= 0;
        end
    end   
    
    assign SEND_PACKET=send_packet;
    
endmodule
