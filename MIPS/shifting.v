/****************************************************************************************
*****************************************************************************************
Name: 
	shifting
	
Description: 
	

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module shifting

#(
parameter WORD_LENGTH = 16
)

(
	input [WORD_LENGTH -1 : 0] SignExtIn,
	
	output [WORD_LENGTH -1 : 0] SignExtOut
);

reg [WORD_LENGTH -1 : 0] SignExtIn_reg;


assign SignExtOut = SignExtIn << 2;

endmodule
 
