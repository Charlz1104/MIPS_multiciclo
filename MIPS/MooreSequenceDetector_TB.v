module MooreSequenceDetector_TB;

parameter WORD_LENGTH = 5;


	// Input Ports
	reg clk_tb = 0;
	reg reset_tb;
//	input start,			// Start MIPS 
	reg [WORD_LENGTH -1 : 0] Op_tb;				// Opcode for I and J instructions 
	reg [WORD_LENGTH -1 : 0] Funct_tb;			// Funct for R type instructions  (Opcode =0)

	// Output Port
	
	wire IorD_tb;			// Instruction or Data memory moduole
	wire Data_tb;
	wire ALUout_tb;
	wire Ram_Rom_tb;		//Selector for choosing memory source
	wire MemWrite_tb;		// Enable writing in memory
	wire IRWrite_tb;		// Instruction to write to be decoded
	wire RegDst_tb;			// Register Destination depening on I or R instruction
	wire MemtoReg_tb;		// Memoty to Address register
	wire RegWrite_tb;	// Enables writing in register file
	wire RegisterA_tb;
	wire RegisterB_tb;
	wire ALUSrcA_tb;		// 
	wire [1 : 0] ALUSrcB_tb;      // 
	wire [WORD_LENGTH -2 : 0] ALUControl_tb;	// Operation to be excecuted by ALU
	wire PCSrc_tb;			// Program counter added while Instruction fetch
	wire BneBranch_tb;			// Branches bne 
	wire BeqBranch_tb;			// Branch beq  
	wire PCWrite_tb;		// Enable to write on Program counter register
	wire JumpCtrl_tb;		// Multiplexion between Jr and J
	wire JalCtrl_tb;		// Multiplexion for Jar and Jr or J
	

	
MooreSequenceDetector

#(
.WORD_LENGTH(WORD_LENGTH)
)

DUV

(
	// Input Ports
	.clk(clk_tb),
	.reset(reset_tb),
//	input start,			// Start MIPS 
	.Op(Op_tb),				// Opcode for I and J instructions 
	.Funct(Funct_tb),			// Funct for R type instructions  (Opcode =0)

	// Output Port
	
	.IorD(IorD_tb),			// Instruction or Data memory moduole
	.Data(Data_tb),
	.ALUout(ALUout_tb),
	.Ram_Rom(Ram_Rom_tb),		//Selector for choosing memory source
	.MemWrite(MemWrite_tb),		// Enable writing in memory
	.IRWrite(IRWrite_tb),		// Instruction to write to be decoded
	.RegDst(RegDst_tb),			// Register Destination depening on I or R instruction
	.MemtoReg(MemtoReg_tb),		// Memoty to Address register
	.RegWrite(RegWrite_tb),		// Enables writing in register file
	.RegisterA(RegisterA_tb),
	.RegisterB(RegisterB_tb),
	.ALUSrcA(ALUSrcA_tb),		// 
	.ALUSrcB(ALUSrcB_tb),      // 
	.ALUControl(ALUControl_tb),	// Operation to be excecuted by ALU
	.PCSrc(PCSrc_tb),			// Program counter added while Instruction fetch
	.BneBranch(BneBranch_tb),			// Branches bne 
	.BeqBranch(BeqBranch_tb),			// Branch beq  
	.PCWrite(PCWrite_tb),		// Enable to write on Program counter register
	.JumpCtrl(JumpCtrl_tb),		// Multiplexion between Jr and J
	.JalCtrl(JalCtrl_tb)		// Multiplexion for Jar and Jr or J
);
	
	
/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk_tb = !clk_tb;
  end
/*********************************************************/
initial begin // reset generator
   #0 reset_tb = 0;
   #2 reset_tb = 1;
end
/*********************************************************/
initial begin
   #0 Op_tb = 6'h8;
	#24 Op_tb = 6'h5;
	#50 Op_tb = 6'h0;
end
/*********************************************************/
initial begin
   #50 Funct_tb = 6'h0;	
end
/*********************************************************/
endmodule
