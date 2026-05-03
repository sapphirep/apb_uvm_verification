`ifndef GUARD__APB_MASTER_TRANSACTION_SV
`define GUARD__APB_MASTER_TRANSACTION_SV

class apb_master_transaction extends uvm_sequence_item;
  `uvm_object_utils(apb_master_transaction)

  rand bit [`APB_ADDR_WIDTH-1:0] paddr  ;
  rand apb_op_e                  op     ;
  rand bit [`APB_DATA_WIDTH-1:0] data   ;
  rand bit [`APB_STRB_WIDTH-1:0] pstrb  ;
  bit                            pslverr;
  bit                            aborted;

  constraint c_paddr {
    paddr <= 16'h10;
  }

  // PSTRB should be 0 for read
  constraint c_pstrb {
    solve op before pstrb;
    (op == READ) -> (pstrb == 0);
  }

  function new(string name="apb_master_transaction");
    super.new(name);
  endfunction: new 

  extern function void   do_copy       (uvm_object rhs);
  extern function bit    do_compare    (uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string();
endclass: apb_master_transaction

function void apb_master_transaction::do_copy(uvm_object rhs);
  apb_master_transaction tr;

  if (!$cast(tr, rhs)) 
    `uvm_fatal("apb_master_transaction", "Failed to cast object for copying!")
  
  super.do_copy(rhs);

  this.paddr   = tr.paddr;
  this.op      = tr.op;
  this.data    = tr.data;
  this.pstrb   = tr.pstrb;
  this.pslverr = tr.pslverr;
endfunction: do_copy

function bit apb_master_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
  apb_master_transaction tr;
  bit eq;

  if (!$cast(tr, rhs))
    `uvm_fatal("apb_master_transaction", "Failed to cast object for comparison!")

  eq = super.do_compare(rhs, comparer);

  eq &= (this.paddr == tr.paddr);
  eq &= (this.op    == tr.op);
  eq &= (this.data  == tr.data);
  eq &= (this.data  == tr.pstrb);
  eq &= (this.pslverr  == tr.pslverr);
  
  return eq;
endfunction: do_compare

function string apb_master_transaction::convert2string();
  return $sformatf("APB_TRANSACTION: op=%s, paddr=%0h, data=%0h",
    op.name, paddr, data
  );
endfunction

`endif