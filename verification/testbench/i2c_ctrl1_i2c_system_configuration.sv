`ifndef INC_I2C_CTRL1_I2C_SYSTEM_CONFIGURATION_SV
`define INC_I2C_CTRL1_I2C_SYSTEM_CONFIGURATION_SV

class i2c_ctrl1_i2c_system_configuration_c extends svt_i2c_system_configuration;
    `svt_xvm_object_utils (i2c_ctrl1_i2c_system_configuration_c)
    int relay_addr_bit;

    function new(string name="i2c_ctrl1_i2c_system_configuration_c");
        super.new(name);
        //Create a single I2C master agent and a single slave agent. This is
        // required as the masters cannot be 0
        this.num_masters = 1;
        this.num_slaves = test_cfg_pkg::I2C_FILTER_TOP_NUM_RELAY_ADDRESSES;
        
        //Create port configurations
        this.create_sub_cfgs(this.num_masters, this.num_slaves);
        
        /** Configure Master and Slave configurations */
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
        this.slave_cfg[0].enable_10bit_addr          = 1'b1;
        foreach(this.slave_cfg[index]) begin
            this.slave_cfg[index].is_active              = 1;
            this.slave_cfg[index].enable_traffic_log     = 1; // Disable the slave traffic log because only the master is used
            this.slave_cfg[index].enable_tracing         = 1;
            this.slave_cfg[index].coverage_enable        = 1'b1; // Only enable coverage on the slave
            this.slave_cfg[index].toggle_coverage_enable = 1'b1; // Only enable coverage on the slave
            this.slave_cfg[index].checks_enable          = 1'b1; // Only enable checks on the slave
            this.slave_cfg[index].enable_10bit_addr      =  0;  // disable 10-bit Addressing
            // Set Slave as EEPROM which saves data into EEPROM memory, which can be read back from that location
            // The first two data byte that will be received by the slave will be loaded into the EEPROM memory location pointer which becomes the starting address of EEPROM memory
            this.slave_cfg[index].slave_type             = `SVT_I2C_EEPROM ;
            this.slave_cfg[index].enable_cci_8bit        = 1; // Enable 8-bit CCI addressing            
            
            this.slave_cfg[index].slave_address = 0;
            for (int i = 0; i < 7; i++) begin
                relay_addr_bit = (index * 7) + i;
                this.slave_cfg[index].slave_address[i] =  test_cfg_pkg::I2C_FILTER_TOP_SMBUS_RELAY_ADDRESS[relay_addr_bit];
            end
            if (test_cfg_pkg::I2C_FILTER_MISSMATCH_SLAVE_AND_RELAY_ADDR == 1)
                this.slave_cfg[index].slave_address =  10'h337;
        end
        
        // Disable master tracing and coverage
        this.master_cfg[0].is_active                = 1;
        this.master_cfg[0].enable_traffic_log       = 1;
        this.master_cfg[0].enable_tracing           = 1;
        this.master_cfg[0].coverage_enable          = 1'b0;
        this.master_cfg[0].toggle_coverage_enable   = 1'b0;
        this.master_cfg[0].checks_coverage_enable   = 1'b0;
        this.master_cfg[0].checks_enable            = 1'b0;
        this.master_cfg[0].master_code = 3'b101;    // Set Master Code
        this.master_cfg[0].enable_cci_8bit = 1;     // Enable 8-bit CCI addressing

    
    endfunction

endclass




`endif
