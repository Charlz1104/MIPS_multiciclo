/****************************************************************************************
*****************************************************************************************
Name:
	MultiplexerForGenerate

Description:


Author:
	Cesar Carlos Robles Martinez 

Date: 	
	14/04/2019

*****************************************************************************************
*****************************************************************************************/
module MultiplexerForGenerate
#(
	parameter Word_Length = 1
)
(
	input Selector,
	input  [Word_Length-1 : 0] Data_0,
	input  [Word_Length-1 : 0] Data_1,

	
	output [Word_Length-1 : 0] Mux_Output_Reg_1,
	output [Word_Length-1 : 0] Mux_Output_Reg_2

);


/* Mux_Reg_1*/

genvar i;

generate
	for(i=0;i<=Word_Length-1; i = i + 1) begin:Multiplexers_Reg_1

		Mux2to1
		MUXUnit
		(
			// Input Ports
			.Selector(Selector),
			.Data_0(Data_0[i]),
			.Data_1(Data_1[i]),
			
			// Output Ports
			.Mux_Output(Mux_Output_Reg_1[i])

		);
	end
endgenerate

/*Mux_Reg_2*/
genvar j;

generate
	for(j=0;j<=Word_Length-1; j = j + 1) begin:Multiplexers_Reg_2

		Mux2to1
		MUXUnit
		(
			// Input Ports
			.Selector(Selector),
			.Data_0(Data_0[j]),
			.Data_1(Data_1[j]),
			
			// Output Ports
			.Mux_Output(Mux_Output_Reg_2[j])

		);
	end
endgenerate




endmodule



