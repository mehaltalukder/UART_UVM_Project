/***********************************************************************
 * SV top-level module that connects the testbench to DUT
 * A dual-top approach has been used to make it emulation friendly
 * The top_hdl (hardware description language) includes the interface and DUT
 **********************************************************************/

module top_hdl_test();
  timeunit 1ns; timeprecision 10ps;

  logic clk;

  tb_ifc tb_if (.clk(clk));

  UART dut (.clk(clk),
            .i_TX_Data_Valid(tb_if.i_TX_Data_Valid),
            .i_TX_Byte(tb_if.i_TX_Byte),
            .o_RX_Data_Valid(tb_if.o_RX_Data_Valid),
            .o_RX_Byte(tb_if.o_RX_Byte),
            .o_TX_Done(tb_if.o_TX_Done)
  );

  initial begin
    clk <= 0;
    forever #20 clk = ~clk;
  end

endmodule: top_hdl_test