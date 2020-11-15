`ifndef alu_monitor_exists
`define alu_monitor_exists


class uart_monitor extends uvm_monitor;

  `uvm_component_utils(uart_monitor)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  tx_agent_config tx_agent_cfg;
  virtual tb_ifc vif;  

  uvm_analysis_port #(tx_in) dut_in_tx_port; 
  uvm_analysis_port #(tx_out)  dut_out_tx_port;

  virtual function void build_phase(uvm_phase phase);

    dut_in_tx_port  = new("dut_in_tx_port", this);  
    dut_out_tx_port = new("dut_out_tx_port", this); 

    if (!uvm_config_db #(tx_agent_config)::get(this,"","tx_agent_cfg",tx_agent_cfg))
      `uvm_fatal(get_type_name(), "Failed to get tx_agent_config from uvm_config_db")
    vif = tx_agent_cfg.vif;
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    fork
      get_inputs();
      get_outputs();
    join
  endtask

  task get_inputs();
    tx_in tx;
    forever begin
      tx = tx_in::type_id::create("tx");
       vif.get_an_input(tx);   
      `uvm_info("TX_IN", tx.convert2string(), UVM_DEBUG) 
      dut_in_tx_port.write(tx);
    end
  endtask

  task get_outputs();
    tx_out  tx;
    forever begin
      begin
      tx = tx_out::type_id::create("tx");
      vif.get_an_output(tx);
      `uvm_info("TX_OUT", tx.convert2string(), UVM_DEBUG)
      dut_out_tx_port.write(tx);
     end
    end
  endtask

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    set_report_verbosity_level(tx_agent_cfg.monitor_verbosity);
  endfunction: end_of_elaboration_phase

endclass: uart_monitor
`endif