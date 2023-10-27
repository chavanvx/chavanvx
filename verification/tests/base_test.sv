`ifndef BASE_TEST_SVH
`define BASE_TEST_SVH

class base_test extends uvm_test;

 `uvm_component_utils(base_test)

  tb_env    tb_env0;

 function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction : new


  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   tb_env0 = tb_env::type_id::create("tb_env0", this);
   `uvm_info("build_phase","Entered ...",UVM_LOW)
  endfunction

  virtual function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
  endfunction


  task run_phase(uvm_phase phase);
      super.run_phase(phase);
  endtask


endclass

`endif
