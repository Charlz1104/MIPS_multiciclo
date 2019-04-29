/**********************************************************************************
*	Description:
*	This is the ALU module
*
*	Inputs:
*	input [3:0] control
*	input [WORD_LENGTH - 4:0] A 
*	input [WORD_LENGTH - 4:0] B
*
*	Outputs:
*	output [WORD_LENGTH - 1:0] C
*	output carry
*
*	Author:
*	Cesar Carlos Robles Martinez
*
*	Date:
*	02/09/2017
***********************************************************************************/

module ALU

/***********************************************************************************
*  										PARAMETERS													  *
***********************************************************************************/

#(
	parameter WORD_LENGTH = 8

)

/***********************************************************************************
*  									 		PORTS													     *
***********************************************************************************/

//Input ports
(
	input [3:0] Sel,					// Operation selector
	input [WORD_LENGTH - 1:0] A,		// Input Data 1  
	input [WORD_LENGTH - 1:0] B,		// Input Data 2

//Output ports

	output [WORD_LENGTH - 1:0] C,		// Output Data 
	output carry,						// Carry output
	output ZeroFlag
);

/***********************************************************************************
*  											NETS							   					 	  *
***********************************************************************************/

//Regs
	reg [WORD_LENGTH -1 :0] C_reg;
	reg ZeroFlag_reg;

/***********************************************************************************
*  										ASSIGNMENTS								  				 	  *
***********************************************************************************/

// Carry

		assign C = C_reg;
		assign ZeroFlag = ZeroFlag_reg;
	
	
/***********************************************************************************
*  										DESCRIPTION								  				 	  *
***********************************************************************************/

	always@(A,B) begin
		case (Sel)
			4'b0000: C_reg = A + B;						//add
			4'b0001: C_reg = A - B;						//sub
			4'b0010: C_reg = A [15:0] * B [15:0];	//multi
			4'b0011: C_reg = ~A;							//not
			4'b0100:	C_reg = ~A +1;						//Two´s complement 
			4'b0101:	C_reg = A & B;						//and
			4'b0110:	C_reg = A | B;						//or
			4'b0111:	C_reg = {B[15:0],16'b0};		//shamt
			4'b1000:	if(Sel == 4'b1000)
							C_reg = B << 1;
						else
							C_reg = B;
			
			4'b1001:	if(A < B)							//Slti
							C_reg = 32'h00000001;
						else
							C_reg = 32'h00000000;
						
			default: C_reg = 0;
		endcase
	end
	
// Branches conditional flag
	
always@(C_reg, A - B)begin

	if (C_reg == 32'h00000000)
	
		ZeroFlag_reg = 1'b1;
	else 
		ZeroFlag_reg = 1'b0;	
		
end		

	
endmodule
