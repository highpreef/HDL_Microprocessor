`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/02/05 20:32:28
// Design Name: 
// Module Name: IRTransmitterSM
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


module IRTransmitterSM(
    input RESET,
    input CLK,//100MHz
    input [3:0] COMMAND,
    input SEND_PACKET,//10Hz
    output IR_LED
    );   
    
    //number of pulses for blue green cars(my car is yellow, but it receives signal for green car)
    parameter StartBurstSize=88;
    parameter CarSelectBurstSize=22;
    parameter GapSize=40;
    parameter AsserBurstSize=44;
    parameter DeAssertBurstSize=22;   
    //37.5KHz counter from CLK 100MHz, half time 1, half time 0
    parameter COUNTER_WIDTH=12; 
    parameter COUNTER_MAX=2667-1; 

    reg [COUNTER_WIDTH-1:0] counter_value=0;
    reg CLK_pulse=0;

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

    // output 1 the first half cycle,0 the other half cycle.
    always@(posedge CLK) begin
        if(RESET)
            CLK_pulse <=0;
        else begin
        if(counter_value<=COUNTER_MAX/2-1) 
            CLK_pulse <= 1;    
        else 
            CLK_pulse <= 0;
        end
    end     


    //state machine for direction, change direction according to COMMAND 10Hz
    reg [3:0] curr_state=0;//direction state
    reg [3:0] curr_outputs=0;//direction output
    reg [3:0] next_state=0;
    reg [3:0] next_outputs=0;
    
    //output represent direction,0-3bits: right,left,backward,forward.
    always@(COMMAND) begin
        case(COMMAND)
            4'b0000: begin 
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
            
            4'b0001: begin
                next_state<=4'd1;
                next_outputs<=4'b0001;
            end
            
            4'b0010: begin 
                next_state<=4'd7;
                next_outputs<=4'b0010;
            end
            
            4'b0011: begin
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
            
            4'b0100: begin
                next_state<=4'd3;
                next_outputs<=4'b0100;
            end
            
            4'b0101: begin
                next_state<=4'd0;
                next_outputs<=4'b0101;
            end
                
            4'b0110: begin
                next_state<=4'd6;
                next_outputs<=4'b0110;
            end
            
            4'b0111: begin
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
            
            4'b1000: begin
                next_state<=4'd5;
                next_outputs<=4'b1000;
            end
                
            4'b1001: begin
                next_state<=4'd2;
                next_outputs<=4'b1001;
            end
            
            4'b1010: begin
                next_state<=4'd8;
                next_outputs<=4'b1010;
            end
            
            4'b1011: begin
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
            
            4'b1100: begin 
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
            
            4'b1101: begin
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
            
            4'b1110: begin
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
            
            4'b1111: begin
                next_state<=4'd4;
                next_outputs<=4'b0000;
            end
        endcase       
    end                   
    
    //change direction 10Hz
    always@(posedge SEND_PACKET)begin   
        if(RESET) begin
            curr_state <= 4'd4;
            curr_outputs <= 4'd4;
        end
                
        else begin
            curr_state <= next_state;
            curr_outputs <= next_outputs;
        end    
    end     
    
    //generate IR_LED
    reg [3:0]region_state=4'd12;//region in the packet,0 start,2 select,4 right,6 left, 8 backward,10 forward, 1 3 5 7 9 11 gap, 12 stop pulse.
    reg [6:0]pul_counter=0;//counter of the pulse number
    reg [6:0]pul_counter_max=7'b1111111;    
    reg packet_start=0;// start send the packet, turn 1 when SEND_PACKET==1
    
    
    //change pulse counter_max every CLK cycle, according to regions(start,gap,carselect......) in the packet.
    always@(posedge CLK) begin
        case (region_state)
            4'd0:pul_counter_max<=StartBurstSize-1;
            4'd1:pul_counter_max<=GapSize-1;
            4'd2:pul_counter_max<=CarSelectBurstSize-1;
            4'd3:pul_counter_max<=GapSize-1;
            4'd4:pul_counter_max<=curr_outputs[3]?AsserBurstSize-1:DeAssertBurstSize-1;
            4'd5:pul_counter_max<=GapSize-1;
            4'd6:pul_counter_max<=curr_outputs[2]?AsserBurstSize-1:DeAssertBurstSize-1;
            4'd7:pul_counter_max<=GapSize-1;
            4'd8:pul_counter_max<=curr_outputs[1]?AsserBurstSize-1:DeAssertBurstSize-1;
            4'd9:pul_counter_max<=GapSize-1;
            4'd10:pul_counter_max<=curr_outputs[0]?AsserBurstSize-1:DeAssertBurstSize-1;
            4'd11:pul_counter_max<=GapSize-1;
            4'd12:pul_counter_max<=7'b1111111;
        endcase            
    end    
    

    //start packet when SEND_PACKET turns 1 (reset region to start from stop)
    always@(posedge CLK)begin       
        if(SEND_PACKET)
            packet_start<=1;               
        
        if(region_state==0)//after region jump back from stop to start,stop Reset region
            packet_start<=0;                    
    end
    
    
    //update the region in the packet
    always@(posedge CLK_pulse) begin
        if(RESET||packet_start)begin// back to start region, when PACKET starts or RESET.
            region_state<=0;
            pul_counter<=0;
        end
        else begin                          
            if(region_state!=4'd12)begin//update pulse counter when not in stop region           
                if(pul_counter==pul_counter_max) begin//upload region state, when counter reach maximum              
                    pul_counter<=0;                
                    region_state<=region_state+1;
                end                
                else
                    pul_counter<=pul_counter+1;
            end           
        end           
    end
    
    
    
    //update output IR_LED
    reg out=0;
    
    //when not in gap or stop region, and CLK_pulse==1,
    // output 1, 0 otherwise.
    always@(posedge CLK) begin
        if((region_state!=4'd12)&(~region_state[0])&CLK_pulse)
            out<=1;
        else
            out<=0;
    end
                
    assign IR_LED=out;

endmodule
