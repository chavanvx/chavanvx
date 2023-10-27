
class virtual_sequencer extends uvm_sequencer;
`uvm_component_utils(virtual_sequencer)

svt_i2c_master_transaction_sequencer i2c_mstr_seqr;
svt_i2c_slave_transaction_sequencer i2c_slv_seqr;
function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass
