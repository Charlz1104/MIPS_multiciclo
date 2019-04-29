/****************************************************************************************
*****************************************************************************************
Name: 
	Branches_MIPS
	
Description: 


Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/
module Branches_MIPS

//Input ports 
(
	input Beq,
	input Bne,
	input Flag_ALU,

//Output ports 

	output Branch
);

/*******************************************************************************
*												CODE  															
*******************************************************************************/

wire BeqAnd_wire;
wire BneAnd_wire;

assign BeqAnd_wire = Beq & ~Flag_ALU;
assign BneAnd_wire = Bne & Flag_ALU;

assign Branch = BneAnd_wire | BeqAnd_wire; 

endmodule
