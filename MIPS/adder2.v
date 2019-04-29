/****************************************************************************************
*****************************************************************************************
Name: 
	adder2
	
Description: 


Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module adder2

#(
parameter WORD_LENGTH = 32
)

(
//Inputs
	input [WORD_LENGTH -1 : 0] PC,
	input [WORD_LENGTH -1 : 0] Four,
	
//Outputs
	 output [WORD_LENGTH -1 : 0] J
);

	assign J = PC + Four;


endmodule 