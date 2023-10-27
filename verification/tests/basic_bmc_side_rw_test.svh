
class basic_bmc_side_rw_test extends base_test;

 `uvm_component_utils(basic_bmc_side_rw_test)

 
    function new(string name, uvm_component parent);
        super.new(name, parent);
        
        // Specify the description of this test
        
    endfunction
function void build_phase(uvm_phase phase);
        super.build_phase(phase);

endfunction

task run_phase(uvm_phase phase);
     basic_bmc_side_rw_seq m_seq;

     super.run_phase(phase);
	phase.raise_objection(this);
	m_seq = basic_bmc_side_rw_seq::type_id::create("m_seq");
        m_seq.randomize();
	m_seq.start(tb_env0.vseqr);
	phase.drop_objection(this);

endtask

endclass
