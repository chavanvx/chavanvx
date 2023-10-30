`ifndef INC_I2C_CTRL0_I2C_SYSTEM_CONFIGURATION_SV
`define INC_I2C_CTRL0_I2C_SYSTEM_CONFIGURATION_SV

// Specific I2C system configuration used in the environment
class i2c_ctrl0_i2c_system_configuration_c extends svt_i2c_system_configuration;
  `svt_xvm_object_utils (i2c_ctrl0_i2c_system_configuration_c)
  
   function new(string name="i2c_ctrl0_i2c_system_configuration_c");
        super.new(name);
        //Create a single I2C master agent and a single slave agent. This is
        // required as the slaves cannot be 0
        this.num_masters = 1;
        this.num_slaves = 1;
        
        //Create port configurations
        this.create_sub_cfgs(this.num_masters, this.num_slaves);
        
        // Set mode to master as the only active component
        this.master_cfg[0].is_active    = 1;
        this.slave_cfg[0].is_active     = 1;      
        
        // Set Bus-Speed
        if (test_cfg_pkg::I2C_FILTER_TOP_BUS_SPEED_KHZ == 100) begin
            this.set_bus_speed(STANDARD_MODE);
        end else if (test_cfg_pkg::I2C_FILTER_TOP_BUS_SPEED_KHZ == 400) begin
            this.set_bus_speed(FAST_MODE);
        end else if (test_cfg_pkg::I2C_FILTER_TOP_BUS_SPEED_KHZ == 1000) begin
            this.set_bus_speed(FAST_MODE_PLUS);
        end else begin
            `uvm_fatal("ENV", $sformatf("Unsupported BUS SPEED %d KHZ", test_cfg_pkg::I2C_FILTER_TOP_BUS_SPEED_KHZ))
        end
        
        /** Configure Master and Slave configurations */             
        this.master_cfg[0].master_code = 3'b101;    // Set Master Code
        this.master_cfg[0].enable_cci_8bit = 1;     // Enable 8-bit CCI addressing

        this.master_cfg[0].enable_traffic_log = 1;
        this.slave_cfg[0].enable_traffic_log = 0;   // Disable the slave traffic log because only the master is used

        this.master_cfg[0].enable_tracing = 1;
        this.slave_cfg[0].enable_tracing = 0;

        this.master_cfg[0].coverage_enable = 1'b1;
        this.slave_cfg[0].coverage_enable = 1'b0;   // Only enable coverage on the master

        this.master_cfg[0].toggle_coverage_enable = 1'b1;
        this.slave_cfg[0].toggle_coverage_enable = 1'b0; // Only enable coverage on the master

        // Enabling checks coverages causes a null error at runtime. 
        this.master_cfg[0].checks_coverage_enable = 1'b0;
        this.slave_cfg[0].checks_coverage_enable = 1'b0; // Only enable coverage on the master

        this.master_cfg[0].checks_enable = 1'b1;
        this.slave_cfg[0].checks_enable = 1'b0; // Only enable checks on the master
        
        this.slave_cfg[0].slave_address='h3A; 
   endfunction
   
endclass



`endif
