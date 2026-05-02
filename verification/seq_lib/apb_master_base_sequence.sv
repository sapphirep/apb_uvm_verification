`ifndef GUARD__APB_MASTER_BASE_SEQUENCE_SV
`define GUARD__APB_MASTER_BASE_SEQUENCE_SV

class apb_master_base_sequence extends uvm_sequence#(apb_master_transaction);
  `uvm_object_utils(apb_master_base_sequence)

  function new(string name="apb_master_base_sequence");
    super.new();
  endfunction: new

  task body();
    repeat (10) begin
      apb_master_transaction tr = apb_master_transaction::type_id::create("tr");
      start_item(tr);
      if (!tr.randomize()) `uvm_fatal("body", "Failed to randomize transaction!")
      finish_item(tr);
    end
  endtask: body

endclass: apb_master_base_sequence

`endif