/****************************************************************************************
*****************************************************************************************
Name: 
	Memory_Map
	
Description: 
	

Subject:
	Microprocessors Design - ITESO

Author:
	Cesar Carlos Robles Martinez 

Date:
	14/04/2019
*****************************************************************************************
*****************************************************************************************/
module Memory_Map

#(
parameter WORD_LENGTH = 8
)

(
//inputs
	input [WORD_LENGTH -1 : 0] AddressIn,

//outputs

  output enablePort,
  output enableUART 
);


wire [1:0]sel_wire;

// GPIO

Comparator

#(
.WORD_LENGTH(WORD_LENGTH)
)

Address_Port

(
//Inputs
    .AddressIn(AddressIn),

//Outputs
	 .enablePort(enablePort)

);


//UART

Comparator

#(
.WORD_LENGTH(WORD_LENGTH)
)

Address_UART

(
//Inputs
    .AddressIn(AddressIn),

//Outputs
	 .enablePort(enableUART)

);


endmodule
