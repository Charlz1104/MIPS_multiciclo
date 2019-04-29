/****************************************************************************************
*****************************************************************************************
Name: 
	MIPS_TB
	
Description: 
	Test Bench for the MIPS

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/
module MIPS_TB;

parameter WORD_LENGTH_32_TB = 32;
parameter WORD_LENGTH_16_TB = 16;
parameter WORD_LENGTH_TB = 5;



//inputs

	reg clk_tb = 0;
	reg reset_tb;
	reg enable_tb = 0;
	
// outputs	
	wire [7 : 0] GPIO_tb;
	wire [7 : 0] UART_tb;



MIPS
#(
 .WORD_LENGTH_32(WORD_LENGTH_32_TB),
 .WORD_LENGTH_16(WORD_LENGTH_16_TB),
 .WORD_LENGTH(WORD_LENGTH_TB)
	
)

DUV

(

	.clk(clk_tb),
	.reset(reset_tb),
	.enable(enable_tb),	
	.GPIO(GPIO_tb),
	.UART(UART_tb)
);


/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk_tb = !clk_tb;
  end
/*********************************************************/
initial begin // reset generator
   #0 reset_tb = 0;
   #3 reset_tb = 1;
end

endmodule
