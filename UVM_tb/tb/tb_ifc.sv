/***********************************************************************
 * The interface is used to connect the testbench to the DUT
 **********************************************************************/

interface tb_ifc (input logic clk);
  timeunit 1ns; timeprecision 10ps;


  bit           i_TX_Data_Valid; // enable control
  bit   [7:0]   i_TX_Byte;       //input
  logic         o_RX_Data_Valid; //rx output status
  logic [7:0]   o_RX_Byte;       //output
  logic         o_TX_Done;       // tx output status

  task transfer(uart_class_package::tx_in tx);
    @(posedge clk);
    #1ns;
    i_TX_Data_Valid   <= tx.i_TX_Data_Valid;
    i_TX_Byte         <= tx.i_TX_Byte;
  
    @(posedge o_RX_Data_Valid);
    @(posedge o_TX_Done);
  
  endtask

  task get_an_input(uart_class_package::tx_in tx_input);
    @(posedge clk)
    @(posedge clk)
    tx_input.i_TX_Data_Valid   = i_TX_Data_Valid;
    tx_input.i_TX_Byte         = i_TX_Byte;
    @(posedge o_TX_Done);
  
  endtask

  task get_an_output(uart_class_package::tx_out tx_output);
     
      @(posedge o_TX_Done);
      
      tx_output.o_RX_Data_Valid   = o_RX_Data_Valid;
      tx_output.o_RX_Byte         = o_RX_Byte;
      tx_output.o_TX_Done         = o_TX_Done;

  endtask

endinterface: tb_ifc