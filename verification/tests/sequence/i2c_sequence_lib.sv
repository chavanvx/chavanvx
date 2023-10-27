`ifndef INC_I2C_SEQUENCE_LIB_SV
`define INC_I2C_SEQUENCE_LIB_SV


// NULL sequence for use as the default sequence when required.
class i2c_null_virtual_sequence extends uvm_sequence;
    /** UVM object utility macro */
    `uvm_object_utils(i2c_null_virtual_sequence)
    
    /** Class constructor */
    function new (string name = "i2c_null_virtual_sequence");
        super.new(name);
    endfunction : new
    
    /** Need an empty body function to override the warning from the UVM base class */
    virtual task body();
    endtask : body

endclass : i2c_null_virtual_sequence

// Default random response for slaves. 
class i2c_random_slave_base_sequence_c extends uvm_sequence #(i2c_slave_seq_item_c); 

    `uvm_object_utils(i2c_random_slave_base_sequence_c)

    /** This macro is used to declare a variable p_sequencer whose type is svt_i2c_slave_transaction_sequencer */
    `uvm_declare_p_sequencer(svt_i2c_slave_transaction_sequencer) 

    /** I2C configuration handle */ 
    svt_i2c_configuration i2c_cfg;

    i2c_slave_seq_item_c  tx_xacts_s;
    
    bit disable_get_response = 0;
    
    function new(string name="i2c_random_slave_sequence");
        super.new(name);
    endfunction: new 

    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    // Must override this task in base classes.
    virtual task create_seq();
        `uvm_fatal("SEQ", "create_seq not overridden")
    endtask
    
    virtual task body();

        // SVT configuration handle */ 
        svt_configuration cfg;

        // Get the SVT configuration */
        p_sequencer.get_cfg(cfg);
        
        // Cast the SVT configuration handle on the local I2C configuration handle */
        if (!$cast(i2c_cfg, cfg)) begin
            `uvm_fatal("body", "Unable to cast the configuration to a svt_i2c_configuration class");
        end

        // Run the UVM macro to randomize req and send it to the sequencer
        //`uvm_do(req)
        
        create_seq();

        /** 
         * Call get_response only if configuration attribute,
         * enable_put_response is set 1.
         */
        if((i2c_cfg.enable_put_response == 1) && (disable_get_response == 0))
            get_response(rsp);

    endtask: body
    
endclass: i2c_random_slave_base_sequence_c

class i2c_no_clock_stretching_slave_sequence_c extends i2c_random_slave_base_sequence_c;

    `uvm_object_utils(i2c_no_clock_stretching_slave_sequence_c)
    
    function new(string name="i2c_no_clock_stretching_slave_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_clk_stretch_bit_level_addr_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_byte_level_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_bit_level_data_pos.constraint_mode(0);
        
        tx_xacts_s.enable_random_clk_stretch_time_after_byte = 0; // byte level stretching after each byte by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_addr_byte = 0;  // bit level stretching after each address bit by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_data_byte = 0;  // bit level stretching after each data bit by random value of clk cycle
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             })    
        
    endtask

endclass : i2c_no_clock_stretching_slave_sequence_c

class i2c_random_after_byte_clock_stretching_slave_sequence_c extends i2c_random_slave_base_sequence_c;

    `uvm_object_utils(i2c_random_after_byte_clock_stretching_slave_sequence_c)
    
    function new(string name="i2c_random_after_byte_clock_stretching_slave_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_clk_stretch_bit_level_addr_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_byte_level_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_bit_level_data_pos.constraint_mode(0);
        
        tx_xacts_s.enable_random_clk_stretch_time_after_byte = 1; // byte level stretching after each byte by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_addr_byte = 0;  // bit level stretching after each address bit by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_data_byte = 0;  // bit level stretching after each data bit by random value of clk cycle
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             tx_xacts_s.clk_stretch_bit_level_addr_pos == 0;
                             // tx_xacts_s.clk_stretch_byte_level_pos == 0;
                             tx_xacts_s.clk_stretch_bit_level_data_pos == 0;
                             })    
        
    endtask

endclass : i2c_random_after_byte_clock_stretching_slave_sequence_c

class i2c_directed_data_byte_clock_stretching_slave_sequence_c extends i2c_random_slave_base_sequence_c;

    `uvm_object_utils(i2c_directed_data_byte_clock_stretching_slave_sequence_c)
    
    int clk_stretch_bit_level_data_pos = 0;
    int clk_stretch_time_data_byte = 100;
    
    function new(string name="i2c_directed_data_byte_clock_stretching_slave_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_clk_stretch_bit_level_addr_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_byte_level_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_bit_level_data_pos.constraint_mode(0);
        
        tx_xacts_s.enable_random_clk_stretch_time_after_byte = 0; // byte level stretching after each byte by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_addr_byte = 0;  // bit level stretching after each address bit by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_data_byte = 1;  // bit level stretching after each data bit by random value of clk cycle
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             tx_xacts_s.clk_stretch_bit_level_addr_pos == 0;
                             tx_xacts_s.clk_stretch_byte_level_pos == 0;
                             tx_xacts_s.clk_stretch_time_data_byte == clk_stretch_time_data_byte;
                             tx_xacts_s.clk_stretch_bit_level_data_pos == clk_stretch_bit_level_data_pos;
                             })    
        
    endtask

endclass : i2c_directed_data_byte_clock_stretching_slave_sequence_c

class i2c_random_addr_byte_clock_stretching_slave_sequence_c extends i2c_random_slave_base_sequence_c;

    `uvm_object_utils(i2c_random_addr_byte_clock_stretching_slave_sequence_c)
    
    function new(string name="i2c_random_addr_byte_clock_stretching_slave_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_clk_stretch_bit_level_addr_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_byte_level_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_bit_level_data_pos.constraint_mode(0);
        
        tx_xacts_s.enable_random_clk_stretch_time_after_byte = 0; // byte level stretching after each byte by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_addr_byte = 1;  // bit level stretching after each address bit by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_data_byte = 0;  // bit level stretching after each data bit by random value of clk cycle
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             // tx_xacts_s.clk_stretch_bit_level_addr_pos == 0;
                             tx_xacts_s.clk_stretch_byte_level_pos == 0;
                             tx_xacts_s.clk_stretch_bit_level_data_pos == 0;
                             })    
        
    endtask

endclass : i2c_random_addr_byte_clock_stretching_slave_sequence_c

class i2c_random_data_byte_clock_stretching_slave_sequence_c extends i2c_random_slave_base_sequence_c;

    `uvm_object_utils(i2c_random_data_byte_clock_stretching_slave_sequence_c)
    
    function new(string name="i2c_random_data_byte_clock_stretching_slave_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_clk_stretch_bit_level_addr_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_byte_level_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_bit_level_data_pos.constraint_mode(0);
        
        tx_xacts_s.enable_random_clk_stretch_time_after_byte = 0; // byte level stretching after each byte by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_addr_byte = 0;  // bit level stretching after each address bit by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_data_byte = 1;  // bit level stretching after each data bit by random value of clk cycle
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             tx_xacts_s.clk_stretch_bit_level_addr_pos == 0;
                             tx_xacts_s.clk_stretch_byte_level_pos == 0;
                             // tx_xacts_s.clk_stretch_bit_level_data_pos == 0;
                             })    
        
    endtask

endclass : i2c_random_data_byte_clock_stretching_slave_sequence_c

class i2c_random_bit_level_addr_data_clock_stretching_slave_sequence_c extends i2c_random_slave_base_sequence_c;

    `uvm_object_utils(i2c_random_bit_level_addr_data_clock_stretching_slave_sequence_c)
    
    function new(string name="i2c_random_bit_level_addr_data_clock_stretching_slave_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_clk_stretch_bit_level_addr_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_byte_level_pos.constraint_mode(0);
        tx_xacts_s.reasonable_clk_stretch_bit_level_data_pos.constraint_mode(0);
        
        tx_xacts_s.enable_random_clk_stretch_time_after_byte = 0; // byte level stretching after each byte by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_addr_byte = 1;  // bit level stretching after each address bit by random value of clk cycle
        tx_xacts_s.enable_random_clk_stretch_time_data_byte = 1;  // bit level stretching after each data bit by random value of clk cycle
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             // tx_xacts_s.clk_stretch_bit_level_addr_pos == 0;
                             tx_xacts_s.clk_stretch_byte_level_pos == 0;
                             // tx_xacts_s.clk_stretch_bit_level_data_pos == 0;
                             })    
        
    endtask

endclass : i2c_random_bit_level_addr_data_clock_stretching_slave_sequence_c

class i2c_master_base_seq_c extends uvm_sequence #(i2c_master_seq_item_c); 
    // Possible sub_address
    rand bit[7:0] sub_address = 8'b0000_0000;
    rand bit [7:0] wdata[16];
    rand bit [7:0] data[]; 
    bit[7:0] bytecount = 8'd128; 
    bit[7:0] invalid_bytecount = 8'd64;
    
    // Enable reasonable_addr constraint mode 
    // addr randomized inside {10'h333, 10'h330, 10'h331, 10'h332, 10'h334, 10'h335, 10'h336, 10'h337}
    bit addr_constraint_mode = 1;
    
    rand bit[7:0] i2c_idle;
    
    // Constraint for the i2c idle
    constraint reasonable_i2c_idle{
        i2c_idle inside {8'b0000_0000, 8'b0010_0000, 8'b0001_0000, 8'b0000_0010, 8'b0000_0100, 8'b1111_1110};
    }
    
    // Constraint for the subaddress
    constraint reasonable_sub_address{
        sub_address inside {[8'b0000_0000:8'b1111_1110]};
    }
    
    // Possible data
    rand bit[7:0] data_byte = 8'b0000_0000;
    
    // Constraint for the subaddress
    constraint reasonable_data_value {
        data_byte inside {[8'b0000_0000:8'b1111_1111]};
    }
    
    // addr is constraint random inside {10'h333, 10'h330, 10'h331, 10'h332, 10'h334, 10'h335, 10'h336, 10'h337}); 
    bit [9:0] slave_address = `SVT_I2C_SLAVE0_ADDRESS;

    rand bit enable_clk_stretch_random_bit_level = 0;
    constraint reasonable_enable_clk_stretch_random_bit_level{
        enable_clk_stretch_random_bit_level inside {[0:1]};
    }
    
    bit enable_clk_stretch_after_byte = 0;
        
    `uvm_object_utils(i2c_master_base_seq_c)

    function new(string name="i2c_master_base_seq_c");
        super.new(name);
    endfunction: new
    
    function void configure_addr_constraint_mode(bit enable = 1'b0);
        addr_constraint_mode = enable;
    endfunction

endclass : i2c_master_base_seq_c

// Create a exception transaction to the CCI Slave
class i2c_master_start_in_byte_error_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_start_in_byte_error_seq_c)
    
    function new(string name="i2c_master_start_in_byte_error_seq_c");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();

        i2c_master_seq_item_c tr;
        svt_i2c_master_transaction_exception_list exception_list_tr;
        svt_i2c_master_transaction_exception      exception_tr;
        
        tr = i2c_master_seq_item_c::type_id::create("tr");
        exception_tr = new("exception_tr"); 
        exception_list_tr = new("exception_list_tr", exception_tr);
        
        exception_tr.randomize() with
                     {
            exception_tr.error_kind == START_IN_BYTE;           
            exception_tr.no_of_tags inside {1, 2};
            exception_tr.data_byte_pos inside {1, 2};
            //exception_tr.byte_bit_pos inside {1, 2, 3, 4, 5, 6, 7, 8}; // put this, VIP will go crazy 
            exception_tr.retry_txn == 1;
        };      

        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_start_in_byte_error_seq_c::enable_clk_stretch_after_byte;
        assert(tr.randomize() with
                     {
            tr.addr            == slave_address; 
            tr.enable_clk_stretch_random_bit_level == i2c_master_start_in_byte_error_seq_c::enable_clk_stretch_random_bit_level;  
        });

        exception_list_tr.add_exception(exception_tr);
        tr.exception_list = exception_list_tr;
        
        finish_item(tr);
        
        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_start_in_byte_error_seq_c

// Create a exception transaction to the CCI Slave
class i2c_master_stop_in_byte_error_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_stop_in_byte_error_seq_c)
    
    function new(string name="i2c_master_stop_in_byte_error_seq_c");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();

        i2c_master_seq_item_c tr;
        svt_i2c_master_transaction_exception_list exception_list_tr;
        svt_i2c_master_transaction_exception      exception_tr;
        
        tr = i2c_master_seq_item_c::type_id::create("tr");
        exception_tr = new("exception_tr"); 
        exception_list_tr = new("exception_list_tr", exception_tr);
         
        exception_tr.randomize() with
                     {
            exception_tr.error_kind == STOP_IN_BYTE;           
            exception_tr.p_at_cmd_data inside {0, 1};
            exception_tr.no_of_tags inside {1, 2};
            exception_tr.data_byte_pos inside {1, 2};
            exception_tr.byte_bit_pos inside {1, 2, 3, 4, 5, 6, 7, 8};
            exception_tr.retry_txn == 1;
        };
    
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_stop_in_byte_error_seq_c::enable_clk_stretch_after_byte;
        assert(tr.randomize() with
                     {
            tr.addr            == slave_address; 
            tr.enable_clk_stretch_random_bit_level == 0;  
            tr.idle_time       == 10;
        });

        exception_list_tr.add_exception(exception_tr);
        tr.exception_list = exception_list_tr;
        
        finish_item(tr);
        
        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_stop_in_byte_error_seq_c

// Create a single write transaction to the CCI Slave
class i2c_master_single_write_seq_c extends i2c_master_base_seq_c;
    `uvm_object_utils(i2c_master_single_write_seq_c)
    
    function new(string name="i2c_master_single_write_seq_c");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr.reasonable_addr.constraint_mode(0);
        
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_single_write_seq_c::enable_clk_stretch_after_byte;
        tr.randomize() with
        {
            tr.addr            == slave_address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == 2; // Data size must be 2, subaddress then actual data
            tr.data[0]         == sub_address;  
            tr.data[1]         == data_byte;
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
            tr.enable_clk_stretch_random_bit_level == i2c_master_single_write_seq_c::enable_clk_stretch_random_bit_level;  
        };
        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_single_write_seq_c

// Create a multiple byte write transaction to the CCI Slave
class i2c_master_pcie_mctp_write_seq_c extends i2c_master_base_seq_c;

    bit[7:0] datain[$];

    `uvm_object_utils(i2c_master_pcie_mctp_write_seq_c)
    
    function new(string name="i2c write operation with MCTP transaction");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr.reasonable_data.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr.reasonable_addr.constraint_mode(0);
        
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_pcie_mctp_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr.randomize() with
                     {
            tr.addr            == slave_address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == ('d3 + bytecount); // subaddress + bytecount + data + pec
            tr.data[0]         == sub_address; 
            tr.data[1]         == bytecount;
            tr.idle_time       == i2c_idle;
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
            tr.enable_clk_stretch_random_bit_level == i2c_master_pcie_mctp_write_seq_c::enable_clk_stretch_random_bit_level;
        });
        
        for (int i=2; i<tr.data.size(); i++) begin
            tr.data[i] = datain[i];
        end
        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_pcie_mctp_write_seq_c

// Create a multiple byte write transaction to the CCI Slave
class i2c_master_pch_mctp_write_seq_c extends i2c_master_base_seq_c;

    bit[7:0] datain[$];

    `uvm_object_utils(i2c_master_pch_mctp_write_seq_c)
    
    function new(string name="i2c write operation with MCTP transaction");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr.reasonable_data.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr.reasonable_addr.constraint_mode(0);
        
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_pch_mctp_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr.randomize() with
                     {
            tr.addr            == slave_address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == ('d3 + bytecount); // subaddress + bytecount + data + pec
            tr.data[0]         == sub_address; 
            tr.data[1]         == bytecount;
            tr.idle_time       == i2c_idle;
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
            tr.enable_clk_stretch_random_bit_level == i2c_master_pch_mctp_write_seq_c::enable_clk_stretch_random_bit_level;
        });
        
        for (int i=2; i<tr.data.size(); i++) begin
            tr.data[i] = datain[i];
        end
        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_pch_mctp_write_seq_c

class i2c_master_mctp_invalidpkt_err_write_seq_c extends i2c_master_base_seq_c;

    bit[7:0] datain[$];

    `uvm_object_utils(i2c_master_mctp_invalidpkt_err_write_seq_c)
    
    function new(string name="i2c write operation with MCTP transaction");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr.reasonable_data.constraint_mode(0);
        
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_mctp_invalidpkt_err_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr.randomize() with
                     {
            tr.addr            == slave_address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == ('d2 + invalid_bytecount); // subaddress + invalid_bytecount + data // no need PEC because its an invalid short packet
            tr.data[0]         == sub_address; 
            tr.data[1]         == bytecount;
            tr.idle_time       == i2c_idle;
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
            tr.enable_clk_stretch_random_bit_level == i2c_master_mctp_invalidpkt_err_write_seq_c::enable_clk_stretch_random_bit_level;
        });
        
        for (int i=2; i<tr.data.size(); i++) begin
            tr.data[i] = datain[i];
        end
        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_mctp_invalidpkt_err_write_seq_c

// Create a multiple byte write transaction to the CCI Slave
class i2c_master_bmc_mctp_write_seq_c extends i2c_master_base_seq_c;

    bit[7:0] datain[$];

    `uvm_object_utils(i2c_master_bmc_mctp_write_seq_c)
    
    function new(string name="i2c write operation with MCTP transaction");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr.reasonable_data.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr.reasonable_addr.constraint_mode(0);
        
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_bmc_mctp_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr.randomize() with
                     {
            tr.addr            == slave_address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == ('d3 + bytecount); // subaddress + bytecount + data + pec
            tr.data[0]         == sub_address; 
            tr.data[1]         == bytecount;
            tr.idle_time       == i2c_idle;
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
            tr.enable_clk_stretch_random_bit_level == i2c_master_bmc_mctp_write_seq_c::enable_clk_stretch_random_bit_level;
        });
        
        for (int i=2; i<tr.data.size(); i++) begin
            tr.data[i] = datain[i];
        end
        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_bmc_mctp_write_seq_c

// Create a multiple byte write transaction to the CCI Slave
class i2c_master_multiplebyte_write_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_multiplebyte_write_seq_c)
    
    function new(string name="i2c write operation with multiple bytes");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr.reasonable_data.constraint_mode(0);
        
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_multiplebyte_write_seq_c::enable_clk_stretch_after_byte;
         assert(tr.randomize() with
                     {
            tr.addr            == slave_address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == 5; // subaddress then 4 random data bytes
            tr.data[0]         == sub_address; 
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
            tr.enable_clk_stretch_random_bit_level == i2c_master_multiplebyte_write_seq_c::enable_clk_stretch_random_bit_level;
        });
        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_multiplebyte_write_seq_c


// Perform a single read transaction. Note this actually transalates into
// a write then read
class i2c_master_single_read_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_single_read_seq_c)
    
    function new(string name="i2c_master_single_read_rand_loc_cci_sequence");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    /** Drop an objection if this is the parent sequence */
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        i2c_master_seq_item_c tr_write;
        i2c_master_seq_item_c tr_read;


        // Create the first part of the read operation by sending a write
        // with the subaddress and then the repeated start at the end
        tr_write = i2c_master_seq_item_c::type_id::create("tr_write");

        // Enable/Disable random clock stretching on master
        tr_write.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_write.reasonable_addr.constraint_mode(0);
       
        start_item(tr_write);
        tr_write.enable_clk_stretch_after_byte = i2c_master_single_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_write.randomize() with
        {
            tr_write.addr            == slave_address;
            tr_write.cmd             == I2C_WRITE;
            tr_write.data.size()     == 1;
            tr_write.data[0]         == sub_address;  
            tr_write.sr_or_p_gen     == 1; //Repeated Start
            tr_write.send_start_byte == 0;
            tr_write.enable_clk_stretch_random_bit_level == i2c_master_single_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_write);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);

        
        // Create the second part of the read, which is the actual read
        tr_read = i2c_master_seq_item_c::type_id::create("tr_read");

        // Enable/Disable random clock stretching on master
        tr_read.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_read.reasonable_addr.constraint_mode(0);
       
        start_item(tr_read);
        tr_read.enable_clk_stretch_after_byte = i2c_master_single_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read.randomize() with
        {
            tr_read.addr            == slave_address ;
            tr_read.cmd             == I2C_READ;
            tr_read.data.size()     == 1;
            tr_read.sr_or_p_gen     == 0; // Stop
            tr_read.send_start_byte == 0;
            tr_read.enable_clk_stretch_random_bit_level == i2c_master_single_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);
        
    endtask: body

endclass: i2c_master_single_read_seq_c

// Perform a multiple byte read transaction. Note this actually transalates into
// a write then read multiple byte
class i2c_master_multiplebyte_read_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_multiplebyte_read_seq_c)
    
    function new(string name="i2c read operation with multiple byte");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    /** Drop an objection if this is the parent sequence */
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        i2c_master_seq_item_c tr_write;
        i2c_master_seq_item_c tr_read;


        // Create the first part of the read operation by sending a write
        // with the subaddress and then the repeated start at the end
        tr_write = i2c_master_seq_item_c::type_id::create("tr_write");

        // Enable/Disable random clock stretching on master
        tr_write.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
       
        start_item(tr_write);
        tr_write.enable_clk_stretch_after_byte = i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_write.randomize() with
        {
            tr_write.addr            == slave_address;
            tr_write.cmd             == I2C_WRITE;
            tr_write.data.size()     == 1;
            tr_write.data[0]         == sub_address;  
            tr_write.sr_or_p_gen     == 1; //Repeated Start
            tr_write.send_start_byte == 0;
            tr_write.enable_clk_stretch_random_bit_level == i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_write);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);

        
        // Create the second part of the read, which is the actual read
        tr_read = i2c_master_seq_item_c::type_id::create("tr_read");

        // Enable/Disable random clock stretching on master
        tr_read.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr_read.reasonable_data.constraint_mode(0);
        
        start_item(tr_read);
        tr_read.enable_clk_stretch_after_byte = i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read.randomize() with
        {
            tr_read.addr            == slave_address ;
            tr_read.cmd             == I2C_READ;
            tr_read.data.size()     == 5;
            tr_read.sr_or_p_gen     == 0; // Stop
            tr_read.send_start_byte == 0;
            tr_read.enable_clk_stretch_random_bit_level == i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);
        
    endtask: body

endclass: i2c_master_multiplebyte_read_seq_c

// Perform a write operation follow by repeated start write
class i2c_master_write_sr_write_seq_c extends i2c_master_base_seq_c;
    
    `uvm_object_utils(i2c_master_write_sr_write_seq_c)
    
    function new(string name="i2c write operation follow by repeated start write");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    /** Drop an objection if this is the parent sequence */
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        i2c_master_seq_item_c tr_write;
        i2c_master_seq_item_c tr_write2;
        
        // Create the first part by sending a write
        // with the subaddress and then the repeated start at the end
        tr_write = i2c_master_seq_item_c::type_id::create("tr_write");

        // Enable/Disable random clock stretching on master
        tr_write.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_write.reasonable_addr.constraint_mode(0);
       
        start_item(tr_write);
        tr_write.enable_clk_stretch_after_byte = i2c_master_write_sr_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr_write.randomize() with
        {
            tr_write.addr            == slave_address;
            tr_write.cmd             == I2C_WRITE;
            tr_write.data.size()     == 1;
            tr_write.data[0]         == sub_address;  
            tr_write.sr_or_p_gen     == 1; //Repeated Start
            tr_write.send_start_byte == 0;
            tr_write.enable_clk_stretch_random_bit_level == i2c_master_write_sr_write_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_write);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);

        
        // Create the second part of the write
        tr_write2 = i2c_master_seq_item_c::type_id::create("tr_write2");

        // Enable/Disable random clock stretching on master
        tr_write2.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_write2.reasonable_addr.constraint_mode(0);
       
        start_item(tr_write2);
        tr_write2.enable_clk_stretch_after_byte = i2c_master_write_sr_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr_write2.randomize() with
        {
            tr_write2.addr            == slave_address ;
            tr_write2.cmd             == I2C_WRITE;
            tr_write2.data.size()     == 2;
            tr_write2.data[0]         == sub_address;
            tr_write2.data[1]         == data_byte;
            tr_write2.sr_or_p_gen     == 0; // Stop
            tr_write2.send_start_byte == 0;
            tr_write2.enable_clk_stretch_random_bit_level == i2c_master_write_sr_write_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_write2);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);
        
    endtask: body

endclass: i2c_master_write_sr_write_seq_c

// Perform a read operation follow by repeated start write
class i2c_master_read_sr_write_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_read_sr_write_seq_c)
    
    function new(string name="i2c read operation follow by repeated start write");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    /** Drop an objection if this is the parent sequence */
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        i2c_master_seq_item_c tr_read;
        i2c_master_seq_item_c tr_write;
        
        // Create the first part by sending a read then the repeated start at the end
        tr_read = i2c_master_seq_item_c::type_id::create("tr_read");

        // Enable/Disable random clock stretching on master
        tr_read.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr_read.reasonable_sr_or_p_gen.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_read.reasonable_addr.constraint_mode(0);
       
        start_item(tr_read);
        tr_read.enable_clk_stretch_after_byte = i2c_master_read_sr_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read.randomize() with
        {
            tr_read.addr            == slave_address ;
            tr_read.cmd             == I2C_READ;
            tr_read.data.size()     == 1;
            tr_read.sr_or_p_gen     == 1;
            tr_read.send_start_byte == 0;
            tr_read.enable_clk_stretch_random_bit_level == i2c_master_read_sr_write_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);
        
        // Create the second part of the write
        tr_write = i2c_master_seq_item_c::type_id::create("tr_write");

        // Enable/Disable random clock stretching on master
        tr_write.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
       
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_write.reasonable_addr.constraint_mode(0);
       
        start_item(tr_write);
        tr_write.enable_clk_stretch_after_byte = i2c_master_read_sr_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr_write.randomize() with
        {
            tr_write.addr            == slave_address ;
            tr_write.cmd             == I2C_WRITE;
            tr_write.data.size()     == 2;
            tr_write.data[0]         == sub_address;
            tr_write.data[1]         == data_byte;
            tr_write.sr_or_p_gen     == 0; // Stop
            tr_write.send_start_byte == 0;
            tr_write.enable_clk_stretch_random_bit_level == i2c_master_read_sr_write_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_write);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);
        
    endtask: body

endclass: i2c_master_read_sr_write_seq_c

class i2c_master_read_sr_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_read_sr_seq_c)
    
    function new(string name="i2c read operation");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    /** Drop an objection if this is the parent sequence */
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        i2c_master_seq_item_c tr_read;
        
        // Create the first part by sending a read then the repeated start at the end
        tr_read = i2c_master_seq_item_c::type_id::create("tr_read");

        // Enable/Disable random clock stretching on master
        tr_read.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr_read.reasonable_sr_or_p_gen.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_read.reasonable_addr.constraint_mode(0);
        
        start_item(tr_read);
        tr_read.enable_clk_stretch_after_byte = i2c_master_read_sr_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read.randomize() with
        {
            tr_read.addr            == slave_address ;
            tr_read.cmd             == I2C_READ;
            tr_read.data.size()     == 1;
            tr_read.sr_or_p_gen     == 0;
            tr_read.send_start_byte == 0;
            tr_read.enable_clk_stretch_random_bit_level == i2c_master_read_sr_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);

        
        /* // Create the second part of the read
        tr_read2 = i2c_master_seq_item_c::type_id::create("tr_read2");

        // Enable/Disable random clock stretching on master
        tr_read2.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_read2.reasonable_addr.constraint_mode(0);
        
        start_item(tr_read2);
        tr_read2.enable_clk_stretch_after_byte = i2c_master_read_sr_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read2.randomize() with
        {
            tr_read2.addr            == slave_address;
            tr_read2.cmd             == I2C_READ;
            tr_read2.data.size()     == 1;
            tr_read2.sr_or_p_gen     == 0; // Stop
            tr_read2.send_start_byte == 0;
            tr_read2.enable_clk_stretch_random_bit_level == i2c_master_read_sr_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read2);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp); */
        
    endtask: body

endclass: i2c_master_read_sr_seq_c

// Perform a read operation follow by repeated start read
class i2c_master_read_sr_read_seq_c extends i2c_master_base_seq_c;

    `uvm_object_utils(i2c_master_read_sr_read_seq_c)
    
    function new(string name="i2c read operation follow by repeated start read");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    /** Drop an objection if this is the parent sequence */
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        i2c_master_seq_item_c tr_read;
        i2c_master_seq_item_c tr_read2;
        
        // Create the first part by sending a read then the repeated start at the end
        tr_read = i2c_master_seq_item_c::type_id::create("tr_read");

        // Enable/Disable random clock stretching on master
        tr_read.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr_read.reasonable_sr_or_p_gen.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_read.reasonable_addr.constraint_mode(0);
        
        start_item(tr_read);
        tr_read.enable_clk_stretch_after_byte = i2c_master_read_sr_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read.randomize() with
        {
            tr_read.addr            == slave_address ;
            tr_read.cmd             == I2C_READ;
            tr_read.data.size()     == 1;
            tr_read.sr_or_p_gen     == 1;
            tr_read.send_start_byte == 0;
            tr_read.enable_clk_stretch_random_bit_level == i2c_master_read_sr_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);

        
        // Create the second part of the read
        tr_read2 = i2c_master_seq_item_c::type_id::create("tr_read2");

        // Enable/Disable random clock stretching on master
        tr_read2.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Disable address constraint
        if (addr_constraint_mode == 0) tr_read2.reasonable_addr.constraint_mode(0);
        
        start_item(tr_read2);
        tr_read2.enable_clk_stretch_after_byte = i2c_master_read_sr_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read2.randomize() with
        {
            tr_read2.addr            == slave_address;
            tr_read2.cmd             == I2C_READ;
            tr_read2.data.size()     == 1;
            tr_read2.sr_or_p_gen     == 0; // Stop
            tr_read2.send_start_byte == 0;
            tr_read2.enable_clk_stretch_random_bit_level == i2c_master_read_sr_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read2);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);
        
    endtask: body

endclass: i2c_master_read_sr_read_seq_c

class i2c_master_single_write_then_read_seq_c extends i2c_master_base_seq_c;
    `uvm_object_utils(i2c_master_single_write_then_read_seq_c)
    
    i2c_master_single_write_seq_c write_seq;
    i2c_master_single_read_seq_c read_seq;
    
    function new(string name = "Write then Read to same address");
        super.new(name);
    endfunction

    virtual task body();
        write_seq = i2c_master_single_write_seq_c::type_id::create("write_seq");
        read_seq = i2c_master_single_read_seq_c::type_id::create("read_seq");
        
        // Randomize the data byte
        assert(write_seq.randomize() with 
        { write_seq.enable_clk_stretch_random_bit_level == i2c_master_single_write_then_read_seq_c::enable_clk_stretch_random_bit_level; });
        
        // Set the subaddress
        write_seq.sub_address = this.sub_address;
        read_seq.sub_address = this.sub_address;
        
        // Set the master random clock stretchig
        write_seq.enable_clk_stretch_random_bit_level = enable_clk_stretch_random_bit_level;
        write_seq.enable_clk_stretch_after_byte = enable_clk_stretch_after_byte;
        read_seq.enable_clk_stretch_random_bit_level = enable_clk_stretch_random_bit_level;
        read_seq.enable_clk_stretch_after_byte = enable_clk_stretch_after_byte;

        // Run the sequences
        write_seq.start(m_sequencer);
        read_seq.start(m_sequencer);

    endtask

endclass

class i2c_master_unrecognize_slaveadddress_seq_c extends i2c_master_base_seq_c;
    `uvm_object_utils(i2c_master_unrecognize_slaveadddress_seq_c)
    
    i2c_master_single_write_seq_c write_seq_0;
    i2c_master_single_read_seq_c read_seq_0;
    
    i2c_master_single_write_seq_c write_seq_1;
    i2c_master_single_read_seq_c read_seq_1;
    
    function new(string name = "Write and read to unrecognize slave address");
        super.new(name);
    endfunction

    virtual task body();
        write_seq_0 = i2c_master_single_write_seq_c::type_id::create("write_seq_0");
        read_seq_0 = i2c_master_single_read_seq_c::type_id::create("read_seq_0");
        
        // Randomize the data byte
        assert(write_seq_0.randomize());
        
        // Set the write with correct slave address but wrong slave address for read operation 
        read_seq_0.slave_address = this.slave_address;
        
        // Set the subaddress
        write_seq_0.sub_address = this.sub_address;
        read_seq_0.sub_address = this.sub_address;
        
        // Set specific data byte
        write_seq_0.data_byte = 8'hF0;
        
        // no clock stretching
        // write_seq_0.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        // read_seq_0.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Run the sequences
        write_seq_0.start(m_sequencer);
        read_seq_0.start(m_sequencer);
        
        write_seq_1 = i2c_master_single_write_seq_c::type_id::create("write_seq_1");
        read_seq_1 = i2c_master_single_read_seq_c::type_id::create("read_seq_1");

        // Randomize the data byte
        assert(write_seq_1.randomize());
        
        // Set the wrong slave address for write operation but read with correct slave address
        write_seq_1.slave_address = this.slave_address;
        
        // Set the subaddress
        write_seq_1.sub_address = this.sub_address;
        read_seq_1.sub_address = this.sub_address;
        
        // Set specific data byte
        write_seq_1.data_byte = 8'h0F;
        
        // no clock stretching
        // write_seq_1.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        // read_seq_1.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        
        // Run the sequences
        write_seq_1.start(m_sequencer);
        read_seq_1.start(m_sequencer);
    endtask

endclass

class i2c_master_7bit_wr_nack_randdata_sequence extends svt_i2c_master_transaction_base_sequence;

    /** slave address */
    rand bit [`SVT_I2C_SLA_ADD_WIDTH-1:0] addr = `SVT_I2C_SLAVE0_ADDRESS;
    
    /** data size */
    rand int unsigned data_size = 1;
    
    /** repeated start and stop generation */
    rand bit sr_or_p_gen = 0;
    
    /** enable or disable retry_if_nack */
    rand bit retry_if_nack = 0;
    
    /** set the number of times master will retry */
    rand bit [2:0]  num_of_retry = 0;
    
    /** constraint on local variables */
    constraint reasonable_constraints {
        data_size inside {[1:5120]};
        retry_if_nack == 1;
        num_of_retry == 1;
        sr_or_p_gen == 0;
    }
    
    // Possible sub_address
    rand bit[7:0] sub_address = 8'b0000_0000;
    
    `svt_xvm_object_utils(i2c_master_7bit_wr_nack_randdata_sequence)
    
    /** Constructor */
    function new(string name = "i2c_master_7bit_wr_nack_randdata_sequence");
        super.new(name);
    endfunction: new      
    
    virtual task body();
        bit status;
        bit [`SVT_I2C_SLA_ADD_WIDTH-1:0] local_addr;
        int unsigned local_data_size;
        bit local_sr_or_p_gen;
        bit local_retry_if_nack;
        bit [2:0]  local_num_of_retry;
    
        super.body();

        status = uvm_config_db#(int unsigned)::get(m_sequencer, get_type_name(), "data_size",data_size);
        `svt_xvm_debug("body", $sformatf("data_size is %0d as a result of %0s.", data_size, status ? "config DB" : "randomization"));
        status = uvm_config_db#(bit[9:0])::get(m_sequencer, get_type_name(), "addr",addr);
        `svt_xvm_debug("body", $sformatf("addr is %0b as a result of %0s.", addr, status ? "config DB" : "randomization"));
        status = uvm_config_db#(bit)::get(m_sequencer, get_type_name(), "sr_or_p_gen",sr_or_p_gen);
        `svt_xvm_debug("body", $sformatf("sr_or_p_gen is %0d as a result of %0s.", sr_or_p_gen, status ? "config DB" : "randomization"));
        status = uvm_config_db#(bit)::get(m_sequencer, get_type_name(), "retry_if_nack",retry_if_nack);
        `svt_xvm_debug("body", $sformatf("retry_if_nack is %0d as a result of %0s.", retry_if_nack, status ? "config DB" : "randomization"));
        status = uvm_config_db#(bit[2:0])::get(m_sequencer, get_type_name(), "num_of_retry",num_of_retry);
        `svt_xvm_debug("body", $sformatf("num_of_retry is %0d as a result of %0s.", num_of_retry, status ? "config DB" : "randomization"));

        local_addr = this.addr;
        local_data_size = this.data_size;
        local_sr_or_p_gen = this.sr_or_p_gen;
        local_retry_if_nack = this.retry_if_nack;
        local_num_of_retry = this.num_of_retry;
        
        `svt_xvm_create(req)
        req.reasonable_data.constraint_mode(0);
        req.reasonable_addr.constraint_mode(0);
        req.reasonable_retry_if_nack.constraint_mode(0);
        req.reasonable_sr_or_p_gen.constraint_mode(0);
        `svt_xvm_rand_send_with( req, {
        req.addr            == local_addr;
        req.cmd             == `SVT_I2C_ENUM_CMD_SCOPE I2C_WRITE;
        req.data.size()     == local_data_size;
        req.sr_or_p_gen     == local_sr_or_p_gen ;
        req.send_start_byte == 0;  
        req.addr_10bit      == 0;
        req.retry_if_nack   == local_retry_if_nack ;
        req.num_of_retry    == local_num_of_retry; 
        req.data[0]         == sub_address;
        });
        
        /** 
        * Call get_response only if configuration attribute,
        * enable_put_response is set 1.
        */
        if(i2c_cfg.enable_put_response == 1)
            get_response(rsp);
        
    endtask: body
endclass: i2c_master_7bit_wr_nack_randdata_sequence

class i2c_slave_nack_addr_sequence_c extends i2c_random_slave_base_sequence_c;

    bit [31:0] nack_addr_count = 32'h0001;

    `uvm_object_utils(i2c_slave_nack_addr_sequence_c)
    
    function new(string name="i2c_slave_nack_addr_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();        
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_nack_addr.constraint_mode(0);
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             tx_xacts_s.nack_addr == 1;
                             tx_xacts_s.nack_addr_count == nack_addr_count;
                             })     
        
    endtask

endclass : i2c_slave_nack_addr_sequence_c

class i2c_slave_nack_data_sequence_c extends i2c_random_slave_base_sequence_c; 

    /** nack for data */
    bit [31:0] nack_data = 32'h0001;

    `uvm_object_utils(i2c_slave_nack_data_sequence_c)
    
    function new(string name = "i2c_slave_nack_data_sequence_c");
        super.new(name);
    endfunction: new 
    
    virtual task create_seq();        
        `uvm_create(tx_xacts_s)

        tx_xacts_s.nack_data = nack_data;     
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             })    

    endtask
endclass:i2c_slave_nack_data_sequence_c

// Create a multiple byte write transaction 
class i2c_master_random_multiplebyte_write_seq_c extends i2c_master_base_seq_c;
    
    rand int data_size = 2;
    
    `uvm_object_utils(i2c_master_random_multiplebyte_write_seq_c)
    
    constraint reasonable_data_size{
        data_size inside {[2:31]};
    }
    
    function new(string name="i2c write operation with multiple bytes");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr.reasonable_data.constraint_mode(0);
        
        start_item(tr);
        tr.enable_clk_stretch_after_byte = i2c_master_random_multiplebyte_write_seq_c::enable_clk_stretch_after_byte;
        assert(tr.randomize() with
                     {
            tr.addr            == slave_address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == data_size;
            tr.data[0]         == sub_address; 
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
            tr.enable_clk_stretch_random_bit_level == i2c_master_random_multiplebyte_write_seq_c::enable_clk_stretch_random_bit_level;
        });
        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_random_multiplebyte_write_seq_c

class i2c_nack_slave_sequence_c extends i2c_random_slave_base_sequence_c;

    `uvm_object_utils(i2c_nack_slave_sequence_c)
    
    function new(string name="i2c_nack_slave_sequence_c");
        super.new(name);
    endfunction: new 

    virtual task create_seq();
        
        `uvm_create(tx_xacts_s)
        tx_xacts_s.reasonable_nack_addr.constraint_mode(0);
        
        `uvm_rand_send_with(tx_xacts_s, 
                            {
                             tx_xacts_s.nack_addr == 1;
                             tx_xacts_s.nack_addr_count == 2;
                             })     
        
    endtask

endclass : i2c_nack_slave_sequence_c


class i2c_master_eeprom_write_seq_c extends i2c_master_base_seq_c;
   
    rand bit[7:0] data[];
    //rand bit [9:0]slave_address; 
    rand bit [9:0]address; 
     `uvm_object_utils(i2c_master_eeprom_write_seq_c)

    function new(string name="i2c_master_eeprom_write_seq_c");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    // Drop an objection if this is the parent sequence
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        
        // Do a simple write to the subaddress
        i2c_master_seq_item_c tr;
        tr = i2c_master_seq_item_c::type_id::create("tr");
        
        // Enable/disable random clock stretching on master
        tr.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr.reasonable_data.constraint_mode(0);
        tr.reasonable_addr.constraint_mode(0);
        // Disable address constraint
        //if (addr_constraint_mode == 0) tr.reasonable_addr.constraint_mode(0);
        
        start_item(tr);
        //tr.enable_clk_stretch_after_byte = i2c_master_single_write_seq_c::enable_clk_stretch_after_byte;
        tr.randomize() with
        {
            tr.addr            == address;
            tr.cmd             == I2C_WRITE;
            tr.data.size()     == 5; // Data size 2 byte of EEPROM address +4 bytes of data
            tr.data[0]         == 8'h00;  
           // tr.data[1]         == 8'h00;
            tr.sr_or_p_gen     == 0; // Stop
            tr.send_start_byte == 0;
           // tr.enable_clk_stretch_random_bit_level == i2c_master_single_write_seq_c::enable_clk_stretch_random_bit_level;  
        };
  
        for (int i=1; i<tr.data.size(); i++) begin
            tr.data[i] = data[i-1];
        end

        finish_item(tr);

        // Get the transaction response
        // Is this still neeeded?
        get_response(rsp);

        
    endtask: body
    
endclass: i2c_master_eeprom_write_seq_c

class i2c_master_eeprom_read_seq_c extends i2c_master_base_seq_c;

    bit [7:0] dataout[$];
   rand bit [7:0]len;
    rand bit [9:0]address; 
   `uvm_object_utils(i2c_master_eeprom_read_seq_c)

    function new(string name="i2c_master_eeprom_read_seq_c");
        super.new(name);
    endfunction: new
    
    // Raise an objection if this is the parent sequence
    virtual task pre_body();
        uvm_phase phase;
        super.pre_body();
        phase = get_starting_phase();
        if (phase!=null) begin
            phase.raise_objection(this);
        end
    endtask: pre_body
    
    /** Drop an objection if this is the parent sequence */
    virtual task post_body();
        uvm_phase phase;
        super.post_body();
        phase = get_starting_phase();
        
        if (phase!=null) begin
            phase.drop_objection(this);
        end
    endtask: post_body
    
    virtual task body();
        i2c_master_seq_item_c tr_write;
        i2c_master_seq_item_c tr_read;


        // Create the first part of the read operation by sending a write
        // with the subaddress and then the repeated start at the end
        tr_write = i2c_master_seq_item_c::type_id::create("tr_write");

        // Enable/Disable random clock stretching on master
        tr_write.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr_write.reasonable_data.constraint_mode(0);
        tr_write.reasonable_addr.constraint_mode(0);
        tr_write.reasonable_sr_or_p_gen.constraint_mode(0);
        start_item(tr_write);
        //tr_write.enable_clk_stretch_after_byte = i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_write.randomize() with
        {
            tr_write.addr            == address;
            tr_write.cmd             == I2C_WRITE;
            tr_write.data.size()     == 1;
            tr_write.data[0]         == 'h00;  
            //tr_write.data[1]         == 'h00;  
            tr_write.sr_or_p_gen     == 1; //Repeated Start
            tr_write.send_start_byte == 0;
            //tr_write.enable_clk_stretch_random_bit_level == i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_write);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);

        
        // Create the second part of the read, which is the actual read
        tr_read = i2c_master_seq_item_c::type_id::create("tr_read");

        // Enable/Disable random clock stretching on master
        tr_read.reasonable_enable_clk_stretch_random_bit_level.constraint_mode(0);
        tr_read.reasonable_data.constraint_mode(0);
       tr_read.reasonable_addr.constraint_mode(0);
 
        start_item(tr_read);
        //tr_read.enable_clk_stretch_after_byte = i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_after_byte;
        assert(tr_read.randomize() with
        {
            tr_read.addr            == address ;
            tr_read.cmd             == I2C_READ;
            tr_read.data.size()     == len;
            tr_read.sr_or_p_gen     == 0; // Stop
            tr_read.send_start_byte == 0;
            //tr_read.enable_clk_stretch_random_bit_level == i2c_master_multiplebyte_read_seq_c::enable_clk_stretch_random_bit_level;  
        });
        finish_item(tr_read);

        // Get the transaction response
        // Is this still needed?
        get_response(rsp);
      
      `uvm_info(get_name(), $sformatf("LENGTH:-%h",len), UVM_LOW)

       foreach(rsp.data[i]) begin
	dataout[i]=rsp.data[i];
       end
        
      
    endtask: body

endclass: i2c_master_eeprom_read_seq_c



`endif
