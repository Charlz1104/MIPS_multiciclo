/****************************************************************************************
*****************************************************************************************
Name: 
	MIPS
	
Description: 
	This is the Top Level Module of the MIPS

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module MIPS

#(
parameter WORD_LENGTH_32 = 32,
parameter WORD_LENGTH_16 = 16,
parameter WORD_LENGTH = 5,


parameter REFERENCE_CLOCK = 50_000_000, //50_000_000, // Reference frecuency 
parameter FRECUENCY = 20	   			 // Frequency to being created expresed in Hertz
)			

(
//inputs

	input clk,
	input reset,
	input enable,
	
	output clk_out,
	output [7 : 0] GPIO,
	output [7 : 0] UART
);

/******************************************************************/

wire IorD_wire;					// Instruction or Data memory moduole
wire Data_wire;					// Register for lw instruction
wire ALUout_wire;					// Register for output ALU
wire Ram_Rom_wire;	  			// Memory source
wire MemWrite_wire;				// Enable writing in memory
wire IRWrite_wire;				// Instruction to write to be decoded
wire [1 : 0]RegDst_wire;		// Register Destination depening on I or R instruction
wire [1 : 0]MemtoReg_wire;		// Memoty to Address register
wire RegWrite_wire;				// Enables writing in register file
wire ALUSrcA_wire;				// PC or Register A
wire [1 : 0]ALUSrcB_wire;  	// Selector for the input Mux 4to1
wire [3 : 0]ALUControl_wire;	// Operation to be excecuted by ALU
wire PCSrc_wire;					// Program counter added while Instruction fetch
wire PCWrite_wire;				// Enable to write on Program counter register
wire JumpCtrl_wire;				// Multiplexion between Jr and J
wire JumpOut_wire;				// Multiplexion for Jar and Jr or J

wire ZeroFlag_wire;

wire [5 : 0] Op_wire;
wire [5 : 0] Func_wire;


// Frecuency devider

wire clk_out_wire;

assign clk_out = clk_out_wire;

/**************************************************************************
MIPS CTRL

Control for the MIPS

**************************************************************************/
MIPS_CTRL


#(
.WORD_LENGTH(WORD_LENGTH)
)

Machine_control

(
//inputs
	.clk(clk), //  clk_out_wire
	.reset(reset),
	.Op(Op_wire),
	.Func(Func_wire),
	.Flag_ALU(ZeroFlag_wire),

//outputs
	.IorD(IorD_wire),					// Instruction or Data memory moduole
	.Data(Data_wire),
	.ALUout(ALUout_wire),
	.Ram_Rom(Ram_Rom_wire),	   	// Memory source
	.MemWrite(MemWrite_wire),		// Enable writing in memory
	.IRWrite(IRWrite_wire),			// Instruction to write to be decoded
	.RegDst(RegDst_wire),			// Register Destination depening on I or R instruction
	.MemtoReg(MemtoReg_wire),		// Memoty to Address register
	.RegWrite(RegWrite_wire),		// Enables writing in register file
	.RegisterA(RegisterA_wire),
	.RegisterB(RegisterB_wire),
	.ALUSrcA(ALUSrcA_wire),			// 
	.ALUSrcB(ALUSrcB_wire),    	// 
	.ALUControl(ALUControl_wire),	// Operation to be excecuted by ALU
	.PCSrc(PCSrc_wire),				// Program counter added while Instruction fetch
//	.BneBranch,							// Branches bne
//	.BeqBranch,							// Branches beq 
	.PCWrite(PCWrite_wire),			// Enable to write on Program counter register
	.JumpCtrl(JumpCtrl_wire),		// Multiplexion between Jr and J
	.JumpOut(JumpOut_wire)			// Multiplexion for Jar and Jr or J
	
);


/**************************************************************************
MIPS Datapath

Datapath for the MIPS

**************************************************************************/

MIPS_DT

#(
.WORD_LENGTH_32(WORD_LENGTH_32),
.WORD_LENGTH_16(WORD_LENGTH_16),
.WORD_LENGTH_5(WORD_LENGTH)
)

MIPS_DATAPATH

(
//inputs

	.clk(clk),
	.reset(reset),
	.IorD(IorD_wire),						// Instruction or Data memory moduole
	.Data(Data_wire),
	.ALUout(ALUout_wire),
	.Ram_Rom(Ram_Rom_wire),				// Memory source
	.MemWrite(MemWrite_wire),			// Enable writing in memory
	.IRWrite(IRWrite_wire),				// Instruction to write to be decoded
	.RegDst(RegDst_wire),				// Register Destination depening on I or R instruction
	.MemtoReg(MemtoReg_wire),			// Memoty to Address register
	.RegWrite(RegWrite_wire),			// Enables writing in register file
	.RegisterA(RegisterA_wire),
	.RegisterB(RegisterB_wire),
	.ALUSrcA(ALUSrcA_wire),				// 
	.ALUSrcB(ALUSrcB_wire),     		// 
	.ALUControl(ALUControl_wire),		// Operation to be excecuted by ALU
	.PCSrc(PCSrc_wire),					// Program counter added while Instruction fetch 
	.PCWrite(PCWrite_wire),				// Enable to write on Program counter register
	.JumpCtrl(JumpCtrl_wire),			// Multiplexion between Jr and J
	.JumpOut(JumpOut_wire),				// Multiplexion for Jar and Jr or J

//outputs

	.Data_out(GPIO),
	.Data_UART(UART),
	.Op(Op_wire),
	.Func(Func_wire),
	.ZeroFlag(ZeroFlag_wire)
);

/**************************************************************************
Frequency_Divider

Frequency generator

**************************************************************************/
/*
Frequency_Divider

#(
.REFERENCE_CLOCK(REFERENCE_CLOCK), // Reference frecuency 
.FRECUENCY(FRECUENCY) 		        // Frequency to being created expresed in Hertz
)

New_clock

(
	.clk(clk),
	.reset(reset),
	.enable(enable),

	.clk_out(clk_out_wire)
);
*/

endmodule

