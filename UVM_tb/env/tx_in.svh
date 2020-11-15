`ifndef tx_in_exists
`define tx_in_exists

class tx_in extends tx_base;

`uvm_object_utils(tx_in)
function new (string name = "tx_in");
  super.new(name);
endfunction

constraint c_i_TX_Byte  {
i_TX_Byte inside {[0:255]};
}

endclass: tx_in
`endif