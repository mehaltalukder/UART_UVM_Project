`ifndef alu_agent_exists
`define alu_agent_exists


class uart_agent extends uvm_agent;

  `uvm_component_utils(uart_agent) 
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  uvm_analysis_port #(tx_in) dut_in_tx_port;
  uvm_analysis_port #(tx_out)  dut_out_tx_port;

  uvm_sequencer#(tx_in)     sqr;
  uart_driver                drv;
  uart_monitor               mon;
  uart_coverage              cov;
  tx_agent_config           tx_agent_cfg;

  virtual function void build_phase(uvm_phase phase);
    dut_in_tx_port  = new("dut_in_tx_port",  this);
    dut_out_tx_port = new("dut_out_tx_port", this);

    if (!uvm_config_db #(tx_agent_config)::get(this, "", "tx_agent_cfg", tx_agent_cfg))
      `uvm_fatal(get_type_name(), "Unable to find tx_agent_cfg in uvm_config_db")

    mon = uart_monitor::type_id::create("mon", this);     
    if (tx_agent_cfg.active == UVM_ACTIVE) begin
      sqr = new("sqr", this);
      drv = uart_driver::type_id::create("drv", this);    
    end

    tx_agent_cfg.tx_sqr = this.sqr;

    if (tx_agent_cfg.enable_coverage)
      cov = uart_coverage::type_id::create("cov", this);  

  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);

    mon.dut_in_tx_port.connect(dut_in_tx_port);
    mon.dut_out_tx_port.connect(dut_out_tx_port);

    if (tx_agent_cfg.active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export); 
    end

    if (tx_agent_cfg.enable_coverage)
      mon.dut_in_tx_port.connect(cov.analysis_export); 

  endfunction: connect_phase

endclass: uart_agent
`endif