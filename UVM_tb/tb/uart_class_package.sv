/***********************************************************************
 * This package encapsulates all of the classes that make up the UVM testbench
 * If you are using edaplayground to run this, just remove the "../file/" section and include the uart_class_package.sv in the top_tb_test.sv module (testbench module in edaplayground)
 **********************************************************************/
`ifndef uart_class_package_exists
`define uart_class_package_exists

package uart_class_package;
  timeunit 1ns; timeprecision 10ps;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  typedef class simple_test;
  typedef class uart_env;
  typedef class env_config;
  typedef class tx_agent_config;
  typedef class uart_agent;
  typedef class tx_base;
  typedef class tx_in;
  typedef class tx_out;
  typedef class uart_driver;
  typedef class uart_monitor;
  typedef class uart_scoreboard;
  typedef class uart_coverage;
  typedef class write_tx_sequence;

  `include "../tests/simple_test.svh"
  `include "../env/environment.svh"
  `include "../env/env_config.svh"
  `include "../env/tx_agent_config.svh"
  `include "../env/agent.svh"
  `include "../env/tx_base.svh"
  `include "../env/tx_in.svh"
  `include "../env/tx_out.svh"
  `include "../env/driver.svh"
  `include "../env/monitor.svh"
  `include "../env/scoreboard.svh"
  `include "../env/coverage_collector.svh"
  `include "../env/write_tx_sequence.svh"

endpackage: uart_class_package
`endif
