`ifndef simple_test_exists
`define simple_test_exists


class simple_test extends uvm_test;

  `uvm_component_utils(simple_test)
  function new(string name, uvm_component parent);
    super.new (name, parent);
  endfunction: new

  uart_env env;   

  virtual function void build_phase(uvm_phase phase);

    env_config env_cfg;
    tx_agent_config tx_agent_cfg;
    virtual tb_ifc vif;

    if (!uvm_config_db #(virtual tb_ifc)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Failed to get virtual interface from uvm_config_db")

    env_cfg = env_config::type_id::create("env_cfg");
    tx_agent_cfg = tx_agent_config::type_id::create("tx_agent_cfg");

    env_cfg.tx_agent_cfg = tx_agent_cfg;
    tx_agent_cfg.enable_coverage = 1;
    tx_agent_cfg.active = UVM_ACTIVE;
    tx_agent_cfg.vif = vif;
    tx_agent_cfg.monitor_verbosity = UVM_DEBUG;  

    uvm_config_db #(env_config)::set(this, "env", "env_cfg", env_cfg);

    env = uart_env::type_id::create("env", this);

  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);

    write_tx_sequence seq;

    `uvm_info("TEST", "\n\n\n****** Generating Transactions ******\n\n", UVM_NONE)

    phase.phase_done.set_drain_time(this, 10); 
    phase.raise_objection(this, $sformatf("%m"));
    seq = write_tx_sequence::type_id::create("seq");
    seq.start(env.agt.sqr);
    phase.drop_objection(this, $sformatf("%m"));
     
  endtask: run_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    $display("\n"); 
    uvm_top.print_topology();  
  endfunction: end_of_elaboration_phase

endclass: simple_test
`endif