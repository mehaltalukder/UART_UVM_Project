`ifndef env_config_exists
`define env_config_exists


class env_config extends uvm_object;

  `uvm_object_utils(env_config)
  function new(string name="env_config");
    super.new(name);
  endfunction: new

  tx_agent_config tx_agent_cfg;
  bit enable_scoreboard = 1;

endclass: env_config
`endif