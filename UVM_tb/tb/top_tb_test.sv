/***********************************************************************
 * A dual-top approach has been used to make it emulation friendly
 * The top_tb (testbench) contains the complete UVM environment
 **********************************************************************/

module top_tb_test;
  timeunit 1ns; timeprecision 10ps;

  import uvm_pkg::*;              
  import uart_class_package::*;   

  initial begin 
    $timeformat(-9,0,"ns",6);

    uvm_config_db #(virtual tb_ifc)::set(null, "uvm_test_top", "vif", top_hdl_test.tb_if);
    
    run_test(); //starting the test via the testname switch passed in
  end 

endmodule: top_tb_test