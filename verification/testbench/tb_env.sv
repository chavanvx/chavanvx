
class tb_env extends uvm_env;
 `uvm_component_utils(tb_env)

 // I2C VIP environments for each I2C topology
    svt_i2c_system_env i2c_system_env_mstr1;
    svt_i2c_system_env i2c_system_env_slv1;

 //I2C VIP master and slave configuration 
   i2c_mstr1_i2c_system_configuration_c i2c_mstr1_cfg; 
   i2c_slv1_i2c_system_configuration_c i2c_slv1_cfg; 
   virtual_sequencer vseqr;
    virtual svt_i2c_if i2c_if_mstr1; 
    virtual svt_i2c_if i2c_if_mstr2; 
    virtual svt_i2c_if i2c_if_slv1;
    

 function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction : new


virtual function void build_phase(uvm_phase phase);

super.build_phase(phase);

   i2c_mstr1_cfg = i2c_mstr1_i2c_system_configuration_c::type_id::create("i2c_mstr1_cfg");
   i2c_slv1_cfg  = i2c_slv1_i2c_system_configuration_c::type_id::create("i2c_slv1_cfg");

  // Create the I2C environment for each master and slave bus
      vseqr = virtual_sequencer::type_id::create("vseqr",this);
   
  uvm_config_db#(virtual svt_i2c_if)::get(this, "", "i2c_if_slv1", i2c_if_slv1);
  uvm_config_db#(virtual svt_i2c_if)::get(this, "", "i2c_if_mstr1", i2c_if_mstr1);

      i2c_mstr1_cfg.set_if(i2c_if_mstr1);
      i2c_slv1_cfg.set_if(i2c_if_slv1);


  uvm_config_db#(svt_i2c_system_configuration)::set(this, "i2c_system_env_mstr1", "cfg", i2c_mstr1_cfg);
  uvm_config_db#(svt_i2c_system_configuration)::set(this, "i2c_system_env_slv1", "cfg", i2c_slv1_cfg);
  uvm_config_db#(virtual svt_i2c_if)::set(this, "i2c_system_env_mstr1*", "vif", i2c_if_mstr1);
  uvm_config_db#(virtual svt_i2c_if)::set(this, "i2c_system_env_slv1*", "vif", i2c_if_slv1);
  
   i2c_system_env_mstr1 = svt_i2c_system_env::type_id::create("i2c_system_env_mstr1", this);
   i2c_system_env_slv1 = svt_i2c_system_env::type_id::create("i2c_system_env_slv1", this);


endfunction

 virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   vseqr.i2c_mstr_seqr = i2c_system_env_mstr1.master[0].sequencer;
   vseqr.i2c_slv_seqr = i2c_system_env_slv1.slave[0].sequencer;
     
 endfunction


endclass
