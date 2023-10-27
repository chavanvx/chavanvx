`ifndef INC_I2C_MASTER_SEQ_ITEM_SV
`define INC_I2C_MASTER_SEQ_ITEM_SV

// Override the design_ware I2C master transaction to change the constraints and defaults
class i2c_master_seq_item_c extends svt_i2c_master_transaction ;
    `uvm_object_utils(i2c_master_seq_item_c)
    
    constraint reasonable_data {
        if (cmd == I2C_WRITE)
            if (sr_or_p_gen == 1)
                // If a write as the first part of a write-read, the n the
                // write has size 1
                data.size() == 1;
            else
                // A normal write has size 2. The subaddress then the data
                data.size() == 2;
        else
            // A read is always size 1
            data.size() == 1;
    }
    
    constraint reasonable_sr_or_p_gen {
        if (cmd == I2C_WRITE)
            if (data.size == 1)
                // If the data size is 1 then repeated start is required
                sr_or_p_gen == 1;
            else
                sr_or_p_gen == 0;
        else
            // A read is always with a stop
            sr_or_p_gen == 0;
    }
    
    bit ignore_comparison = 0;
    
    function new(string name ="i2c_master_seq_item" );
        super.new(name);
    endfunction
    
endclass


`endif
