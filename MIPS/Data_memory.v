/****************************************************************************************
*****************************************************************************************
Name: 
	Data_memory
	
Description: 
	This module createas a mapping address for the Stack (RAM,ROM and Periphelas,
it helps to mapping the address instruction for the connecting port to be
used for the MIPS

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/



module Data_memory

#(
parameter WORD_LENGTH_32 =32,
parameter WORD_LENGTH =32
)

(
//Input ports
input clk,
input sel,
input [WORD_LENGTH_32 -1 :0] data,
input [WORD_LENGTH_32 -1 :0] addr,
input we,

//Output ports
output [WORD_LENGTH_32 -1 :0] q,
output [WORD_LENGTH_32 -1 :0] Port,
output [WORD_LENGTH_32 -1 :0] UART,
output enablePort,
output enableUART
);


/*******************************************************************************
											NETS LIST 															
*******************************************************************************/

wire [WORD_LENGTH_32 -1 :0] ROM_wire;
wire [WORD_LENGTH_32 -1 :0] RAM_wire;
wire [1:0]sel_wire;

wire [WORD_LENGTH_32 -1 :0] addr_wire;

assign Port = RAM_wire;

/*******************************************************************************
											CODE 															
*******************************************************************************/

//************  ROM   ************//

single_port_rom

#(
.DATA_WIDTH(WORD_LENGTH_32),
.ADDR_WIDTH(WORD_LENGTH)
)

ROM_Memory

(
	.addr(addr),
	.clk(clk), 
	.q(ROM_wire)
	
);

//************  RAM   ************//
single_port_ram

#(
.DATA_WIDTH(WORD_LENGTH_32),
.ADDR_WIDTH(WORD_LENGTH)
)

RAM_Memory

(
	.data(data),
	.addr(addr),
	.we(we), 
	.clk(clk),
	.q(RAM_wire)
	
);

//************  Mux   ************//

Mux2to1

#(
.WORD_LENGTH(WORD_LENGTH_32)
)

Mux_IorD

(
	.Selector(sel),
	.MUX_Data0(ROM_wire),
	.MUX_Data1(RAM_wire),
	
	.MUX_Output(q)

);
//***********************//
Memory_Map


#(
.WORD_LENGTH(WORD_LENGTH_32)
)

P_GPIO
(
//inputs
	.AddressIn(addr),

//outputs

  .enablePort(enablePort)
  
);

//***********************//
Memory_Map


#(
.WORD_LENGTH(WORD_LENGTH_32)
)

P_UART

(
//inputs
	.AddressIn(addr),

//outputs

  .enableUART(enableUART)
  
);


endmodule
