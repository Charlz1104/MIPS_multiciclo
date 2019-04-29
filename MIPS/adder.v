/****************************************************************************************
*****************************************************************************************
Name: 
	adder
	
Description: 


Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module adder

#(
parameter WORD_LENGTH = 32
)

(
//Inputs
   input [WORD_LENGTH -1 : 0] SignExtLeft2,
	input [WORD_LENGTH -1 : 0] PC,
	input [WORD_LENGTH -1 : 0] Four,
	
//Outputs
	 output [WORD_LENGTH -1 : 0] Branch
);

	assign Branch = SignExtLeft2 + PC + Four;


endmodule 