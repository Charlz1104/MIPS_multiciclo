/*******************************************************************************
*Name:

*******************************************************************************/
module Branches

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

assign BeqAnd_wire = Beq & Flag_ALU;
assign BneAnd_wire = Bne & ~Flag_ALU;

assign Branch = BneAnd_wire | BeqAnd_wire; 

endmodule
