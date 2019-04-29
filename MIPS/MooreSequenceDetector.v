/****************************************************************************************
*****************************************************************************************
Name: 
	MooreSequenceDetector
	
Description: 
	Moore State Machine to control de signals driven to the Datapath in order to control
	the data transferation

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module MooreSequenceDetector

#(
parameter WORD_LENGTH = 7
)

(
// Input Ports

	input clk,
	input reset,
	input [5 : 0] Op,				// Opcode for I and J instructions 
	input [5 : 0] Funct,			// Funct for R type instructions  (Opcode =0)

// Output Port
	
	output IorD,					// Instruction or Data memory moduole
	output Data,
	output ALUout,
	output Ram_Rom,				//Selector for choosing memory source
	output MemWrite,				// Enable writing in memory
	output IRWrite,				// Instruction to write to be decoded
	output [1 : 0]RegDst,		// Register Destination depening on I or R instruction
	output [1 : 0]MemtoReg,		// Memoty to Address register
	output RegWrite,				// Enables writing in register file
	output RegisterA,
	output RegisterB,
	output ALUSrcA,				// 
	output [1 : 0] ALUSrcB,    // 
	output [3 : 0] ALUControl,	// Operation to be excecuted by ALU
	output PCSrc,					// Program counter added while Instruction fetch
	output BneBranch,				// Branches bne 
	output BeqBranch,				// Branch beq  
	output PCWrite,				// Enable to write on Program counter register
	output JumpCtrl,				// Multiplexion between Jr and J
	output JumpOut					// Multiplexion for Jar and Jr or J
	
	
);


localparam IF = 0;
localparam ID = 1;
localparam EX = 2;
localparam WB = 3;


// I type instructions ----------------------------------------

localparam EX_lui = 4;
localparam WB_lui = 5;

localparam EX_Addi = 6;
localparam WB_Addi = 7;

localparam EX_ori = 8;
localparam WB_ori = 9;

localparam EX_bne =10;
localparam PC_bne = 11;

localparam EX_beq = 12;
localparam PC_beq = 13;

localparam EX_Addiu = 14;
localparam WB_Addiu = 15;

localparam EX_slti = 16;
localparam WB_slti = 17;

localparam EX_sw = 18;
localparam Mem_sw = 19;

localparam EX_lw = 20;
localparam Mem_lw = 21;
localparam Data_lw = 22;
localparam WB_lw = 23;

// R type instructions ----------------------------------------

localparam EX_sll = 24;
localparam WB_sll = 25;

localparam EX_mult = 26;
localparam WB_mult = 27; 

localparam EX_jr = 28;

// J type instructions ----------------------------------------

localparam EX_jal = 29;
localparam WB_jal = 31;
localparam IF_jal = 32;

localparam EX_j = 30;


reg [5:0] state; 



reg IorD_reg; 						// Instruction or Data memory moduole
reg Data_reg;
reg ALUout_reg;
reg Ram_Rom_Reg;					// Memory source selector
reg MemWrite_reg; 				// Enable writing in memory
reg IRWrite_reg; 	    			// Instruction to write to be decoded
reg [1 : 0]RegDst_reg;			// Register Destination depening on I or R instruction
reg [1 : 0]MemtoReg_reg;		// Memoty to Address register
reg RegWrite_reg;	   			// Enables writing in register file
reg RegisterA_reg;			
reg RegisterB_reg;
reg ALUSrcA_reg;					// 
reg [1 : 0] ALUSrcB_reg;      // 
reg [3 : 0] ALUControl_reg; 	// Operation to be excecuted by ALU
reg PCSrc_reg; 		   		// Program counter added while Instruction fetch
reg BneBranch_reg;				// Branches bne
reg BeqBranch_reg;				// Branches beq
reg PCWrite_reg;    		   	// Enable to write on Program counter register
reg JumpCtrl_reg;		  			// Multiplexion between Jr and J
reg JumpOut_reg; 		  			// Multiplexion for Jar and Jr or J


/******************************************************************************
 										State Machite
******************************************************************************/


always@(	posedge clk, negedge reset) begin

	if(reset == 1'b0)
			state <= IF;
	else 
		case (state)
			
			IF:
					state <= ID;

/******************************************************************************
 											Instruction Decode
******************************************************************************/
			
//I type ---------------------------
			
			ID:
					if(Op == 6'b001111)	   // lui instruction	
						state <= EX_lui;
				else
					if(Op == 6'b001101)		// ori instruction
						state <= EX_ori;
				else	
					if(Op == 6'b001000)		// Addi instruction
						state <= EX_Addi;
				else	
					if(Op == 6'b101011)	   // sw instruction
						state <= EX_sw;
				else	
					if(Op == 6'b000101)		// bne instruction
						state <= EX_bne;	
				else 
					if(Op == 6'b001001)		// Addiu instruction   
						state <= EX_Addiu;
				else 
					if(Op == 6'b001010)		// Slti instruction
						state <= EX_slti;
				else 
					if(Op == 6'b000100)		// beq instruction
						state <= EX_beq;
				else 
					if(Op == 6'b100011)		// lw instruction
						state <= EX_lw;				
				
//J type	---------------------------		
				
				else 
					if(Op == 6'b000011)		// Jal instruction
						state <= EX_jal;		
				else 
					if(Op == 6'b000010)		// J instruction
						state <= EX_j;
				
				
				
//R type	---------------------------		
				else
					if(Op == 6'b000000)	
					state <= EX;
				else
					state <= IF; 
				
				// Funct condition for R type ---------------------------
							EX: 
									if(Funct == 6'b000000)    // sll instruction
										state <= EX_sll;
							  	else 
									if(Funct == 6'b011000)    //  mult instruction
										state <= EX_mult;
								else
									if(Funct == 6'b001000)    //  jr instruction
										state <= EX_jr;
								else 
										state <= IF;
						
/******************************************************************************					
											I type
******************************************************************************/

// lui ---------------------
			
			EX_lui: 						   // load upper
				state <= WB_lui;
			WB_lui:							// write back
				state <= WB;
			WB:								// WB Extended
				state <= IF;

// ori ---------------------

			EX_ori:							// Or
				state <= WB_ori;
			WB_ori:							// write back
				state <= WB;	
			WB:								// WB Extended
				state <= IF;			
					

// addi ---------------------

			EX_Addi:							// Addition 								
				state <= WB_Addi;
			WB_Addi:							// write back
				state <= WB;	
			WB:							   // WB Extended
				state <= IF;

// sw ---------------------

			EX_sw:							// Rt Address calculation
				state <= Mem_sw;
			Mem_sw:							// Memory access						 
				state <= IF;
				
// lw ---------------------
		
			EX_lw:							// ALU sub
				state <= Mem_lw; 
			Mem_lw: 							// Memory access
				state <= Data_lw;
			Data_lw: 						// Register Data
				state <= WB_lw;
			WB_lw: 							// WB reg file
				state <= WB;
			WB:								// WB reg file extended
				state <= IF;

// bne ---------------------
			
			EX_bne:							// ALU substraction
				state <= PC_bne;		
			PC_bne:							// PC + 4  + <<2			
				state <= IF;

// beq ---------------------
			
			EX_beq:							// ALU substraction
				state <= PC_beq;		
			PC_beq:							// PC + 4  + <<2			
				state <= IF;
				
// addiu ---------------------

			EX_Addiu:						// ALU addition 								
				state <= WB_Addiu;
			WB_Addiu:						// writeback
				state <= WB;	
			WB:								//WB extended	  
				state <= IF;

// slti ---------------------

			EX_slti:							// ALU substraction
				state <= WB_slti; 
			WB_slti:							// writeback
				state <= WB;
			WB: 								// WB extended	  
				state <= IF;
				
		
/******************************************************************************					
												R type
******************************************************************************/			

//	sll ---------------------

			EX_sll:							// Shifting left <<2
				state <= WB_sll;
			WB_sll:							// write back
				state <= WB;
			WB:								//WB extended
				state <= IF;
				
// mult ---------------------
		
			EX_mult:							// Multiplication
				state <= WB_mult; 
			WB_mult:							// Write back
				state <= WB;
			WB:								//WB extended
				state <= IF;				
				
// jr ---------------------

			EX_jr:							// PC = RS
				state <= IF;

				
/******************************************************************************					
												J type
******************************************************************************/

// jal ---------------------
			
		
			EX_jal:							// PC = {PC+4[31:28],Address}
				state <= WB_jal;
			WB_jal:
				state <= IF_jal;
			IF_jal:
				state <= IF;
		
// j ---------------------				
			EX_j:								// PC = Address
				state <= IF;


// default ---------------------
					
			default
					state <= IF;

			endcase
end

/*************************************************************************
 Timing of signals for each state machine to be driven to Datapath
 there are states which can be eliminated but for this implementation
 they will be keep
*************************************************************************/

always@(state)begin
	case(state)
	
// IF --------------------------------------------------------------
			IF:
				begin
				PCWrite_reg = 		1'b1;		//1;		// Enabled PC
				IorD_reg = 			1'b0;		// PC address
				Ram_Rom_Reg = 		1'b0;	  	// Selecting Rom 
				MemWrite_reg = 	1'b0;    // No writing
				IRWrite_reg = 		1'b1;		// Enabled
				Data_reg = 			1'b0;    // Not enabled
				RegDst_reg = 		2'b00;	// Not matters
				MemtoReg_reg = 	2'b00;	// Not Matters
				RegWrite_reg = 	1'b0;		// 0   Not enabled 
				RegisterA_reg = 	1'b0;	   // Not enabled
				RegisterB_reg = 	1'b0;	   // Not enabled
				ALUSrcA_reg = 		1'b0;		// Zero to add 4 to PC
				ALUSrcB_reg = 		2'b01;	// 01 For value 4
				ALUControl_reg =  4'b0000;  // Addition 4 + PC
				ALUout_reg = 		1'b0;	 	// Not enabled	
				PCSrc_reg = 		1'b0;		// Selecting ALU result
				BneBranch_reg = 	1'b0;	   // Not used
				BeqBranch_reg = 	1'b0; 	// Not Used
				JumpCtrl_reg = 	1'b0;		// Not Used
				JumpOut_reg = 		1'b0;		// Not Used
				end
				
// ID --------------------------------------------------------------

			ID:
			   begin
				PCWrite_reg = 		1'b0;		// Not Enabled PC
				IorD_reg = 			1'b0;		// Not matters 
				Ram_Rom_Reg = 		1'b0;	  	// Selectiong Rom
				MemWrite_reg = 	1'b0;    // No writing
				IRWrite_reg = 		1'b0;		// Enabled
				Data_reg = 			1'b0;    // Not enabled
				RegDst_reg = 		2'b10;	// No matters
				MemtoReg_reg = 	2'b00;	// No Matters
				RegWrite_reg = 	1'b0;		// Not enabled 
				RegisterA_reg = 	1'b1;	   // Enabled
				RegisterB_reg = 	1'b1;	   // Enabled
				ALUSrcA_reg = 		1'b0;		// No matters
				ALUSrcB_reg = 		2'b00;	// No matters
				ALUControl_reg =  4'b0000;  // No matters
				ALUout_reg = 		1'b0;	 	// No matters	
				PCSrc_reg = 		1'b0;		// No matters
				BneBranch_reg = 	1'b0;	   // Not used
				BeqBranch_reg = 	1'b0; 	// Not Used
				JumpCtrl_reg = 	1'b0;		// Not Used
				JumpOut_reg = 		1'b0;		// Not Used
				end


/******************************************************************************					
											I type
******************************************************************************/
				
// lui --------------------------------------------------------------
		EX_lui:	
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		//  I type register rt destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b10;	//  Sign extend   
				ALUControl_reg =  4'b0111; //  
				ALUout_reg = 		1'b1;	 	//  Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end

				
		WB_lui:	
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		//  Enable address for the register 
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b10;	//      
				ALUControl_reg =  4'b0111;  //	  
				ALUout_reg = 		1'b0;	 	//  Not Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end		
			
					
// ori --------------------------------------------------------------				
		EX_ori:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// I type register rt destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		// /***** 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b10;	//  Sign extend   
				ALUControl_reg =  4'b0110; //  Or 
				ALUout_reg = 		1'b1;	 	//  Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
		WB_ori: 
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;	// 
				MemtoReg_reg = 	2'b00;	//  Enable address for the register 
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//   
				ALUSrcB_reg = 		2'b01;	//      
				ALUControl_reg =  4'b0110;  //	  
				ALUout_reg = 		1'b0;	 	//  Not Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end	
				
// Addi --------------------------------------------------------------	
		EX_Addi:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// I type register rt destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b10;	//  Sign extend   
				ALUControl_reg =  4'b0000; //  Addition
				ALUout_reg = 		1'b1;	 	//  Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
		WB_Addi:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		//  Enable address for the register 
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b01;	//      
				ALUControl_reg =  4'b0000;  //	  
				ALUout_reg = 		1'b0;	 	//  Not Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end				
				
// sw --------------------------------------------------------------					
		EX_sw:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b1;    // 0
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		//  I type register rt destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b10;	//  Sign extend   
				ALUControl_reg =  4'b0000; //  Addition
				ALUout_reg = 		1'b1;	 	//  Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
				
		Mem_sw:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b1;		// Access to memory
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b1;    // Enable writing to memory RAM 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//   
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   // 
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b00;	//      
				ALUControl_reg =  4'b0000; //	  
				ALUout_reg = 		1'b0;	 	//  
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end	

// Addiu --------------------------------------------------------------	
		EX_Addiu:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// I type register rt destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b10;	//  Sign extend   
				ALUControl_reg =  4'b0000; //  Addition
				ALUout_reg = 		1'b1;	 	//  Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
		WB_Addiu:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		//  Enable address for the register 
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b01;	//      
				ALUControl_reg =  4'b0000;  //	  
				ALUout_reg = 		1'b0;	 	//  Not Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end				
				
// lw --------------------------------------------------------------					
	
		EX_lw:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b1;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		//  I type register rt destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b10;	//  Sign extend   
				ALUControl_reg =  4'b0000; //  Addition
				ALUout_reg = 		1'b1;	 	//  Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
		
		Mem_lw:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b1;		//  Selecting 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b1;    //  Enabled RAM
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b1;    //  Enabled Data
				RegDst_reg = 		2'b00;		//  
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  
				ALUSrcB_reg = 		2'b10;	//   
				ALUControl_reg =  4'b0000; //  
				ALUout_reg = 		1'b0;	 	//   	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end		
		
		WB_lw:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		//  
				MemtoReg_reg = 	2'b01;		//  Data from RAM
				RegWrite_reg = 	1'b1;		//  Enabled register file 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//    
				ALUSrcB_reg = 		2'b10;	//     
				ALUControl_reg =  4'b0000; //  
				ALUout_reg = 		1'b0;	 	//  	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end		

	
// bne --------------------------------------------------------------						
		EX_bne:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   // 
				RegisterB_reg = 	1'b0;	   // 
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b00;	//  Source B   
				ALUControl_reg =  4'b0001;  // Substraction
				ALUout_reg = 		1'b0;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   //  
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
		PC_bne:
				begin
				PCWrite_reg = 		1'b1;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //   
				ALUSrcA_reg = 		1'b0;		//     
				ALUSrcB_reg = 		2'b11;	//    
				ALUControl_reg =  4'b0000; //   
				ALUout_reg = 		1'b0;	 	//   	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b1;	   //   
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end

// beq --------------------------------------------------------------	
		EX_beq:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   // 
				RegisterB_reg = 	1'b0;	   // 
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b00;	//  Source B   
				ALUControl_reg =  4'b0001;  // Substraction
				ALUout_reg = 		1'b0;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   //  
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
		PC_beq:
				begin
				PCWrite_reg = 		1'b1;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //   
				ALUSrcA_reg = 		1'b0;		//     
				ALUSrcB_reg = 		2'b11;	//    
				ALUControl_reg =  4'b0000; //   
				ALUout_reg = 		1'b0;	 	//   	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   //   
				BeqBranch_reg = 	1'b1; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
	
// slti --------------------------------------------------------------

			EX_slti:							
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;	// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   // 
				RegisterB_reg = 	1'b0;	   // 
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b10;	//  Source B   
				ALUControl_reg =  4'b1001;  // If Rs < SignExt
				ALUout_reg = 		1'b1;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   //  
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
			WB_slti:	
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;	//  Enable address for the register 
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b01;	//      
				ALUControl_reg =  4'b0000;  //	  
				ALUout_reg = 		1'b0;	 	//  Not Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end			
			
/******************************************************************************					
											R type
******************************************************************************/
				
// sll --------------------------------------------------------------						
		EX_sll:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b01;		//  R type register rd destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  Not enabled register A
				RegisterB_reg = 	1'b0;	   //  Enabled register B
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b00;	//  Source B   
				ALUControl_reg =  4'b1000;  // Shamt
				ALUout_reg = 		1'b1;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
		
		WB_sll:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b01;		// 
				MemtoReg_reg = 	2'b00;		//  
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b01;	//      
				ALUControl_reg =  4'b0000;  //	  
				ALUout_reg = 		1'b0;	 	//  	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end			
				
// mult --------------------------------------------------------------		
		
		EX_mult:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b01;		//  R type register rd destination
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  Source A  
				ALUSrcB_reg = 		2'b00;	//  Source B   
				ALUControl_reg =  4'b0010;  // Multiply
				ALUout_reg = 		1'b1;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
		
		WB_mult:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b01;		// 
				MemtoReg_reg = 	2'b00;		//  
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b01;	//      
				ALUControl_reg =  4'b0000;  //	  
				ALUout_reg = 		1'b0;	 	//  	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end

// jr --------------------------------------------------------------	


		EX_jr:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		//  
				MemtoReg_reg = 	2'b00;	// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//   
				ALUSrcB_reg = 		2'b00;	//    
				ALUControl_reg =  4'b0010; // 
				ALUout_reg = 		1'b0;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		//  0 to select jr
				JumpOut_reg = 		1'b1;		//  
				end
				
								
/******************************************************************************					
											J type
******************************************************************************/

// jal --------------------------------------------------------------	

				
		WB_jal:
				begin
				PCWrite_reg = 		1'b0;		// 0
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b10;	//  
				MemtoReg_reg = 	2'b10;	//  selected register 31 (ra)
				RegWrite_reg = 	1'b1;		//  enabled writing
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  
				ALUSrcB_reg = 		2'b00;	//    
				ALUControl_reg =  4'b0010; //
				ALUout_reg = 		1'b0;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b1;		// 
				JumpOut_reg = 		1'b1;		//  
				end
	
		EX_jal:
				begin
				PCWrite_reg = 		1'b0;		//
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b10;	//  register destination 31  
				MemtoReg_reg = 	2'b10;	//  reg 31
				RegWrite_reg = 	1'b1;		//  enabled writing
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//  
				ALUSrcB_reg = 		2'b00;	//    
				ALUControl_reg =  4'b0010; //
				ALUout_reg = 		1'b0;	 	// 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b1;		// 
				JumpOut_reg = 		1'b1;		//  
				end	

			IF_jal:
				begin
				PCWrite_reg = 		1'b0;		//1;		// Enabled PC
				IorD_reg = 			1'b0;		// PC address
				Ram_Rom_Reg = 		1'b0;	  	// Selecting Rom 
				MemWrite_reg = 	1'b0;    // No writing
				IRWrite_reg = 		1'b1;		// Enabled
				Data_reg = 			1'b0;    // Not enabled
				RegDst_reg = 		2'b10;	// Not matters
				MemtoReg_reg = 	2'b00;	// Not Matters
				RegWrite_reg = 	1'b0;		// 0   Not enabled 
				RegisterA_reg = 	1'b0;	   // Not enabled
				RegisterB_reg = 	1'b0;	   // Not enabled
				ALUSrcA_reg = 		1'b0;		// Zero to add 4 to PC
				ALUSrcB_reg = 		2'b01;	// 01 For value 4
				ALUControl_reg =  4'b0000;  // Addition 4 + PC
				ALUout_reg = 		1'b0;	 	// Not enabled	
				PCSrc_reg = 		1'b0;		// Selecting ALU result
				BneBranch_reg = 	1'b0;	   // Not used
				BeqBranch_reg = 	1'b0; 	// Not Used
				JumpCtrl_reg = 	1'b1;		// Not Used
				JumpOut_reg = 		1'b1;		// Not Used
				end
				

// j --------------------------------------------------------------	
	
		EX_j:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		2'b00;		// 
				MemtoReg_reg = 	2'b00;	// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b1;		//    
				ALUSrcB_reg = 		2'b00;	//    
				ALUControl_reg =  4'b0010; // 
				ALUout_reg = 		1'b0;	 	// 	
				PCSrc_reg = 		1'b1;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b1;		// 
				JumpOut_reg = 		1'b1;		//  
				end


// WB --------------------------------------------------------------	
			WB:	
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// ****
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		1'b0;		// 
				MemtoReg_reg = 	2'b00;	//  Enable address for the register 
				RegWrite_reg = 	1'b1;		//  Enabled writing 
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b10;	//      
				ALUControl_reg =  4'b0111;  //	  
				ALUout_reg = 		1'b0;	 	//  Not Enabled ALUout 	
				PCSrc_reg = 		1'b0;		// 
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end				
				
				
				
				
// default --------------------------------------------------------------	
		default:
				begin
				PCWrite_reg = 		1'b0;		// 
				IorD_reg = 			1'b0;		// 
				Ram_Rom_Reg = 		1'b0;	  	//  
				MemWrite_reg = 	1'b0;    // 
				IRWrite_reg = 		1'b0;		// 
				Data_reg = 			1'b0;    // 
				RegDst_reg = 		1'b0;		// 
				MemtoReg_reg = 	2'b00;		// 
				RegWrite_reg = 	1'b0;		//  
				RegisterA_reg = 	1'b0;	   //  
				RegisterB_reg = 	1'b0;	   //  
				ALUSrcA_reg = 		1'b0;		//   
				ALUSrcB_reg = 		2'b00;	//     
				ALUControl_reg =  4'b0000; //	  
				ALUout_reg = 		1'b0;	 	// 	
				PCSrc_reg = 		1'b0;		//
				BneBranch_reg = 	1'b0;	   // 
				BeqBranch_reg = 	1'b0; 	// 
				JumpCtrl_reg = 	1'b0;		// 
				JumpOut_reg = 		1'b0;		//  
				end
				
		endcase
end

// assiengments for the outputs

	assign IorD = IorD_reg; 				// Instruction or Data memory moduole
	assign Data = Data_reg;
	assign ALUout = ALUout_reg;
	assign Ram_Rom = Ram_Rom_Reg;			// Memory source selector
	assign MemWrite = MemWrite_reg; 		// Enable writing in memory
	assign IRWrite = IRWrite_reg; 		// Instruction to write to be decoded
	assign RegDst = RegDst_reg;			// Register Destination depening on I or R instruction
	assign MemtoReg = MemtoReg_reg;		// Memoty to Address register
	assign RegWrite =	RegWrite_reg;		// Enables writing in register file
	assign RegisterA = RegisterA_reg;
	assign RegisterB = RegisterB_reg;
	assign ALUSrcA = ALUSrcA_reg;			// 
	assign ALUSrcB = ALUSrcB_reg;       // 
	assign ALUControl = ALUControl_reg; // Operation to be excecuted by ALU
	assign PCSrc = PCSrc_reg; 			   // Program counter added while Instruction fetch
	assign BneBranch = BneBranch_reg;	// Branch bne
	assign BeqBranch = BeqBranch_reg;   // Branch beq
	assign PCWrite = PCWrite_reg;    	// Enable to write on Program counter register
	assign JumpCtrl = JumpCtrl_reg;		// Multiplexion between Jr and J
	assign JumpOut = JumpOut_reg; 		// Multiplexion for Jar and Jr or J



endmodule
