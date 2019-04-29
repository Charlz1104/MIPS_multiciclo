/****************************************************************************************
*****************************************************************************************
Name:
	MultiplexerForGenerate

Description:
	This is module creates 32 Registers 32-bit-wide, usign a for generate, also is contains 
	a multiplexer 	of 32 inputs through an instantation

Author:
	Cesar Carlos Robles Martinez 

Date: 	
	14/04/2019

*****************************************************************************************
*****************************************************************************************/

module Multiplexer_With_Case
#(
parameter WORD_LENGTH = 32
)
(
input [4:0] sel,
input [WORD_LENGTH -1 : 0] Reg_0,
input [WORD_LENGTH -1 : 0] Reg_1,
input [WORD_LENGTH -1 : 0] Reg_2,
input [WORD_LENGTH -1 : 0] Reg_3,
input [WORD_LENGTH -1 : 0] Reg_4,
input [WORD_LENGTH -1 : 0] Reg_5,
input [WORD_LENGTH -1 : 0] Reg_6,
input [WORD_LENGTH -1 : 0] Reg_7,
input [WORD_LENGTH -1 : 0] Reg_8,
input [WORD_LENGTH -1 : 0] Reg_9,
input [WORD_LENGTH -1 : 0] Reg_10,
input [WORD_LENGTH -1 : 0] Reg_11,
input [WORD_LENGTH -1 : 0] Reg_12,
input [WORD_LENGTH -1 : 0] Reg_13,
input [WORD_LENGTH -1 : 0] Reg_14,
input [WORD_LENGTH -1 : 0] Reg_15,
input [WORD_LENGTH -1 : 0] Reg_16,
input [WORD_LENGTH -1 : 0] Reg_17,
input [WORD_LENGTH -1 : 0] Reg_18,
input [WORD_LENGTH -1 : 0] Reg_19,
input [WORD_LENGTH -1 : 0] Reg_20,
input [WORD_LENGTH -1 : 0] Reg_21,
input [WORD_LENGTH -1 : 0] Reg_22,
input [WORD_LENGTH -1 : 0] Reg_23,
input [WORD_LENGTH -1 : 0] Reg_24,
input [WORD_LENGTH -1 : 0] Reg_25,
input [WORD_LENGTH -1 : 0] Reg_26,
input [WORD_LENGTH -1 : 0] Reg_27,
input [WORD_LENGTH -1 : 0] Reg_28,
input [WORD_LENGTH -1 : 0] Reg_29,
input [WORD_LENGTH -1 : 0] Reg_30,
input [WORD_LENGTH -1 : 0] Reg_31,

output [WORD_LENGTH  -1: 0] Output

);

/*******************************************************************************
			 															
*******************************************************************************/

reg [WORD_LENGTH -1 : 0] Output_reg;


always@(*) begin
					
					case (sel)
					5'b00000: Output_reg = Reg_0;
					5'b00001: Output_reg = Reg_1;
					5'b00010: Output_reg = Reg_2;
					5'b00011: Output_reg = Reg_3;
					5'b00100: Output_reg = Reg_4;
					5'b00101: Output_reg = Reg_5;
					5'b00110: Output_reg = Reg_6;
					5'b00111: Output_reg = Reg_7;
					5'b01000: Output_reg = Reg_8;
					5'b01001: Output_reg = Reg_9;
					5'b01010: Output_reg = Reg_10;
					5'b01011: Output_reg = Reg_11;
					5'b01100: Output_reg = Reg_12;
					5'b01101: Output_reg = Reg_13;
					5'b01110: Output_reg = Reg_14;
					5'b01111: Output_reg = Reg_15;
					5'b10000: Output_reg = Reg_16;
					5'b10001: Output_reg = Reg_17;
					5'b10010: Output_reg = Reg_18;
					5'b10011: Output_reg = Reg_19;
					5'b10100: Output_reg = Reg_20;
					5'b10101: Output_reg = Reg_21;
					5'b10110: Output_reg = Reg_22;
					5'b10111: Output_reg = Reg_23;
					5'b11000: Output_reg = Reg_24;
					5'b11001: Output_reg = Reg_25;
					5'b11010: Output_reg = Reg_26;
					5'b11011: Output_reg = Reg_27;
					5'b11100: Output_reg = Reg_28;
					5'b11101: Output_reg = Reg_29;
					5'b11110: Output_reg = Reg_30;
					5'b11111: Output_reg = Reg_31;

					default: Output_reg = 0;
		endcase
end

assign Output= Output_reg;

endmodule

