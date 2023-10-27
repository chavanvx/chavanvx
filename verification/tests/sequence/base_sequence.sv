

class base_seq extends uvm_sequence;

`uvm_object_utils(base_seq)
 `uvm_declare_p_sequencer(virtual_sequencer)


function new(string name = "base_seq");
        super.new(name);
    endfunction : new

task body();
        super.body();

endtask


task write_eeprom(input bit [7:0]data_in[4],input bit [6:0]addr);
  i2c_master_eeprom_write_seq_c wr_seq;
 `uvm_do_on_with(wr_seq, p_sequencer.i2c_mstr_seqr,{ 
           address  == addr;
           data.size() == 4;
           foreach(data[i]) { data[i] == data_in[i]; }
       })

endtask
 
task read_eeprom(input bit [7:0]len , input [6:0]addr ,output bit [7:0]data[16]);
  i2c_master_eeprom_read_seq_c rd_seq;
  `uvm_info(get_name(), $sformatf("LENGTH:-%h",len), UVM_LOW)
  `uvm_do_on_with(rd_seq ,p_sequencer.i2c_mstr_seqr,{
                 address == addr;
                 len == len; 
      })
 for(int i=0 ; i<len ;i++) begin
    data[i]=rd_seq.dataout[i];
  end

endtask
 
endclass
