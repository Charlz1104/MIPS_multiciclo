/****************************************************************************************
*****************************************************************************************
Name: 
	Branc_Ctrl
	
Description: 
	This module copare the condition for the branches in together with zero flag from ALU

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module Branc_Ctrl

(
// inputs
	input Beq,
	input Bne,
	input Flag_ALU,

// outputs

	output Branch
);


wire BeqAnd_wire;
wire BneAnd_wire;

/*******************************************************************************
Branches_MIPS

Eacth branch is connected together with the Zero_Flag through AND gates in order
to chech the condition for esch branch 

Bne & Zero_Flag

Beq & Zero_Flag

After they are connected to a OR gate to check the condition with PCWrite that comes
from state machine

PCWrite | (beq or bne)
											
*******************************************************************************/

assign BeqAnd_wire = Beq & Flag_ALU;
assign BneAnd_wire = Bne & Flag_ALU;

assign Branch = BeqAnd_wire | BneAnd_wire; 

endmodule
