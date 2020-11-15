`ifndef alu_coverage_collector_exists
`define alu_coverage_collector_exists


class uart_coverage extends uvm_subscriber #(tx_in);

  tx_in tx; 

  covergroup cg_UART_inputs;
    option.per_instance = 1;
    option.name = "cg_UART_inputs";
    option.at_least = 64;

    TX_in: coverpoint tx.i_TX_Byte {
           bins quad1  = { [0:63] };
           bins quad2 = { [64:127] };
           bins quad3 = { [128:191] };
           bins quad4 = { [192:255] };
           //option.weight = 0;
    }
    
  endgroup: cg_UART_inputs

  `uvm_component_utils(uart_coverage)
  function new(string name, uvm_component parent );
    super.new(name, parent);
    cg_UART_inputs = new();  
  endfunction: new


  function void write(tx_in t);
    tx = t;  
    cg_UART_inputs.sample();
  endfunction: write

  virtual function void report_phase(uvm_phase phase);
    `uvm_info("COVERAGE", $sformatf("\n\n\t Functional coverage = %2.2f%%\n",
                                         cg_UART_inputs.get_inst_coverage()), UVM_NONE)
  endfunction: report_phase

endclass: uart_coverage
`endif