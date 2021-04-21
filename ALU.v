`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: David Jorge
// 
// Create Date: 23.02.2021 13:53:36
// Design Name: Microprocessor
// Module Name: ALU
// Project Name: Microprocessor
// Target Devices: Basys 3
// Tool Versions: 
// Description: This is the module for the Arithmetic Logic Unit (ALU). Offers
//              basic and complex arithmetic and logic operations on the 2 inputs
//              and outputs the result. The ALU_Op_Code signal determinest the
//              operation to be executed.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Added additional logic operations: AND, NAND, OR and XOR
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    //standard signals
    input CLK,
    input RESET,
    //I/O
    input [7:0] IN_A,
    input [7:0] IN_B,
    input [3:0] ALU_Op_Code,
    output [7:0] OUT_RESULT
    );
    
    reg [7:0] Out;
    //Arithmetic Computation
    always@(posedge CLK) begin
        if(RESET)
            Out <= 0;
        else begin
            case (ALU_Op_Code)
                //Maths Operations
                //Add A + B
                4'h0: Out <= IN_A + IN_B;
                //Subtract A - B
                4'h1: Out <= IN_A - IN_B;
                //Multiply A * B
                4'h2: Out <= IN_A * IN_B;
                //Shift Left A << 1
                4'h3: Out <= IN_A << 1;
                //Shift Right A >> 1
                4'h4: Out <= IN_A >> 1;
                //Increment A+1
                4'h5: Out <= IN_A + 1'b1;
                //Increment B+1
                4'h6: Out <= IN_B + 1'b1;
                //Decrement A-1
                4'h7: Out <= IN_A - 1'b1;
                //Decrement B+1
                4'h8: Out <= IN_B - 1'b1;
                // In/Equality Operations
                //A == B
                4'h9: Out <= (IN_A == IN_B) ? 8'h01 : 8'h00;
                //A > B
                4'hA: Out <= (IN_A > IN_B) ? 8'h01 : 8'h00;
                //A < B
                4'hB: Out <= (IN_A < IN_B) ? 8'h01 : 8'h00;
                //A AND B
                4'hC: Out <= IN_A & IN_B;
                //A NAND B
                4'hD: Out <= ~(IN_A & IN_B);
                //A OR B
                4'hE: Out <= IN_A | IN_B;
                //A XOR B
                4'hF: Out <= IN_A ^ IN_B;
                //Default A
                default: Out <= IN_A;
            endcase
        end
    end
    
    assign OUT_RESULT = Out;
    
endmodule
