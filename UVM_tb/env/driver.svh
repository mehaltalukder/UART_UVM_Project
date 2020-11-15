
`ifndef alu_driver_exists
`define alu_driver_exists


class uart_driver extends uvm_driver #(tx_in);

  `uvm_component_utils(uart_driver)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual tb_ifc vif;  

  virtual function void build_phase(uvm_phase phase);
    tx_agent_config tx_agent_cfg;

    if (!uvm_config_db #(tx_agent_config)::get(this,"","tx_agent_cfg",tx_agent_cfg))
      `uvm_fatal(get_type_name(), "Failed to get tx_agent_cfg from uvm_config_db")
    vif = tx_agent_cfg.vif;
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    tx_in tx;
    forever begin
      seq_item_port.get_next_item(tx);
      vif.transfer(tx);
      seq_item_port.item_done();
    end
  endtask: run_phase

endclass: uart_driver
`endif