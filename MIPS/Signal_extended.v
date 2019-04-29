/****************************************************************************************
*****************************************************************************************
Name: 
	Signal_extended
	
Description: 
	This is used to extend the 15:0 bits from the Instruction and gives a 32 bit wide
	sign extended data

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module Signal_extended

#(
	parameter WORD_LENGTH = 16,
	parameter WORD_LENGTH_32 = 32
)

/********************************************/

(
	input [WORD_LENGTH - 1 : 0] Data,
	
	output [WORD_LENGTH_32 - 1 : 0] Output

);

/********************************************/

wire [WORD_LENGTH -1 : 0] ones_wire;
wire [WORD_LENGTH -1 : 0] zeros_wire;

assign zeros_wire = 16'b0000_0000_0000_0000;
assign ones_wire = 16'b1111_1111_1111_1111;


/********************************************/

reg [WORD_LENGTH_32 - 1 : 0] Data_reg;

	always@(Data) begin
	
		if(Data[15] == 1'b1)
			Data_reg = {ones_wire,Data};
		else
			Data_reg = {zeros_wire,Data};
	end
	
assign Output = Data_reg;


endmodule