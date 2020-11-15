`ifndef tx_base_exists
`define tx_base_exists

class tx_base extends uvm_sequence_item;

  `uvm_object_utils(tx_base)
  function new (string name = "tx_base");
    super.new(name);
  endfunction

  bit           i_TX_Data_Valid = 1'b1; // enable control
  randc bit     [7:0]   i_TX_Byte;        //input
  logic         o_RX_Data_Valid;        //rx output status
  logic [7:0]   o_RX_Byte;              //output
  logic         o_TX_Done;              // tx output status

  virtual function void do_copy(uvm_object rhs);
    tx_base tx_rhs;
    if (!$cast(tx_rhs, rhs))
      `uvm_fatal(get_type_name(), "Wrong rhs argument")
    
    super.do_copy(rhs);

    i_TX_Data_Valid    = tx_rhs.i_TX_Data_Valid;
    i_TX_Byte          = tx_rhs.i_TX_Byte;
    o_RX_Data_Valid    = tx_rhs.o_RX_Data_Valid;
    o_RX_Byte          = tx_rhs.o_RX_Byte;
    o_TX_Done          = tx_rhs.o_TX_Done;
  endfunction 

  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    tx_base tx_rhs;
    if (!$cast(tx_rhs, rhs))
      `uvm_fatal(get_type_name(), "Wrong rhs argument")

    return (super.do_compare(rhs, comparer) &&
           (i_TX_Data_Valid === tx_rhs.i_TX_Data_Valid));
  endfunction

  virtual function void do_print (uvm_printer printer);
    printer.m_string = convert2string();
  endfunction

  virtual function string convert2string();
        string s = super.convert2string();
        $sformat(s, "%s\n tx_in (dec):", s);
        $sformat(s, "%s\n i_TX_Data_Valid  = %b, i_TX_Byte = %d \n", s, i_TX_Data_Valid, i_TX_Byte);
        return s;
  endfunction

endclass: tx_base
`endif