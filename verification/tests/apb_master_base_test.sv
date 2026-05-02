class apb_master_base_test extends uvm_test;
  `uvm_component_utils(apb_master_base_test)

  apb_master_env mst_env;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    mst_env = apb_master_env::type_id::create("mst_env", this);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    apb_master_base_sequence seq;
    phase.raise_objection(this);
    seq = apb_master_base_sequence::type_id::create("seq");
    if (!seq.randomize()) `uvm_fatal("run_phase", "Failed to randomize sequence!")
    seq.start(mst_env.mst_agt.apb_mst_sqr);
    phase.drop_objection(this);
  endtask: run_phase

endclass: apb_master_base_test