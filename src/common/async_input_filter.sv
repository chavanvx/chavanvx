// (C) 2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

//
// async_input filter
//
// This module accepts an asynchronous input, passes it through a parameterized number of metastability
// hardening registers, then through a chain of 'filter' registers.  The output only changes value
// when all the filter registers have the same value.  Thus, any glitches that last fewer clock cycles
// than the number of filter registers will be ignored.
//
// The block also has dedicated outputs indicating rising edge and falling edge.  These outputs are
// asserted on the same clock cycle as the 'new' output.  Thus o_rising_edge is asserted on the same
// clock cycle that o_sync_out is first set to 1.
//
// Total delay through this block is NUM_METASTABILITY_REGS + NUM_FILTER_REGS + 1 clock cycles.
//
// Note that this block has no RESET input.  This is by design as we don't want to generate any false
// rising_edge/falling_edge signals after we come out of reset (for example, if we reset all internal
// registers to 0 and the input is a stable '1' during reset, we will see a rising edge several clock cycles
// after reset is released).  As long as the inputs go through a stable period while the rest of your circuit
// is in reset, then this block will have stable values when everything comes out of reset.  During simulation,
// just make sure the async_in port is not toggling during the reset period, and the reset period lasts longer
// than the latency through this block, and none of the outputs will be 'X' when the reset period has finished.

`timescale 1 ps / 1 ps
`default_nettype none

module async_input_filter #(
    parameter NUM_METASTABILITY_REGS    = 2,            // number of registers to add for metastability hardening
    parameter NUM_FILTER_REGS           = 5             // number of registers for filtering glitches (must be >1), input must be stable for this many clocks before the output will switch
) (
    input  wire             clock,                      // master clock for this block
    input  wire             ia_async_in,                // intput to be synchronized and filtered
    output logic            o_sync_out,                 // output synchronized and filtered to remove glitches < NUM_FILTER_REGS clocks in length
    output logic            o_rising_edge,              // asserted for one clock cycle, simultaneous with the first 1 output on sync out after a 0
    output logic            o_falling_edge              // asserted for one clock cycle, simultaneous with the first 0 output on sync out after a 1
);

    // QuartusII synthesis directives:
    //     1. Prevent the compiler from altering the node or entity
    //     2. Preserve all registers ie. do not touch them.
    //     3. Do not merge other flip-flops with synchronizer flip-flops.
    // QuartusII TimeQuest directives:
    //     1. Identify all flip-flops in this module as members of the synchronizer 
    //        to enable automatic metastability MTBF analysis.
    (* altera_attribute = {"-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON"} *) logic [NUM_METASTABILITY_REGS:1] metastability_regs;
    logic [NUM_FILTER_REGS:1]           filter_regs;
    logic                               filtered_out;  
    
    // Metastability registers (includes case where 0 metastability registers are requested)
    generate
        
        // if 0 metastability registers requested just pass the input straight through
        if (NUM_METASTABILITY_REGS==0) begin            : GEN_ZERO_METASTABILITY_REGS        

            assign metastability_regs[1] = ia_async_in;

        // create a chain of metastability registers (includes case where only a single register is needed)
        end else begin                                  : GEN_METASTABILITY_REGS
        
            always_ff @(posedge clock ) begin
                metastability_regs[NUM_METASTABILITY_REGS] <=  ia_async_in;         // first metastability register
                for (int i=NUM_METASTABILITY_REGS-1; i>0; i--) begin
                    metastability_regs[i] <= metastability_regs[i+1];
                end
            end
            
        end
        
    endgenerate
    
    // filter out glitches
    always_ff @(posedge clock ) begin
    
        filter_regs <= {metastability_regs[1], filter_regs[NUM_FILTER_REGS:2]};
        
        // only assign a new value to filtered_out when all filtered_regs registers are equal
        if (filter_regs == {NUM_FILTER_REGS{1'b1}}) begin
            filtered_out <= '1;
        end else if (filter_regs == {NUM_FILTER_REGS{1'b0}}) begin
            filtered_out <= '0;
        end else begin
            filtered_out <= filtered_out;       // hold previous value, this line of code unnecessary but added for clarity
        end
        
        o_sync_out <= filtered_out;             // one more clock cycle of delay before reaching the output, so the output changes the same time the edge output signals are asserted
        
        // check for rising and falling edges
        
        if( filtered_out & ~o_sync_out ) begin
            o_rising_edge <= '1;
        end else begin
            o_rising_edge <= '0;
        end
        
        if( ~filtered_out & o_sync_out ) begin
            o_falling_edge <= '1;
        end else begin
            o_falling_edge <= '0;
        end
        
    end
    
endmodule