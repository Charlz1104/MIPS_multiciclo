/****************************************************************************************
*****************************************************************************************
Name:
	Register File

Description:
	This is module creates 32 Registers 32-bit-wide

Author:
	Cesar Carlos Robles Martinez 

Date: 	
	14/04/2019

*****************************************************************************************
*****************************************************************************************/

module Register_fiel

#(
parameter WORD_LENGTH_32 =32,
parameter WORD_LENGTH_5 =5
)

(
input clk,
input reset,
input write,
input [WORD_LENGTH_5 -1:0]Read_reg_1,
input [WORD_LENGTH_5 -1:0]Read_reg_2,
input [WORD_LENGTH_32 -1 :0]Write_data,
input [WORD_LENGTH_5 -1:0]Write_register,

output [WORD_LENGTH_32 -1 :0]Read_data_1,
output [WORD_LENGTH_32 -1 :0]Read_data_2
);

/*******************************************************************************
											NETS LIST 															
*******************************************************************************/

//wire [WORD_LENGTH_32 -1:0] Enable_register_file;

																				
wire [WORD_LENGTH_32 -1:0] Data_reg_to_For_generate_wire;		// Connection between Registed data an for generate module

wire [WORD_LENGTH_32 -1:0] enable_wire;								// For register wire connection 								
/*	
wire Condition_enable_wire; 												// Condition to select register to read

assign Condition_enable_wire =  enable_wire && write ;

 
/*********************************Write Data & enable Witre ***************************************************/
Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

Data_reg

(
//Inputs
.clk(clk),
.reset(reset),
.enable(write),
.Data_Input(Write_data),
//Outputs
.Data_Output(Data_reg_to_For_generate_wire)
);


/********************************* RegisterForGenerate ***************************************************/

RegisterForGenerate

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

Registers

(
//Inputs
	.clk(clk),
	.reset(reset),
	.write(write),
	.enable(enable_wire),
	.sel_1(Read_reg_1),
	.sel_2(Read_reg_2),
	.Data(Data_reg_to_For_generate_wire),

//Outputs
	.Data_Out_1(Read_data_1),
	.Data_Out_2(Read_data_2)

);

/********************************* Register write ***************************************************/

Demultiplexer_With_Case

//#(
//.WORD_LENGTH(WORD_LENGTH_32)
//)

Register_write
(
.sel(Write_register),
.Output(enable_wire)
);
endmodule



