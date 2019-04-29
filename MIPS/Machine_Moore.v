/**********************************************************************************
*	Description:
*	 This is a moore state machine
*	Inputs:
*		input clk
*		input reset
*		input enable
*		input Signal_on,  // Signal counter on state
*		input Signal_off,	// Signal counter off state		
*
*	Outputs:
*     output reg Enable
*
*	Author:
*	 Cesar Carlos Robles Martinez
*
*	Date:
*	 17/09/2017
***********************************************************************************/
module Machine_Moore

(
//Input
	input clk,
	input reset,
	input start,

	
//Output
	output IorD,
	output Mem_Write,
	output IR_Write,
	output Reg_Dst,
	output Memt_Reg,
	output Reg_Write,
	output ALUSrcA,
	output ALUSrcB,
	output ALU_Control,
	output PCsrc,
	output Branch,
	output PC_write
	
);

localparam IDLE = 0;		// idle state
localparam IF = 1;		// Instruction Fecth
localparam ID = 2; 		// Instruction Decode & Register file read                   
localparam EX = 3;		// Execute & Address calculation                 
localparam MEM = 4; 		// Memory access
localparam WB = 5;		// Write Back


reg [1:0]State;

	reg IorD_reg;
	reg Mem_Write_reg;
	reg IR_Write_reg;
	reg Reg_Dst_reg;
	reg Memt_Reg_reg;
	reg Reg_Write_reg;
	reg ALUSrcA_reg;
	reg ALUSrcB_reg;
	reg ALU_Control_reg;
	reg PCsrc_reg;
	reg Branch_reg;
	reg PC_write_reg;

always@(posedge clk or negedge reset) begin
	if (reset== 0)
		State <= IDLE;
	else 
		case(State)
		
			IDLE:
			if(start == 1'b1)
				State <= IF;
			else 
				State <= IDLE;
							
			IF:
			if(start == 1'b1)
				State <= ID;
			else
				State <= IF;
							
			ID:
			if(start == 1'b1)
				State <= EX;
			else
				State <= ID;
	
			EX:
			if(start == 1'b1)
				State <= MEM;
			else
				State <= EX;
				
			MEM:
			if(start == 1'b1)
				State <= EX;
			else
				State <= ID;			
			
			WB:
			if(start == 1'b1)
				State <= EX;
			else
				State <= ID;
			
					
			default:
				State <= IDLE;
					
	endcase
end

always@(State)begin
	case(State)
	
			IDLE:
				begin
				IorD_reg = 1'b0;
				Mem_Write_reg = 1'b0;
				IR_Write_reg = 1'b0;
				Reg_Dst_reg = 1'b0;
				Memt_Reg_reg = 1'b0;
				Reg_Write_reg = 1'b0;
				ALUSrcA_reg = 1'b0;
				ALUSrcB_reg = 1'b0;
				ALU_Control_reg = 1'b0;
				PCsrc_reg = 1'b0;
				Branch_reg = 1'b0;
				PC_write_reg = 1'b0;
				end
			
			IF:
				begin
				IorD_reg = 1'b0;
				Mem_Write_reg = 1'b0;
				IR_Write_reg = 1'b1;
				Reg_Dst_reg = 1'b0;
				Memt_Reg_reg = 1'b0;
				Reg_Write_reg = 1'b0;
				ALUSrcA_reg = 1'b0;
				ALUSrcB_reg = 2'b01;
				ALU_Control_reg = 2'b10;
				PCsrc_reg = 1'b0;
				Branch_reg = 1'b0;
				PC_write_reg = 1'b1;
				end 
				
			ID:
				begin
				IorD_reg = 1'b0;
				Mem_Write_reg = 1'b0;
				IR_Write_reg = 1'b0;
				Reg_Dst_reg = 1'b0;
				Memt_Reg_reg = 1'b0;
				Reg_Write_reg = 1'b0;
				ALUSrcA_reg = 1'b0;
				ALUSrcB_reg = 1'b0;
				ALU_Control_reg = 1'b0;
				PCsrc_reg = 1'b0;
				Branch_reg = 1'b0;
				PC_write_reg = 1'b0;
				end
				
			EX:
				begin
				IorD_reg = 1'b0;
				Mem_Write_reg = 1'b0;
				IR_Write_reg = 1'b0;
				Reg_Dst_reg = 1'b0;
				Memt_Reg_reg = 1'b0;
				Reg_Write_reg = 1'b0;
				ALUSrcA_reg = 1'b0;
				ALUSrcB_reg = 1'b0;
				ALU_Control_reg = 1'b0;
				PCsrc_reg = 1'b0;
				Branch_reg = 1'b0;
				PC_write_reg = 1'b0;
				end
				
			MEM:
				begin
				IorD_reg = 1'b0;
				Mem_Write_reg = 1'b0;
				IR_Write_reg = 1'b0;
				Reg_Dst_reg = 1'b0;
				Memt_Reg_reg = 1'b0;
				Reg_Write_reg = 1'b0;
				ALUSrcA_reg = 1'b0;
				ALUSrcB_reg = 1'b0;
				ALU_Control_reg = 1'b0;
				PCsrc_reg = 1'b0;
				Branch_reg = 1'b0;
				PC_write_reg = 1'b0;
				end
				
				
			WB:
				begin
				IorD_reg = 1'b0;
				Mem_Write_reg = 1'b0;
				IR_Write_reg = 1'b0;
				Reg_Dst_reg = 1'b0;
				Memt_Reg_reg = 1'b0;
				Reg_Write_reg = 1'b0;
				ALUSrcA_reg = 1'b0;
				ALUSrcB_reg = 1'b0;
				ALU_Control_reg = 1'b0;
				PCsrc_reg = 1'b0;
				Branch_reg = 1'b0;
				PC_write_reg = 1'b0;
				end
				
			default:
				begin
				IorD_reg = 1'b0;
				Mem_Write_reg = 1'b0;
				IR_Write_reg = 1'b0;
				Reg_Dst_reg = 1'b0;
				Memt_Reg_reg = 1'b0;
				Reg_Write_reg = 1'b0;
				ALUSrcA_reg = 1'b0;
				ALUSrcB_reg = 1'b0;
				ALU_Control_reg = 1'b0;
				PCsrc_reg = 1'b0;
				Branch_reg = 1'b0;
				PC_write_reg = 1'b0;
				
				end
				
		endcase
end

	assign IorD = IorD_reg;
	assign Mem_Write = Mem_Write_reg;
	assign IR_Write = IR_Write_reg;
	assign Reg_Dst = Reg_Dst_reg;
	assign Memt_Reg = Memt_Reg_reg;
	assign Reg_Write = Reg_Write_reg;
	assign ALUSrcA = ALUSrcA_reg;
	assign ALUSrcB = ALUSrcB_reg;
	assign ALU_Control = ALU_Control_reg;
	assign PCsrc = PCsrc_reg;
	assign Branch = Branch_reg;
	assign PC_write = PC_write_reg;

endmodule