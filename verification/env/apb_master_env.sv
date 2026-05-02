class apb_master_env extends uvm_env;
  `uvm_component_utils(apb_master_env)

  apb_master_agent mst_agt;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "mst_agt", "is_active", UVM_ACTIVE);
    mst_agt = apb_master_agent::type_id::create("mst_agt", this);
  endfunction: build_phase

endclass: apb_master_env