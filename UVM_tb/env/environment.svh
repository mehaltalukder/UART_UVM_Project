`ifndef alu_env_exists
`define alu_env_exists


class uart_env extends uvm_env;

  `uvm_component_utils(uart_env)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

    uart_agent      agt;
    uart_scoreboard scb;
    env_config env_cfg;

  virtual function void build_phase(uvm_phase phase);
    agt = uart_agent::type_id::create("agt", this);

    if (!uvm_config_db #(env_config)::get(this, "", "env_cfg", env_cfg))
      `uvm_fatal(get_type_name(), "env_cfg not found in uvm_config_db")

     uvm_config_db#(tx_agent_config)::set(this, "agt*", "tx_agent_cfg", env_cfg.tx_agent_cfg);

     if (env_cfg.enable_scoreboard)
      scb = uart_scoreboard::type_id::create("scb", this);

  endfunction: build_phase

   virtual function void connect_phase(uvm_phase phase);

    if (env_cfg.enable_scoreboard) begin
      agt.dut_in_tx_port.connect(scb.dut_in_imp_export);
      agt.dut_out_tx_port.connect(scb.dut_out_imp_export);
    end

  endfunction: connect_phase

endclass: uart_env
`endif