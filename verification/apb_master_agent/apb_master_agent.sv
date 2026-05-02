class apb_master_agent extends uvm_agent;
  `uvm_component_utils(apb_master_agent)

  apb_master_monitor   apb_mst_mon;
  apb_master_driver    apb_mst_drv;
  apb_master_sequencer apb_mst_sqr;

  uvm_analysis_port #(apb_master_transaction) analysis_port;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE) begin
      apb_mst_drv = apb_master_driver::type_id::create("apb_mst_drv", this);
      apb_mst_sqr = apb_master_sequencer::type_id::create("apb_mst_sqr", this);
    end
    apb_mst_mon = apb_master_monitor::type_id::create("apb_mst_mon", this);
    analysis_port = new("analysis_port", this);
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    if (is_active == UVM_ACTIVE) begin
      apb_mst_drv.seq_item_port.connect(apb_mst_sqr.seq_item_export);
    end
    apb_mst_mon.analysis_port.connect(analysis_port);
  endfunction: connect_phase

endclass: apb_master_agent