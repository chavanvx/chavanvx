`ifndef INC_I2C_SLAVE_SEQ_ITEM_SV
`define INC_I2C_SLAVE_SEQ_ITEM_SV

// Override the design_ware I2C slave transaction to change the constraints and defaults
class i2c_slave_seq_item_c extends svt_i2c_slave_transaction ;
    `uvm_object_utils(i2c_slave_seq_item_c)
    
    // Do we need this?
    //constraint reasonable_nack_addr_count {
    //    nack_addr_count inside {[1:10]};
    //}
    
    // Data can be 1 or 2
    constraint reasonable_data {
        data.size() inside {[1:2]};
    }
    
   
    
    function new(string name ="i2c_slave_seq_item" );
        super.new(name);
    endfunction
    
endclass


`endif
