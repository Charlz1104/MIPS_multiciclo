/****************************************************************************************
*****************************************************************************************
Name:
	MultiplexerForGenerate

Description:
	This is module creates 32 Registers 32-bit-wide, usign a for generate, also is 
	contains a multiplexer of 32 inputs through an instantation

Author:
	Cesar Carlos Robles Martinez 

Date: 	
	14/04/2019

*****************************************************************************************
*****************************************************************************************/

module Demultiplexer_With_Case

(
//inputs
 input [4:0] sel,
 //input [31:0] Input,
 
//Outputs
 output[31:0] Output

);


/*******************************************************************************
			 															
*******************************************************************************/

reg [31:0] Output_reg;



always@(*) begin
					
					case (sel)
					5'b00000: Output_reg = 1;
					5'b00001: Output_reg = 2;
					5'b00010: Output_reg = 4;
					5'b00011: Output_reg = 8;
					5'b00100: Output_reg = 16;
					5'b00101: Output_reg = 32;
					5'b00110: Output_reg = 64;
					5'b00111: Output_reg = 128;
					5'b01000: Output_reg = 256;
					5'b01001: Output_reg = 512;
					5'b01010: Output_reg = 1024;
					5'b01011: Output_reg = 2048;
					5'b01100: Output_reg = 4096;
					5'b01101: Output_reg = 8192;
					5'b01110: Output_reg = 16384;
					5'b01111: Output_reg = 32768;
					5'b10000: Output_reg = 65536;
					5'b10001: Output_reg = 131072;
					5'b10010: Output_reg = 262144;
					5'b10011: Output_reg = 524288;
					5'b10100: Output_reg = 1048576;
					5'b10101: Output_reg = 2097152;
					5'b10110: Output_reg = 4194304;
					5'b10111: Output_reg = 8388608;
					5'b11000: Output_reg = 16777216;
					5'b11001: Output_reg = 33554432;
					5'b11010: Output_reg = 67108864;
					5'b11011: Output_reg = 134217728;
					5'b11100: Output_reg = 268435456;
					5'b11101: Output_reg = 536870912;
					5'b11110: Output_reg = 1073741824;
					5'b11111: Output_reg = 2147486648;
					

					default: Output_reg = 0;
		endcase
end

assign Output= Output_reg;

endmodule




