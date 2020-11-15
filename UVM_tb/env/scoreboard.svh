`ifndef alu_scoreboard_exists
`define alu_scoreboard_exists

  `uvm_analysis_imp_decl(_dut_in)
  `uvm_analysis_imp_decl(_dut_out)


class uart_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(uart_scoreboard)
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new


  uvm_analysis_imp_dut_in  #(tx_in, uart_scoreboard) dut_in_imp_export;
  uvm_analysis_imp_dut_out #(tx_out,  uart_scoreboard) dut_out_imp_export;

  int match, mismatch;
  int max;

  tx_out expect_aa [bit [7:0]]; 

  virtual function void build_phase(uvm_phase phase);
 
    dut_in_imp_export  = new("dut_in_imp_export", this);
    dut_out_imp_export = new("dut_out_imp_export", this);

  endfunction

  function void write_dut_in(tx_in t);

  tx_out exp;
  
  exp = tx_out::type_id::create("exp");

    exp.o_RX_Byte = t.i_TX_Byte;
    expect_aa[exp.i]  = exp;
 
  endfunction: write_dut_in

  function void write_dut_out(tx_out t);

    if (!expect_aa.exists(t.i)) begin
       `uvm_error("SCOREBOARD", $sformatf("read_pointer value  is an address that has not been written\n"))
    end
    
    else if (t.compare(expect_aa[t.i])) begin
      match++;
      expect_aa.delete(t.i);
    end

    else begin
   
      `uvm_error("SCOREBOARD", $sformatf("Expected and actual did not match at address "))
      `uvm_info("SCOREBOARD",  $sformatf("DUT out is:%s\nExpected",
                               t.convert2string(), expect_aa[t.i].convert2string()), UVM_NONE)
      mismatch++;
    end 
    
  endfunction: write_dut_out

    virtual function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", $sformatf("\n\n\t Test score: passed=%0d  failed=%0d\n", match, mismatch), UVM_NONE)

  endfunction: report_phase




endclass
`endif