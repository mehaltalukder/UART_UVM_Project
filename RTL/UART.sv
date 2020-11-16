/***********************************************************************
 * This file includes the UART Transmitter (TX) and Receiver (RX)
 * CLOCKS_PER_BIT is the number of clock cycles required to send 1 byte
 * CLOCKS_PER_BIT = (Frequency of clk)/(Frequency of UART)
 * Example: 25 MHz Clock, 115200 baud rate (bits per second) of UART
 * CLOCKS_PER_BIT = (25000000)/(115200) = 217
***********************************************************************/

module UART (input logic clk,
             input logic i_TX_Data_Valid,
             input logic [7:0] i_TX_Byte,
             output logic o_RX_Data_Valid,
             output logic [7:0] o_RX_Byte,
             output logic o_TX_Done);

  wire w_TX_Active, w_UART_Line;
  wire w_TX_Serial, w_RX_DV;
  wire [7:0] w_RX_Byte;

  parameter c_CLOCK_PERIOD_NS = 40;
  parameter c_CLOCKS_PER_BIT  = 217;
  parameter c_BIT_PERIOD      = 8600;

  UART_RX #(.CLOCKS_PER_BIT(c_CLOCKS_PER_BIT)) UART_Receiver
    (.clk(clk),
     .i_RX_Serial(w_UART_Line),
     .o_RX_Data_Valid(o_RX_Data_Valid),
     .o_RX_Byte(o_RX_Byte)
     );

  UART_TX #(.CLOCKS_PER_BIT(c_CLOCKS_PER_BIT)) UART_Transmitter
    (.clk(clk),
     .i_TX_Data_Valid(i_TX_Data_Valid),
     .i_TX_Byte(i_TX_Byte),
     .o_TX_Active(w_TX_Active),
     .o_TX_Serial(w_TX_Serial),
     .o_TX_Done(o_TX_Done)
     );

  assign w_UART_Line = w_TX_Active ? w_TX_Serial : 1'b1;
  //assign o_RX_Data_Valid = w_RX_DV;
  //assign o_RX_Byte = w_RX_Byte;

endmodule: UART 


