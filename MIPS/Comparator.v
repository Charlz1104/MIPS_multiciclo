/****************************************************************************************
*****************************************************************************************
Name: 
	Comparator
	
Description: 


Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module Comparator

#(
parameter WORD_LENGTH = 32
)

(
//Inputs
    input [WORD_LENGTH -1 : 0] AddressIn,
//Outputs
	 output enablePort,
	 output enableUART
);


reg [WORD_LENGTH -1 : 0] enable_reg;
reg [WORD_LENGTH -1 : 0] enableUART_reg;
 
//GPIO

always@(AddressIn)
	begin

			if(AddressIn == 32'h10010024)
				enable_reg = 1'b1;		
			else
				enable_reg = 1'b0;
	end

assign enablePort = enable_reg;

// UART

always@(AddressIn)
	begin

			if(AddressIn == 32'h10010020)
				enableUART_reg = 1'b1;		
			else
				enableUART_reg = 1'b0;
	end

assign enableUART = enableUART_reg;

endmodule
