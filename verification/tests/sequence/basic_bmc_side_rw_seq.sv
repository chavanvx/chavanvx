
class basic_bmc_side_rw_seq extends base_seq;
 `uvm_object_utils(basic_bmc_side_rw_seq)
 `uvm_declare_p_sequencer(virtual_sequencer)


    function new (string name = "he_hssi_axis_rx_lpbk_seq");
        super.new(name);
    endfunction : new


    task body();

	bit [7:0]data[];
	bit [6:0]s_addr;
	bit [7:0] len;
	bit [7:0]rdata[];        
	super.body();

	`uvm_info(get_name(), "Entering sequence...", UVM_LOW)
  
         data =new[4];
         data[0] = 'h55;
         data[1] = 'h66;
         data[2] = 'h77;
         data[3] = 'h88;
         s_addr = 'h5a;
         write_eeprom(data,s_addr);
       
        foreach (data[i])begin
	 `uvm_info(get_name(), $sformatf("DATA_WRITTEN ..data[%h]=%h",i,data[i]), UVM_LOW)
	end

        len='h4;
        rdata=new[len];
       	read_eeprom(len,s_addr,rdata);

       foreach (rdata[i])begin
  	 `uvm_info(get_name(), $sformatf("DATA_WRITTEN ..rdata[%h]=%h",i,rdata[i]), UVM_LOW)
	end

   endtask

endclass
