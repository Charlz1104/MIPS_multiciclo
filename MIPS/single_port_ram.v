/****************************************************************************************
*****************************************************************************************
Name: 
	single_port_ram
	
Description: 
	This is a RAM memory

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/
// Quartus II Verilog Template
// Single port RAM with single read/write address 

module single_port_ram 
#(
parameter DATA_WIDTH=32, 
parameter ADDR_WIDTH=512
)

(
//inputs
	input [DATA_WIDTH -1:0] data,
	input [ADDR_WIDTH -1:0] addr,
	input we, 
	input clk,
//outputs	
	output [DATA_WIDTH -1:0] q
);

/**************************************************************************
RAM

Due the limitations of the internal Rom that can be managed by the FPGA, it
is needed to reduces the words for the implementation

it is taken the 32 address-with and are only taken the 7:0 bits to calculate
the address, the deep to the RAM will be changed depending on the implementation
required 

**************************************************************************/

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[ADDR_WIDTH-1:0];
		
	wire [7:0]addr_real;	

	assign addr_real = addr [7:0] >> 2;
	
	// Variable to hold the registered read address
	reg [ADDR_WIDTH-1:0] addr_logic;

	always @ (posedge clk)
	begin
		// Write
		if (we) //addr
			ram[addr_real] <= data;

		addr_logic <= addr_real;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign q = ram[addr_logic];

endmodule
