`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University of Edinburgh 
// Radu Bucurel
//  
// Module Name: VGA_Sig_Gen
// Project Name: VGA_INTERFACE
// Target Devices: Xilinx Basys 3
// Dependencies: Generic_counter
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This module is responsible for syncronizing the pixel data for the VGA interface
//                      and it outputs the colour, the horizontal sync and the vertical sync to be sent 
//                      to the VGA pins. This module receives 1 information bit from the Frame_Buffer.
//////////////////////////////////////////////////////////////////////////////////


module VGA_Sig_Gen(
    input         CLK,                           // 100 MHz clock                               
    input         RESET,                         // RESET input that is supposed to make all the modules start again
    input [15:0]  CONFIG_COLOURS,                // Colour configuration interface 8MSB pixel colour and 8LSB background colour
    
    input         VGA_DATA,                      // 1 bit information from Frame_Buffer to help decide how to colour each pixel  
    output        DPR_CLK,                       // 25 MHz clock to be sent to other modules
    output [14:0] VGA_ADDR,                      // 7MSB ADDRY and 8 LSB ADDRX to be sent to the Frame Buffer
    
    output reg [7:0]  VGA_COLOUR,                // VGA Port interface Colour (which will be limited to 8 bits instead of 12, thus losing 1 RED, 1 GREEN and 2 BLUE bits)
    output reg    VGA_HS,                        // VGA Port interface Horizontal Sync
    output reg    VGA_VS                         // VGA Port interface Vertical Sync
    );
    
    wire PIXEL_TRIGGER;                          // Represents a trigger every 25MHz (100MHz slowed 4 times) that will be the pixel CLOCK
    Generic_Counter # (.COUNTER_WIDTH(2), .COUNTER_MAX(3))
        Pixel_Clock(.CLK(CLK), .RESET(RESET), .ENABLE(1'b1), .TRIG_OUT(PIXEL_TRIGGER));
    // because of how the generic counter works (using assign), TRIG_OUT has to be assigned to a WIRE not a REG.
    
    
    parameter HTs      = 800; // Total Horizontal Sync Pulse Time
    parameter HTpw     = 96;  // Horizontal Pulse Width Time
    parameter HTDisp   = 640; // Horizontal Display Time
    parameter Hbp      = 48;  // Horizontal Back Porch Time
    parameter Hfp      = 16;  // Horizontal Front Porch Time
    
    parameter VTs      = 521; // Total Vertical Sync Pulse Time
    parameter VTpw     = 2;   // Vertical Pulse Width Time
    parameter VDisp    = 480; // Vertical Display Time
    parameter Vbp      = 29;  // Vertical Back Porch Time
    parameter Vfp      = 10;  // Vertical Front Porch Time
    
    // Define horizontal and vertical counters to generate VGA signals
    reg [9:0] H_Counter;
    reg [9:0] V_Counter;
    
    /* Because I use the generic counter to calculate the horizontal and vertical counters, I need to have wires whose values
    could then be assigned to registers because .TRIG_OUT works based on continual assignment and thus it needs to be tied to a wire*/
    wire [9:0] H_C;
    wire [9:0] V_C;
    wire Vertical_trig;        // This is needed to allow the vertical counting to be enabled only at the end of a line (horizontal)
    
    // Notice that PIXEL_TRIGGER is used to enable this count only at positive edges of the 25MHz clock and not the 100MHz clock
    // H_C is the wire that shows where the horizontal counter is located
    Generic_Counter # (.COUNTER_WIDTH(10), .COUNTER_MAX(799))   // Counts between 0 and 799 included (thus 800* 25MHz PIXEL clocks in total)
        Horizontal_Counter(.CLK(CLK), .RESET(RESET), .ENABLE(PIXEL_TRIGGER), .TRIG_OUT(Vertical_trig), .COUNT(H_C));
    

    // V_C is the wire that shows where the vertical counter is located    
    Generic_Counter # (.COUNTER_WIDTH(10), .COUNTER_MAX(520))                            // Count between 0 and 521 lines (the vertical counter)
        Vertical_Counter(.CLK(CLK), .RESET(RESET), .ENABLE(Vertical_trig), .COUNT(V_C));  // This time it only counts after one line has been completed
 
    
    // Always check if the horizontal position passed the Pulse Width zone. If that is the case, the horizontal sync becomes 1
    always@(posedge CLK) begin
        if(H_C < HTpw)                              // Normally it would be <= but the counter starts from 0 
            VGA_HS <= 0;
        else
            VGA_HS <= 1;
    end
 
    
    // Similar to the horizontal sync, but changing the Pulse Width zone to a different value for vertical. 
    always@(posedge CLK) begin
        if(V_C < VTpw)
            VGA_VS <= 0;
        else
            VGA_VS <= 1;
    end
    
 
    assign DPR_CLK = PIXEL_TRIGGER;                             // Check that this clock is 50% duty cycle and not 25% ON 75% off as I suspect
    assign VGA_ADDR = {V_Counter[8:2],H_Counter[9:2]};          // 7MSB are the vertical address while 8LSB represent the horizontal address
 
 
    /* Assigning values to the pixel coordinates that will be passed to the monitor by getting rid of the offset values due to other timings,
    but also assigning the VGA_COLOUR based on the VGA_DATA received from the Frame_Buffer */
    always@(posedge CLK) begin
        if( H_C >= (HTpw + Hbp) &&              // This is >= because the counter starts from 0 and not from 1 and thus the measurements                                       
            H_C <= (HTs - Hfp)  &&              // from Figure 14 in the Basys3 Board Manual are offset by 1
            V_C >= (VTpw + Vbp) &&
            V_C <= (VTs - Vfp)    )begin
            
                H_Counter <= H_C - (HTpw + Hbp);    // Values between 0 and 639 stored in the H_Counter register representing the horizontal pixel coodrinate
                V_Counter <= V_C - (VTpw + Vbp);   // Values between 0 and 479 stored in the V_Counter register representing the vertical pixel coordinate

                if(VGA_DATA) begin 
                    VGA_COLOUR <= CONFIG_COLOURS[7:0];     // Pixel colour
                end
                else begin
                    VGA_COLOUR <= CONFIG_COLOURS[15:8];    // Background 
                end
        end
        else begin
            H_Counter <= 0;
            V_Counter <= 0;
            VGA_COLOUR <= 8'h00;                        // Set the colour to black (8 bits 0)
        end
    end
    
    // Regs must be initialised for the simulation to work properly, although their values will change.
    initial begin
    H_Counter = 0;
    V_Counter = 0;
    end

endmodule



// Separate module - GENERIC_COUNTER

module Generic_Counter(
    CLK,                    // 100MHz clock
    RESET,                  // RESET to allow the counter to start from the initial values 
    ENABLE,                 // ENABLE the counter to operate
    TRIG_OUT,               // Trigger that shows when a counter reached the maximum value before resetting 
    COUNT                   // The location of the counter
    );
    
    // These parameters can be changed when instantiating the function elsewhere.
    parameter COUNTER_WIDTH = 4;
    parameter COUNTER_MAX   = 9;
    
    input CLK;              
    input RESET;
    input ENABLE;
    output TRIG_OUT;
    output [COUNTER_WIDTH-1:0] COUNT;
    
    reg [COUNTER_WIDTH-1 : 0] count_value;
    reg Trigger_out;
    
    always@(posedge CLK)begin
        if(RESET)
            count_value <=0;
        else begin
            if(ENABLE) begin                                    // Check if the previous counter had an overflow
                if(count_value == COUNTER_MAX)                  // If current counter has an overflow reset it to 0
                    count_value <= 0;                           // The same could be done by going up to COUNTER_MAX+1 and starting from 1
                else
                    count_value <= count_value+1;               // If it doesn't overflow, increase it by 1
            end
        end
    end
    
    always@(posedge CLK)begin
        if(RESET)
            Trigger_out <= 0; 
        else begin
            if(ENABLE && (count_value == COUNTER_MAX))          // If enabled and at the maximum value, send a pulse 
                Trigger_out <=1;                            
            else 
                Trigger_out <= 0;                           
        end
    end
    
    assign COUNT =    count_value;
    assign TRIG_OUT = Trigger_out;
    
    // Setting up the values for the simulation. All registers must be initialised for it to work properly.
    initial begin
    Trigger_out = 0;
    count_value = 0;
    end
    
endmodule