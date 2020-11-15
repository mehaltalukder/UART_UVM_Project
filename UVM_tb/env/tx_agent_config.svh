
`ifndef tx_agent_config_exists
`define tx_agent_config_exists


class tx_agent_config extends uvm_object;


  `uvm_object_utils(tx_agent_config)

  uvm_active_passive_enum    active            = UVM_PASSIVE;
  int                        monitor_verbosity = UVM_DEBUG;
  bit                        enable_coverage   = 1;
  int                        num_items         = 1;
  uvm_sequencer #(tx_in)     tx_sqr;
  virtual tb_ifc             vif;

  function new(string name="tx_agent_config");
    super.new(name);
  endfunction: new

endclass: tx_agent_config
`endif