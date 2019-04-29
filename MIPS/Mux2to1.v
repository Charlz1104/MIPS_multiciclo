/****************************************************************************************
*****************************************************************************************
Name: 
	Mux2to1
	
Description: 
	This is a multiplexer 2to1

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module Mux2to1

#(
	parameter WORD_LENGTH = 32
)

(
// inputs

	input Selector,
	input [WORD_LENGTH - 1 : 0] MUX_Data0,
	input [WORD_LENGTH - 1 : 0] MUX_Data1,

// outputs	
	
	output [WORD_LENGTH - 1 : 0] MUX_Output

);


reg [WORD_LENGTH - 1 : 0] MUX_Output_reg;

	always@(Selector,MUX_Data1,MUX_Data0) begin
	
		if(Selector)
			MUX_Output_reg = MUX_Data1;
		else
			MUX_Output_reg = MUX_Data0;
	end
	
assign MUX_Output = MUX_Output_reg;


endmodule
