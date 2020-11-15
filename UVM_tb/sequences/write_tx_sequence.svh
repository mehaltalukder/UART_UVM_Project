`ifndef write_tx_sequence_exists
`define write_tx_sequence_exists

class write_tx_sequence extends uvm_sequence #(tx_in);

  `uvm_object_utils(write_tx_sequence)
  function new (string name = "write_tx_sequence");
    super.new (name);
  endfunction 

  task body();

  tx_in tx;  
  
  repeat(270) begin
      tx = tx_in::type_id::create("tx");
      start_item(tx);
      if (!tx.randomize()) `uvm_fatal(get_type_name(), "tx_in::randomize failed")
      finish_item(tx);
  end

  endtask: body 

endclass: write_tx_sequence 
`endif