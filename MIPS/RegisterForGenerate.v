/****************************************************************************************
*****************************************************************************************
Name:
	RegisterForGenerate

Description:
	This is module creates 32 Registers 32-bit-wide, usign a for generate, also is contains
	a multiplexer of 32 inputs through an instantation

Author:
	Cesar Carlos Robles Martinez 

Date: 	
	14/04/2019

*****************************************************************************************
*****************************************************************************************/


module RegisterForGenerate
#(
	parameter WORD_LENGTH = 32
)
(
	input clk,
	input reset,
	input write,
	input [WORD_LENGTH -1:0]enable,
	input [4:0]sel_1,
	input [4:0]sel_2,
	input  [WORD_LENGTH -1: 0] Data,
	
	output [WORD_LENGTH -1: 0] Data_Out_1,
	output [WORD_LENGTH -1: 0] Data_Out_2
	
);

/*******************************************************************************
											NETS LIST 															
*******************************************************************************/


wire [31:0] Matrix[31:0]; 					// Wire to create a MATRIX 32 x 32
//wire [WORD_LENGTH : 0] Matrix;			// Wire to connect Output RegisterForGenerate to Multiplexer
	
/*******************************************************************************
								FOR GENERATE TO CREATE 32 REGISTERS  															
*******************************************************************************/



genvar i;

generate
	for(i=0;i<=WORD_LENGTH-1; i = i + 1) begin:Registers

		Register_enable
		RegisterUnit
		(
			// Input Ports
			.clk(clk),
			.reset(reset),
			.enable(enable[i]&& write),
			.Data_Input(Data),
			
			
			// Output Ports
			.Data_Output(Matrix[i])
			);
				
	end

endgenerate


/*******************************************************************************
										OUTPUT MULTIPLEXER_1 32 Bit  															
*******************************************************************************/


Multiplexer_With_Case
	
Multiplexer_1
(
//Inputs
	.sel(sel_1),
	.Reg_0(Matrix[0]),
	.Reg_1(Matrix[1]),
	.Reg_2(Matrix[2]),
	.Reg_3(Matrix[3]),
	.Reg_4(Matrix[4]),
	.Reg_5(Matrix[5]),
	.Reg_6(Matrix[6]),
	.Reg_7(Matrix[7]),
	.Reg_8(Matrix[8]),
	.Reg_9(Matrix[9]),
	.Reg_10(Matrix[10]),
	.Reg_11(Matrix[11]),
	.Reg_12(Matrix[12]),
	.Reg_13(Matrix[13]),
	.Reg_14(Matrix[14]),
	.Reg_15(Matrix[15]),
	.Reg_16(Matrix[16]),
	.Reg_17(Matrix[17]),
	.Reg_18(Matrix[18]),
	.Reg_19(Matrix[19]),
	.Reg_20(Matrix[20]),
	.Reg_21(Matrix[21]),
	.Reg_22(Matrix[22]),
	.Reg_23(Matrix[23]),
	.Reg_24(Matrix[24]),
	.Reg_25(Matrix[25]),
	.Reg_26(Matrix[26]),
	.Reg_27(Matrix[27]),
	.Reg_28(Matrix[28]),
	.Reg_29(Matrix[29]),
	.Reg_30(Matrix[30]),
	.Reg_31(Matrix[31]),
	
//Outputs
	.Output(Data_Out_1)
	
	);
	
	
/*********************************************************************************************************
*									OUTPUT MULTIPLEXER_2 32 Bit 																	*
*********************************************************************************************************/	
	
	Multiplexer_With_Case
	
Multiplexer_2
(
//Inputs
	.sel(sel_2),
	.Reg_0(Matrix[0]),
	.Reg_1(Matrix[1]),
	.Reg_2(Matrix[2]),
	.Reg_3(Matrix[3]),
	.Reg_4(Matrix[4]),
	.Reg_5(Matrix[5]),
	.Reg_6(Matrix[6]),
	.Reg_7(Matrix[7]),
	.Reg_8(Matrix[8]),
	.Reg_9(Matrix[9]),
	.Reg_10(Matrix[10]),
	.Reg_11(Matrix[11]),
	.Reg_12(Matrix[12]),
	.Reg_13(Matrix[13]),
	.Reg_14(Matrix[14]),
	.Reg_15(Matrix[15]),
	.Reg_16(Matrix[16]),
	.Reg_17(Matrix[17]),
	.Reg_18(Matrix[18]),
	.Reg_19(Matrix[19]),
	.Reg_20(Matrix[20]),
	.Reg_21(Matrix[21]),
	.Reg_22(Matrix[22]),
	.Reg_23(Matrix[23]),
	.Reg_24(Matrix[24]),
	.Reg_25(Matrix[25]),
	.Reg_26(Matrix[26]),
	.Reg_27(Matrix[27]),
	.Reg_28(Matrix[28]),
	.Reg_29(Matrix[29]),
	.Reg_30(Matrix[30]),
	.Reg_31(Matrix[31]),
	
//Outputs
	.Output(Data_Out_2)
	);


endmodule
