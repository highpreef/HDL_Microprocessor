`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University of Edinburgh 
// Radu Bucurel
//  
// Module Name: VGA_Controller
// Project Name: VGA_Assignment_2
// Target Devices: Xilinx Basys 3
// Dependencies:  None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Module that is prepared to transmit the right data to the Frame_Buffer based on the 
// three dedicated ADDRESSES for the VGA (each signaling the x coordinate, y coordinate and pixel data). When 
// these addresses are seen on the line, it means that the data bus has the right data to be stored. 
//////////////////////////////////////////////////////////////////////////////////


module VGA_Controller(
    input CLK,              // 100MHz clock signal
    input RESET,            // RESET signal
    inout [7:0] BUS_DATA,  // The shared DATA bus 
    input [7:0] BUS_ADDR,  // The shared ADDRESS bus
    input BUS_WE,          // The shared WRITE enable line
    
    output           VGA_HS,    // Horizontal Sync Signal
    output           VGA_VS,    // Vertical Sync Signal
    output     [7:0] VGA_COLOUR  // VGA COLOUR
    );
    
    //Outputs or inputs to the VGA_Sig_Gen
    wire        PIXEL_CLK;                           // 25MHz Clock    
    wire [14:0] VGA_ADDR;                            // VGA address that contains the vertical and horizontal coordinates concatenated
    wire        B_DATA;                              // One bit pixel data sent from Frame_Buffer to VGA_Sig_Gen
    reg [15:0]  CONFIG_COLOURS = 16'hff00;           // VGA_Sig_Gen colour input to split in two colours
    
    wire        A_DATA_OUT;                          // Represents the buffered value of A_DATA_IN inside the Frame_Buffer
    reg         PIXEL_IN;                            // Store pixel value for background and square colours (0 or 1)

    reg         A_WE;                                // WRITE ENABLE signal for the Frame Buffer
    
    reg [14:0]  A_ADDR;                              // FrameBuffer address when writing
            
   //BUFFER STATES 
   reg        DATA_ENABLE;                             // Decides if information can be stored from the BUS_DATA or it should be high Z
   reg  [7:0] Out;                                     // Stores the Frame_Buffer pixel data output
   wire [7:0] LOCAL_DATA;                              // Stores the DATA from the DATA BUS (should have the x coords, y coords or pixel data when the address is right)
       
   // Tristate that decides when to use BUS_DATA or when to keep it high Z based on the processor reading/writing operations.
   assign BUS_DATA = (DATA_ENABLE) ? Out : 8'hZZ;   
   
   // Continual assignment of the contents of BUS_DATA into the wire LOCAL_DATA which will contain the x coordinates or y coordinates or the pixel data
   assign LOCAL_DATA = BUS_DATA;
   
   // Instantiation of the Frame_Buffer
   Frame_Buffer frame_buffer (.A_CLK(CLK),.B_CLK(PIXEL_CLK),.A_ADDR(A_ADDR),.B_ADDR(VGA_ADDR),.A_DATA_IN(PIXEL_IN),
                    .A_WE(A_WE),.A_DATA_OUT(A_DATA_OUT),.B_DATA(B_DATA));
   
   // Instantiation of the VGA_Sig_Gen
   VGA_Sig_Gen vga_sig_gen (.CLK(CLK), .RESET(RESET), .CONFIG_COLOURS(CONFIG_COLOURS), .VGA_DATA(B_DATA),
                    .DPR_CLK(PIXEL_CLK), .VGA_ADDR(VGA_ADDR), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS) ,.VGA_COLOUR(VGA_COLOUR));
                   
                   
   always@(posedge CLK) begin
       if((BUS_ADDR == 8'hB0) | (BUS_ADDR == 8'hB1) | (BUS_ADDR == 8'hB2) | (BUS_ADDR == 8'hB3) | (BUS_ADDR == 8'hB4))begin         // Check for the right ADDRESSES for the VGA_Controller
           if(BUS_WE)begin                                                              // If it is a write operation, it means the data will arrive in time to be stored
               case(BUS_ADDR)                                                           // Check what data to receive (x coord / y coord/ pixel data) based on the address
                   8'hB0 : A_ADDR[7:0] <=  LOCAL_DATA;           // X pixel address
                   8'hB1 : A_ADDR[14:8] <= LOCAL_DATA[6:0];      // Y pixel address
                   8'hB2 : begin                                 // Pixel Data Bit
                       PIXEL_IN <= LOCAL_DATA[0];                // DATA going to Frame_Buffer
                       A_WE <= 1;                                // Frame_Buffer Write gets enabled
                       end
                   8'hB3 : begin                                // Pointer colour change
                        CONFIG_COLOURS[7:0] <= LOCAL_DATA;
                        A_WE <= 1;
                   end
                   8'hB4 : begin                                // Background colour change
                        CONFIG_COLOURS[15:8] <= LOCAL_DATA;
                        A_WE <= 1;
                   end
               endcase
               DATA_ENABLE <= 0;                             // Disable line to allow collecting the data                     
           end else begin
               DATA_ENABLE <= 1;                             // For a READ operation DISABLE the line because data does not arrive in the same time with the address
               A_WE <= 0;                                    // Thus since the data timing is bad, disable the Frame_Buffer Write as well
           end
       end else begin
           DATA_ENABLE <= 0;                                 // If the address is not relevant for this module, disable the DATA line
           A_WE <= 0;                                        // Thus the Frame_Buffer Write can also be disabled
       end
       Out <= A_DATA_OUT;                                    // Constantly store the current pixel data from the Frame_Buffer 
   end
   
   initial begin
       A_WE           = 0;
       CONFIG_COLOURS = 16'hCC33;
       A_ADDR         = 0;
       PIXEL_IN      = 0;       
   end                                  
endmodule
