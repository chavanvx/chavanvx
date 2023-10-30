

class base_seq extends uvm_sequence;

`uvm_object_utils(base_seq)
 `uvm_declare_p_sequencer(virtual_sequencer)


function new(string name = "base_seq");
        super.new(name);
    endfunction : new

task body();
        super.body();

endtask


task write_eeprom(input bit [7:0]data_in[4],input bit [6:0]addr , input bit [1:0] controller='h0);
  i2c_master_eeprom_write_seq_c wr_seq;
  svt_i2c_master_transaction_sequencer v_sqr;
 if(controller == 'h0) begin 
   v_sqr=p_sequencer.i2c_ctrl0_mstr_seqr;
  `uvm_info(get_name(), $sformatf("Write transcation initiated on BUS_0"), UVM_LOW);
   end
 else begin 
    v_sqr=p_sequencer.i2c_ctrl1_mstr_seqr;
  `uvm_info(get_name(), $sformatf("Write transcation initiated on BUS_1"), UVM_LOW);
 end
 `uvm_do_on_with(wr_seq, v_sqr,{ 
           address  == addr;
           data.size() == 4;
           foreach(data[i]) { data[i] == data_in[i]; }
       })

endtask
 
task read_eeprom(input bit [7:0]len , input [6:0]addr ,output bit [7:0]data[16] , input bit [1:0] controller='h0);
  i2c_master_eeprom_read_seq_c rd_seq;
  svt_i2c_master_transaction_sequencer v_sqr;
  if(controller == 'h0) begin 
   v_sqr=p_sequencer.i2c_ctrl0_mstr_seqr;
  `uvm_info(get_name(), $sformatf("Read transcation initiated on BUS_0"), UVM_LOW);
   end
  else begin 
    v_sqr=p_sequencer.i2c_ctrl1_mstr_seqr;
  `uvm_info(get_name(), $sformatf("Read transcation initiated on BUS_1"), UVM_LOW);
  end

  `uvm_do_on_with(rd_seq ,v_sqr,{
                 address == addr;
                 len == len; 
      })
 for(int i=0 ; i<len ;i++) begin
    data[i]=rd_seq.dataout[i];
  end

endtask
 
endclass
