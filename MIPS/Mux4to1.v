/****************************************************************************************
*****************************************************************************************
Name: 
	Mux4to1
	
Description: 
	This is a multiplexer 4to1

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module Mux4to1

#(
	parameter WORD_LENGTH = 32
)
(
// inputs

	input [1 : 0] Selector,
	input [WORD_LENGTH - 1 : 0] MUX_Data0,
	input [WORD_LENGTH - 1 : 0] MUX_Data1,
	input [WORD_LENGTH - 1 : 0] MUX_Data2,
	input [WORD_LENGTH - 1 : 0] MUX_Data3,

// outputs	

	output [WORD_LENGTH - 1 : 0] MUX_Output

);


wire [WORD_LENGTH - 1 : 0] Mux1_to_Mux3;
wire [WORD_LENGTH - 1 : 0] Mux2_to_Mux3;


Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Multiplexer_1
(
	.Selector(Selector[0]),
	.MUX_Data0(MUX_Data0),
	.MUX_Data1(MUX_Data1),
	
	.MUX_Output(Mux1_to_Mux3)

);




Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Multiplexer_2
(
	.Selector(Selector[0]),
	.MUX_Data0(MUX_Data2),
	.MUX_Data1(MUX_Data3),
	
	.MUX_Output(Mux2_to_Mux3)

);




Mux2to1
#(
	.WORD_LENGTH(WORD_LENGTH)
)
Multiplexer_3
(
	.Selector(Selector[1]),
	.MUX_Data0(Mux1_to_Mux3),
	.MUX_Data1(Mux2_to_Mux3),
	
	.MUX_Output(MUX_Output)

);



endmodule

