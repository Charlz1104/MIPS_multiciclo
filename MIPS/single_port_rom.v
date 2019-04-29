/****************************************************************************************
*****************************************************************************************
Name: 
	single_port_rom
	
Description: 
	This is a ROM memory

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/

// Quartus II Verilog Template
// Single Port ROM

module single_port_rom
#(
parameter DATA_WIDTH=32, 
parameter ADDR_WIDTH=512

)
(
//inputs
	input [ADDR_WIDTH -1 : 0] addr,
	input clk,
	
//outputs
	output reg [DATA_WIDTH- 1 : 0] q
//	
);

/**************************************************************************
ROM

Due the limitations of the internal Rom that can be managed by the FPGA, it
is needed to reduces the words for the implementation

it is taken the 32 address-with and are only taken the 7:0 bits to calculate
the address 

**************************************************************************/	
	reg [DATA_WIDTH-1:0] rom[ADDR_WIDTH-1:0];
	
	wire [7:0]addr_real; 
 	
	assign addr_real = addr [7:0] >> 2;
	
	
	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	initial
	begin
		$readmemb("Practica_factorial.txt", rom);  //      MIPS_Imp
	end

	always @ (*)
	begin
		q = rom[addr_real];
	end

endmodule
