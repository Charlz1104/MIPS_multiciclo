/****************************************************************************************
*****************************************************************************************
Name: 
	Data Path for Multi-Cicly Processor MIPS
	
Description: 
	This module is the datapath for the Multi-Cycle Processor MIPS, it contains all instances
	 of the modules that integrates the execution path for the processor

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module MIPS_DT

// Main parameters for the modules
#(
parameter WORD_LENGTH_32 =32,
parameter WORD_LENGTH_16 =16,
parameter WORD_LENGTH_5 = 5
)

(
// Inputs

	input clk,
	input reset,
	input IorD,						// Instruction or Data memory moduole
	input Data,						//
	input ALUout,					//
	input Ram_Rom,					//
	input MemWrite,				// Enable writing in memory
	input IRWrite,					// Instruction to write to be decoded
	input [1 : 0]RegDst,			// Register Destination depening on I or R instruction
	input [1 : 0]MemtoReg,		// Memoty to Address register
	input RegWrite,				// Enables writing in register file
	input RegisterA,				//
	input RegisterB,				//
	input ALUSrcA,					// 
	input [1 : 0] ALUSrcB,     // 
	input [3 : 0] ALUControl,	// Operation to be excecuted by ALU
	input PCSrc,					// Program counter added while Instruction fetch
	input PCWrite,					// Enable to write on Program counter register
	input JumpCtrl,				// Multiplexion between Jr and J
	input JumpOut,					// Multiplexion for Jar and Jr or J

// Outputs

	output [7 : 0]Data_out,
	output [7 : 0]Data_UART,
	output [5: 0]Op,
	output [5 :0]Func,
	output ZeroFlag

);

/*******************************************************************************
											NETS LIST
													
Wires for the connection between the modules that integrates the Datapath
											
*******************************************************************************/

// Program counter register 
	wire [WORD_LENGTH_32 -1 : 0] PCreg_to_muxAdr;

// Output Register 
	wire [WORD_LENGTH_32 -1 : 0] Outreg_to_muxAdr;

// Mux PCSrc 
	wire [WORD_LENGTH_32 -1 : 0] MuxPCSrc_to_PCreg;

// Register file 
	wire [WORD_LENGTH_32 -1 : 0] RegfileA_to_regA;
	wire [WORD_LENGTH_32 -1 : 0] RegfileB_to_regB;

// Reg A
	wire [WORD_LENGTH_32 -1 : 0] RegfileA_to_muxALUSrcA;

// Reg B 
	wire [WORD_LENGTH_32 -1 : 0] RegfileB_to_muxALUSrcB;

// MUX ALUSrcA 
	wire [WORD_LENGTH_32 -1 : 0] muxALUSrcA_to_ALU;

// MUX ALUSrcB 

	wire [WORD_LENGTH_32 -1 : 0] One_wire;
	wire [WORD_LENGTH_32 -1 : 0] muxALUSrcB_to_ALU;

// Mux Ard 

	wire [WORD_LENGTH_32 -1 : 0] muxAdr_to_Memories_wire;
	wire [WORD_LENGTH_32 -1 : 0] muxAdr_to_Memories_wire_out;

//Mux Dst
	wire [WORD_LENGTH_5 -1 : 0] RegDst_to_regFile_wire; 
	wire [WORD_LENGTH_5 -1 : 0] raDst_wire;

// ALU 
	wire [WORD_LENGTH_32 -1 : 0] ALU_to_Ot_Outreg; 

// Data register 
	wire [WORD_LENGTH_32 -1 : 0] Data_register_wire;
	wire [WORD_LENGTH_32 -1 : 0] WD_wire;

// Memories 
	wire [WORD_LENGTH_32 -1 : 0] Memory_to_IRreg_wire;

// Instr register out 
	wire [WORD_LENGTH_32 -1 : 0] Instr_in_wire;
	wire [WORD_LENGTH_32 -1 : 0] Instr_out_wire;
 
// Shifting <<2 
	wire [WORD_LENGTH_16 -1 : 0] SignExtIn_wire;
	wire [WORD_LENGTH_32 -1 : 0] SignExtOut_wire;

// Value 4 
	wire [WORD_LENGTH_32 -1 : 0] Four_wire;

// Branches
	wire [WORD_LENGTH_32 -1 : 0] PCinputmux_wire;
	wire [WORD_LENGTH_32 -1 : 0] BranchIn_wire;

//Jumps -------------------

// J

	wire [27:0] j_Address_wire;
	wire [27:0] j_Shiftleft_wire;
	wire [3:0] j_PC_wire;
	wire [WORD_LENGTH_32 -1 : 0] Jadd_wire;
	wire [WORD_LENGTH_32 -1 : 0] j_wire;
	
	assign j_Address_wire = {Instr_in_wire[27:0]}; //PCreg_to_muxAdr
	assign j_PC_wire = PCreg_to_muxAdr [31:28];
	assign j_wire = {j_PC_wire,j_Shiftleft_wire};  

	wire [WORD_LENGTH_32 -1 : 0]  j_jr_wire;
	
// Wire to connect Mux Jumps to Mux Branches
	wire [WORD_LENGTH_32 -1 : 0] Jumpmux_wire;

// Zero flag
	wire ZeroFlag_wire;

// Port
	wire [WORD_LENGTH_32 -1 : 0] Port_wire;

// Wire to enable register output for the output value
	wire enablePort_wire;
	wire enableUART_wire;

// Output mux	
	wire [WORD_LENGTH_32 -1 : 0]  Mux_out_wire;
	
// Decodification innstruction
	wire [WORD_LENGTH_5  : 0] OP_wire;
	wire [WORD_LENGTH_5  : 0] Func_wire;
	wire [WORD_LENGTH_5 -1 : 0] A1_wire;
	wire [WORD_LENGTH_5 -1 : 0] A2_wire;
	wire [WORD_LENGTH_5 -1 : 0] RegDst_Mux0_wire;
	wire [WORD_LENGTH_5 -1 : 0] RegDst_Mux1_wire;
	wire [WORD_LENGTH_16 -1 : 0] SignalEx_wire;
	wire [WORD_LENGTH_32 -1 : 0] SignalEx_out_wire;


// Assignment of wires for que instruction decodification
	assign OP_wire = {Instr_out_wire[31:26]};
	assign Func_wire = {Instr_out_wire[5:0]};
	assign A1_wire = {Instr_out_wire[25:21]};
	assign A2_wire = {Instr_out_wire[20:16]};
	assign RegDst_Mux0_wire = {Instr_out_wire[20:16]};
	assign RegDst_Mux1_wire = {Instr_out_wire[15:11]};
	assign SignalEx_wire = {Instr_out_wire[15:0]};

	assign raDst_wire = 8'h1f; 	// Value 31 to select register 31				
	assign Four_wire = 4'b100; 	// For addition to increment PC
	assign Op = OP_wire; 			// Opcode for I and J instructions
	assign Func = Func_wire; 		//Funct for R type instructions

/***********************************************************************************
											DESCRIPTION								  				 	  

								Data Path Code for the MIPS 
 																
***********************************************************************************/

/**************************************************************************
Program Counter

THe register thas perfomrs the function as a program counter

**************************************************************************/

Register_PC

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Register_PC
	
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(PCWrite),
	.Data_Input(PCinputmux_wire),  //MuxPCSrc_to_PCreg
 
	// Output Ports
	.Data_Output(PCreg_to_muxAdr) //
);


/**************************************************************************
Memories

RAM: storage the values for the concurrent codes
 
ROM: code for the instructions for the MIPS, in this memory is loaded the 
txt file created in ISA instructions

**************************************************************************/

Data_memory


#(
.WORD_LENGTH_32(WORD_LENGTH_32),
.WORD_LENGTH(WORD_LENGTH_32)
)

	Memories

(
//Input ports
.clk(clk),
.sel(Ram_Rom),
.data(RegfileB_to_muxALUSrcB),// muxAdr_to_Memories_wire   
.addr(muxAdr_to_Memories_wire),// RegfileB_to_muxALUSrcB   
.we(MemWrite),

//Output ports
.q(Instr_in_wire),
.enablePort(enablePort_wire),
.enableUART(enableUART_wire),
.Port(Port_wire),
.UART(UART_wire)
);

/**************************************************************************
Register File

Bank of registers to be used as a Core for the MIPS

**************************************************************************/

Register_fiel

#(
.WORD_LENGTH_32(WORD_LENGTH_32),
.WORD_LENGTH_5(WORD_LENGTH_5)
)

	Register_file

(
//Input ports

	.clk(clk),
	.reset(reset),
	.write(RegWrite),
	.Read_reg_1(A1_wire),
	.Read_reg_2(A2_wire),
	.Write_data(WD_wire),
	.Write_register(RegDst_to_regFile_wire), //RegDst_to_regFile_wire
	
//Output ports

	.Read_data_1(RegfileA_to_regA),
	.Read_data_2(RegfileB_to_regB)
);


/**************************************************************************
ALU

ALU for the execution and memory access

**************************************************************************/
ALU

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	ALU_module

//Input ports
(
	.Sel(ALUControl),											// selector for the operation to excecut
	.A(muxALUSrcA_to_ALU),						// input from Mux ALUSrcA that driver register file A and PC
	.B(muxALUSrcB_to_ALU),						// input from ScrB comming from Mux register fle B, 4, signext and <<2

//Output ports

	.C(ALU_to_Ot_Outreg),	 					// output ALU 
	.carry(),
	.ZeroFlag(ZeroFlag)
);


/************* BRANCHES *******************/
adder

#(
.WORD_LENGTH(WORD_LENGTH_32)
)


	Branches

(
//Inputs
   .SignExtLeft2(SignExtOut_wire),
	.PC(PCreg_to_muxAdr),
	.Four(Four_wire),
	
	.Branch(BranchIn_wire)
);

/************* INSTRUCTION COUNTER  ****************/

Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Register_INST
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(IRWrite),
	.Data_Input(Instr_in_wire),

	// Output Ports
	.Data_Output(Instr_out_wire)
);



/**************************************************************************
Register DATA

Registers to storage memory data to be delivered to mux MemtoReg for LOAD 
and STORAGE steps

**************************************************************************/
Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Register_DATA
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(Data),
	.Data_Input(Instr_in_wire),

	// Output Ports
	.Data_Output(Data_register_wire)
);


/**************************************************************************
Register file

Registers to storage the registers values from register file

**************************************************************************/

/************* OUTPUT A REG_FILE  ****************/

Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Register_A
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(RegisterA),
	.Data_Input(RegfileA_to_regA),

	// Output Ports
	.Data_Output(RegfileA_to_muxALUSrcA)
);

/************* OUTPUT B REG_FILE  ****************/

Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Register_B
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(RegisterB),
	.Data_Input(RegfileB_to_regB),

	// Output Ports
	.Data_Output(RegfileB_to_muxALUSrcB)
);


/**************************************************************************
Output Register

Register ALUout that hepls to hold the results from the ALU, for 
lw, sw, beq and bne instructions

**************************************************************************/
Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Output_register
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(ALUout),
	.Data_Input(ALU_to_Ot_Outreg),

	// Output Ports
	.Data_Output(Outreg_to_muxAdr)
);

/**************************************************************************
Register used for the Port output

**************************************************************************/

Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Register_Port
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(enablePort_wire), 
	.Data_Input(Port_wire), // Outreg_to_muxAdr

	// Output Ports
	.Data_Output(Data_out)
);

/**************************************************************************
Register used for the UART

**************************************************************************/

Register_enable

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Register_UART
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(enableUART_wire), 
	.Data_Input(Port_wire), //

	// Output Ports
	.Data_Output(Data_UART)
);

/**************************************************************************
Multiplexer IorD

Selection for instruction I or R type for the lw and sw instructions 

**************************************************************************/
Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_IorD

(
	.Selector(IorD),									// selector I or R type instruction
	.MUX_Data0(PCreg_to_muxAdr),				// PC input
	.MUX_Data1(Outreg_to_muxAdr),				// input for ALUout 
	
	.MUX_Output(muxAdr_to_Memories_wire)	// connection to input Memory	

);


/**************************************************************************
Multiplexer RegDst

Depending on the instruction type, this mux distributes the signal when Rt
becomes the destination register for the instruction

A3= number of register to be written by the instruction I type

**************************************************************************/

Mux4to1

#(
.WORD_LENGTH(WORD_LENGTH_5)
)

	Mux_RegDst

(
	.Selector(RegDst),
	.MUX_Data0(A2_wire),							// 20:16 concatenation fron decoding instruction I type instruction
	.MUX_Data1(RegDst_Mux1_wire),				// 15:11 concatenation fron decoding instruction R type instruction
	.MUX_Data2(raDst_wire),						// register 31 destination
	
	.MUX_Output(RegDst_to_regFile_wire)		// output to be delivered to A3 input register file

);

/**************************************************************************
Multiplexer MemtoReg  

lw = load word 
sw = store word

This mux is for LOAD step, when ALUout is driven to input IorD mux to by 
delivered to register file, this is and special multiplexer for lw instruction

write back

**************************************************************************/

Mux4to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_MemtoReg

(
	.Selector(MemtoReg),						// selector during LOAD step
	.MUX_Data0(Outreg_to_muxAdr),			// input for write back connection from ALUout
	.MUX_Data1(Data_register_wire),		// input from register data during LOAD step
	.MUX_Data2(PCreg_to_muxAdr),			// Jadd_wire),					// input for register 31
	.MUX_Data3(),								// not used
	
	.MUX_Output(WD_wire)						// Output to write data in register file

);

/**************************************************************************
Multiplexer ALUScrA

This allows to choose from PC before the decoding instruction step and the 
Register file A source during execution step 

**************************************************************************/

Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_ALUScrA

(
	.Selector(ALUSrcA),								// ALUSrcA selector from control unit
	.MUX_Data0(PCreg_to_muxAdr),			// (0) PC to be incremented by 4 
	.MUX_Data1(RegfileA_to_muxALUSrcA),	// (1) Input from Register file A source
	
	.MUX_Output(muxALUSrcA_to_ALU)	   // Output to be connected to the ALU

);



/**************************************************************************
Multiplexer ALUSrcB

Principal multiplexer to select source for the ALU input, depending on the
instruction to be executed for the MIPS

**************************************************************************/
Mux4to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_ALUSrcB

(
	.Selector(ALUSrcB),								// 
	.MUX_Data0(RegfileB_to_muxALUSrcB), // (00) input from register file B
	.MUX_Data1(Four_wire),					// (01) input to add 4 to program counter
	.MUX_Data2(SignalEx_out_wire),		// (10) input from sign extended
	.MUX_Data3(SignExtOut_wire),			// (11) input left shifthing <<2
	 
	.MUX_Output(muxALUSrcB_to_ALU)      // output tu connect to ALU input

);


/**************************************************************************
Multiplexer PCSrc:

During FETCH step this mux allows to pass the PC incremented and ALUout
while WRITE BACK step 
 
**************************************************************************/

Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_PCSrc

(
	.Selector(PCSrc),
	.MUX_Data0(ALU_to_Ot_Outreg), 		//(0) PC incrementes = PC+4
	.MUX_Data1(Outreg_to_muxAdr), 		//(1) 
	
	.MUX_Output(MuxPCSrc_to_PCreg) 		// MuxPCSrc_to_PCreg

);


/**************************************************************************
Multiplexer Branch:


 
**************************************************************************/

Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_Branches

(
	.Selector(ZeroFlag),
	.MUX_Data0(Mux_out_wire), 	//(0) 
	.MUX_Data1(BranchIn_wire), 		//(1) 
	
	.MUX_Output(PCinputmux_wire) 		//

);	

/**************************************************************************
Multiplexer JumpOut

Multiplexer PC or Jal
 
**************************************************************************/
/*
Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_PC_J

(
	.Selector(),
	.MUX_Data0(MuxPCSrc_to_PCreg), 		//(0)  
	.MUX_Data1(Mux_out_wire), 		//(1) 
	
	.MUX_Output(Jumpmux_wire) 		//

);	

/**************************************************************************
Sign Extend

Used to add Zeros or Ones to the inmidiat instructions to match the word
to 32 with length
 
**************************************************************************/
Signal_extended


#(
.WORD_LENGTH(WORD_LENGTH_32/2),
.WORD_LENGTH_32(WORD_LENGTH_32)
)

	Signal_extend

(
// Input
	.Data(SignalEx_wire),
	
//Output	
	.Output(SignalEx_out_wire)

);



/**************************************************************************
Shifting for Branches

This module shifts the SignExnted for Branches

**************************************************************************/
shifting


#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Shifting_for_Branches

(
//inputs
	.SignExtIn(SignalEx_out_wire),//SignExtIn_wire),
	
//outputs	
	.SignExtOut(SignExtOut_wire)

	);

/**************************************************************************
Multiplexer JumpCtrl:

Multiplexer for J and Jr
 
**************************************************************************/

Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_JumpCtrl

(
	.Selector(JumpCtrl),
	.MUX_Data0(RegfileA_to_regA), 	//(0)  jr input 
	.MUX_Data1(j_wire), 					//(1)  J unput 
	
	.MUX_Output(j_jr_wire) 				// output jr or j

);	


/**************************************************************************
Shifting for Jumps

This module shifts the SignExnted for Branches

**************************************************************************/
shifting


#(
.WORD_LENGTH(WORD_LENGTH_32 - 4)
)

	Shifting_Jumps

(
//inputs
	.SignExtIn(j_Address_wire),
	
//outputs	
	.SignExtOut(j_Shiftleft_wire)

	);

/**************************************************************************
Multiplexer JumpOut

Multiplexer for J, Jal and Jr instruction
 
**************************************************************************/

Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	Mux_JumpOut

(
	.Selector(JumpOut),
	.MUX_Data0(MuxPCSrc_to_PCreg), 		//(0) selects PC+4
	.MUX_Data1(j_jr_wire), 					//(1) Selets J output 
	
	.MUX_Output(Mux_out_wire) 				//

);	

/**************************************************************************
adder2

This adder is used to make OC = PC+4, and driven to the jal instruction

**************************************************************************/
/*
adder2

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

	adder_Jal

(
//Inputs
	.PC(PCreg_to_muxAdr), // PCreg_to_muxAdr
	.Four(4),
	
//Outputs
	 .J(Jadd_wire)
);

*/


endmodule


