/****************************************************************************************
*****************************************************************************************
Name: 
	MIPS_CTRL for Multi-Cicly Processor MIPS
	
Description: 
	This is the module that performs the control for the MIPS

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/



module MIPS_CTRL

#(
parameter WORD_LENGTH = 5
)

(
//inputs

	input clk,
	input reset,
//	input start,
	input [5:0]Op,
	input [5:0]Func,
	input Flag_ALU,

//outputs
	output IorD,					// Instruction or Data memory moduole
	output Data,
	output ALUout,
	output Ram_Rom,      		// Memory source
	output MemWrite,				// Enable writing in memory
	output IRWrite,				// Instruction to write to be decoded
	output [1 : 0]RegDst,		// Register Destination depening on I or R instruction
	output [1 : 0]MemtoReg,		// Memoty to Address register
	output RegWrite,				// Enables writing in register file
	output RegisterA,
	output RegisterB,
	output ALUSrcA,				// 
	output [1 : 0] ALUSrcB, 	// 
	output [3 : 0] ALUControl,	// Operation to be excecuted by ALU
	output PCSrc,					// Program counter added while Instruction fetch
	output PCWrite,				// Enable to write on Program counter register
	output JumpCtrl,				// Multiplexion between Jr and J
	output JumpOut					// Multiplexion for Jar and Jr or J
	
);



wire Branch_wire;
wire BeqBranch_wire;
wire BneBranch_wire;
wire PCWrite_wire;

/**************************************************************************
MooreSequenceDetector

State machine for the control of MIPS datapath

**************************************************************************/
MooreSequenceDetector


StateMachine

(
// Input Ports
	.clk(clk),
	.reset(reset),
//	.start(start),					// Start MIPS 
	.Op(Op),							// Opcode for I and J instructions 
	.Funct(Func),					// Funct for R type instructions  (Opcode =0)

// Output Ports
	.IorD(IorD),
	.Data(Data),
	.ALUout(ALUout),				//Instruction or Data memory moduole
	.Ram_Rom(Ram_Rom),			// Memory source
	.MemWrite(MemWrite),			// Enable writing in memory
	.IRWrite(IRWrite),			// Instruction to write to be decoded
	.RegDst(RegDst),				// Register Destination depening on I or R instruction
	.MemtoReg(MemtoReg),			// Memoty to Address register
	.RegWrite(RegWrite),			//	 Enables writing in register file
	.RegisterA(RegisterA),
	.RegisterB(RegisterB),
	.ALUSrcA(ALUSrcA),			// 
	.ALUSrcB(ALUSrcB),      	// 
	.ALUControl(ALUControl),	// Operation to be excecuted by ALU
	.PCSrc(PCSrc),					// Program counter added while Instruction fetch
	.BneBranch(BneBranch_wire),// Branches beq 
	.BeqBranch(BeqBranch_wire),// Branches beq
	.PCWrite(PCWrite_wire),		// Enable to write on Program counter register
	.JumpCtrl(JumpCtrl),			// Multiplexion between Jr and J
	.JumpOut(JumpOut)				// Multiplexion for Jar and Jr or J
		
);

/**************************************************************************
Branches

Conditional for Branches beq and bne

**************************************************************************/

Branches_MIPS 

Branch_MIPS

(
// Input 
	.Beq(BeqBranch_wire),
	.Bne(BneBranch_wire),
	.Flag_ALU(Flag_ALU),

// Output ports 

	.Branch(Branch_wire)
);

/**************************************************************************
PCEn

Conditional for Branches and PC Write

**************************************************************************/

PCEn

PCenable

(
// Inputs
	.Branch(Branch_wire),
	.PCWrite(PCWrite_wire),

// Output

	.PCEn_out(PCWrite)
);

endmodule
