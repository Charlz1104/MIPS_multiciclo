/****************************************************************************************
*****************************************************************************************
Name: 
	Demux4to1
	
Description: 
	This is a Demux 1 to 4

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

module Demux4to1

#(
parameter WORD_LENGTH = 8
)

(
//Inputs
    input [WORD_LENGTH -1 : 0]Data_in,
    input [1:0] sel,
//Outputs
    output [WORD_LENGTH -1 : 0] Data_out_0,
    output [WORD_LENGTH -1 : 0] Data_out_1,
    output [WORD_LENGTH -1 : 0] Data_out_2,
    output [WORD_LENGTH -1 : 0] Data_out_3
);

/****************************************************************/
    reg [WORD_LENGTH -1 : 0] Data_out_0_reg;
    reg [WORD_LENGTH -1 : 0] Data_out_1_reg;
    reg [WORD_LENGTH -1 : 0] Data_out_2_reg;
    reg [WORD_LENGTH -1 : 0] Data_out_3_reg;  

/****************************************************************/
	 
    always @(Data_in or sel)
    begin
        case (sel)  
		  
            2'b00 : begin
                        Data_out_0_reg = Data_in;
                        Data_out_1_reg = 0;
                        Data_out_2_reg = 0;
                        Data_out_3_reg = 0;
                      end
            2'b01 : begin
                        Data_out_0_reg = 0;
                        Data_out_1_reg = Data_in;
                        Data_out_2_reg = 0;
                        Data_out_3_reg = 0;
                      end
            2'b10 : begin
                        Data_out_0_reg = 0;
                        Data_out_1_reg = 0;
                        Data_out_2_reg = Data_in;
                        Data_out_3_reg = 0;
                      end
            2'b11 : begin
                        Data_out_0_reg = 0;
                        Data_out_1_reg = 0;
                        Data_out_2_reg = 0;
                        Data_out_3_reg = Data_in;
                      end
        endcase
    end
	 
assign Data_out_0 = Data_out_0_reg;
assign Data_out_1 = Data_out_1_reg;
assign Data_out_2 = Data_out_2_reg;
assign Data_out_3 = Data_out_3_reg;
 
endmodule

