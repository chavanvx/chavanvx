
class tb_env extends uvm_env;
 `uvm_component_utils(tb_env)

 // I2C VIP environments for each I2C topology
    svt_i2c_system_env i2c_system_env_ctrl0;
    svt_i2c_system_env i2c_system_env_ctrl1;

 //I2C VIP master and slave configuration 
   i2c_ctrl0_i2c_system_configuration_c i2c_ctrl0_cfg; 
   i2c_ctrl1_i2c_system_configuration_c i2c_ctrl1_cfg; 
   virtual_sequencer vseqr;
    virtual svt_i2c_if i2c_if_ctrl0; 
    virtual svt_i2c_if i2c_if_mstr2; 
    virtual svt_i2c_if i2c_if_ctrl1;
    

 function new(string name, uvm_component parent = null);
      super.new(name, parent);
   endfunction : new


virtual function void build_phase(uvm_phase phase);

super.build_phase(phase);

   i2c_ctrl0_cfg = i2c_ctrl0_i2c_system_configuration_c::type_id::create("i2c_ctrl0_cfg");
   i2c_ctrl1_cfg  = i2c_ctrl1_i2c_system_configuration_c::type_id::create("i2c_ctrl1_cfg");

  // Create the I2C environment for each master and slave bus
      vseqr = virtual_sequencer::type_id::create("vseqr",this);
   
  uvm_config_db#(virtual svt_i2c_if)::get(this, "", "i2c_if_ctrl1", i2c_if_ctrl1);
  uvm_config_db#(virtual svt_i2c_if)::get(this, "", "i2c_if_ctrl0", i2c_if_ctrl0);

      i2c_ctrl0_cfg.set_if(i2c_if_ctrl0);
      i2c_ctrl1_cfg.set_if(i2c_if_ctrl1);


  uvm_config_db#(svt_i2c_system_configuration)::set(this, "i2c_system_env_ctrl0", "cfg", i2c_ctrl0_cfg);
  uvm_config_db#(svt_i2c_system_configuration)::set(this, "i2c_system_env_ctrl1", "cfg", i2c_ctrl1_cfg);
  uvm_config_db#(virtual svt_i2c_if)::set(this, "i2c_system_env_ctrl0*", "vif", i2c_if_ctrl0);
  uvm_config_db#(virtual svt_i2c_if)::set(this, "i2c_system_env_ctrl1*", "vif", i2c_if_ctrl1);
  
   i2c_system_env_ctrl0 = svt_i2c_system_env::type_id::create("i2c_system_env_ctrl0", this);
   i2c_system_env_ctrl1 = svt_i2c_system_env::type_id::create("i2c_system_env_ctrl1", this);


endfunction

 virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   vseqr.i2c_ctrl0_mstr_seqr = i2c_system_env_ctrl0.master[0].sequencer;
   vseqr.i2c_ctrl1_mstr_seqr = i2c_system_env_ctrl1.master[0].sequencer;
   //vseqr.i2c_slv_seqr = i2c_system_env_ctrl1.slave[0].sequencer;
     
 endfunction


endclass
