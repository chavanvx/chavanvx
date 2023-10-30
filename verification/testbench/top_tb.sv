`timescale 1 ps / 1 ps
`default_nettype none

//`include "altr_cmn_macros.sv"

/** Include UVM Package */
`include "uvm_pkg.sv"

`default_nettype wire
// Include the Design Ware IP
//---------------------------------------------
/** Include the I2C SVT UVM package */
`include "svt_i2c.uvm.pkg"

// Toplevel I2C interface
`include "svt_i2c_if.svi"
//---------------------------------------------
//`default_nettype none

// Slave Wrapper Instantiation, use macro to save typing
/*`define SLAVE_WRAPPER_INST(INDEX, INDEX_ADD_ONE) \
    svt_i2c_slave_wrapper #(.I2C_AGENT_ID(``INDEX), \
                            .I2C_SLAVE_ADDRESS(SMBUS_RELAY_ADDRESS[``INDEX_ADD_ONE]), \
                            .I2C_NVS_INST_NAME("SLV``INDEX"), \
                            .I2C_RESPOND_TO_GEN_CALL(0) \
                           ) i2c_slv1_slave``INDEX (i2c_if_ctrl1);*/
 import svt_i2c_uvm_pkg::*;
   import svt_i2c_enum_pkg::*;

`include "i2c_reset_if.svi" 
`include "i2c_ctrl0_i2c_system_configuration.sv"
`include "i2c_ctrl1_i2c_system_configuration.sv"
`include "virtual_sequencer.sv"
`include "sequence_lib.svh"
`include "tb_env.sv"
`include "test_pkg.sv"
module top_tb();

   /** Import the SVT UVM Package */
   import svt_uvm_pkg::*;
   
   /** Import I2C SVT Packages */
   import svt_i2c_uvm_pkg::*;
   import svt_i2c_enum_pkg::*;


//==================================================================================================
// Parameters
//==================================================================================================
localparam CLOCK_PERIOD_PS = test_cfg_pkg::I2C_FILTER_TOP_CLOCK_PERIOD_PS; // 10000ps = 100 MHz
localparam BUS_SPEED_KHZ = test_cfg_pkg::I2C_FILTER_TOP_BUS_SPEED_KHZ;
localparam FILTER_ENABLE = test_cfg_pkg::I2C_FILTER_TOP_FILTER_ENABLE;
localparam RELAY_ALL_ADDRESSES = test_cfg_pkg::I2C_FILTER_TOP_RELAY_ALL_ADDRESSES;
localparam NUM_RELAY_ADDRESSES = test_cfg_pkg::I2C_FILTER_TOP_NUM_RELAY_ADDRESSES;
localparam NUM_MASTER          = test_cfg_pkg::I2C_FILTER_TOP_NUM_MASTER;
localparam IGNORED_ADDR_BITS = test_cfg_pkg::I2C_FILTER_TOP_IGNORED_ADDR_BITS;
localparam [NUM_RELAY_ADDRESSES:1][6:0] SMBUS_RELAY_ADDRESS = test_cfg_pkg::I2C_FILTER_TOP_SMBUS_RELAY_ADDRESS;
localparam SCL_LOW_TIMEOUT_PERIOD_MS = test_cfg_pkg::I2C_FILTER_TOP_SCL_LOW_TIMEOUT_PERIOD_MS;
localparam MCTP_OUT_OF_BAND_ENABLE = test_cfg_pkg::I2C_FILTER_TOP_MCTP_OUT_OF_BAND_ENABLE;
covergroup cg_input_parametrization;

endgroup: cg_input_parametrization

cg_input_parametrization input_parametrization;


// BFM Wires

// Clock and reset
wire system_reset;
wire dut_reset;
logic system_clk;
logic dut_clk;


// Instantiate the I2C interface
svt_i2c_if i2c_if_ctrl0(system_clk);
assign i2c_if_ctrl0.RST = system_reset;

svt_i2c_if i2c_if_mstr2(system_clk);
assign i2c_if_mstr2.RST = system_reset;

svt_i2c_if i2c_if_ctrl1(system_clk);
assign i2c_if_ctrl1.RST = system_reset;

//relay_sideband_if relay_sideband_if_1(system_clk, system_reset);

// Instantiate I2C master and slave wrapper. You must define both even though
// we only use the master
svt_i2c_master_wrapper #(.I2C_AGENT_ID(0)) i2c_ctrl0_master0 (i2c_if_ctrl0);
svt_i2c_slave_wrapper #(.I2C_AGENT_ID(0)) i2c_ctrl0_slave0 (i2c_if_ctrl0);
//svt_i2c_master_wrapper #(.I2C_AGENT_ID(0)) i2c_mstr2_master0 (i2c_if_mstr2);
//svt_i2c_slave_wrapper #(.I2C_AGENT_ID(0)) i2c_mstr1_slave0 (i2c_if_ctrl0);
//svt_i2c_slave_wrapper #(.I2C_AGENT_ID(0)) i2c_mstr2_slave0 (i2c_if_mstr2);

// Instantiate I2C master and slave wrapper. You must define both even though
// we only use the slave
svt_i2c_slave_wrapper #(.I2C_AGENT_ID(0)) i2c_ctrl1_slave0 (i2c_if_ctrl1);
svt_i2c_master_wrapper #(.I2C_AGENT_ID(0)) i2c_ctrl1_master0 (i2c_if_ctrl1);

// Use generate statement to instantiate slave wrapper as number of slave wrapper
// needed is depends on NUM_RELAY_ADDRESSES setting
//genvar i;
//generate
//    for (i = 0; i < NUM_RELAY_ADDRESSES; i++) begin : slave_wrapper_inst
// //       `SLAVE_WRAPPER_INST(i, i+1)
//    end
//endgenerate

//BFM reset interface
i2c_reset_if i2c_reset_if();

// BFM Wires

// BFM -> Monitor
wire [test_cfg_pkg::I2C_FILTER_TOP_AVMM_BFM_AV_DATA_W-1:0] bfm_i2c_filter_master_top_avmm_readdata;
wire [test_cfg_pkg::I2C_FILTER_TOP_AVMM_BFM_AV_DATA_W-1:0] bfm_i2c_filter_master_top_avmm_writedata;
wire [test_cfg_pkg::I2C_FILTER_TOP_AVMM_BFM_AV_ADDRESS_W-1:0] bfm_i2c_filter_master_top_avmm_address;
wire bfm_i2c_filter_master_top_avmm_write;
wire bfm_i2c_filter_master_top_avmm_read;

// Monitor -> DUT
wire [test_cfg_pkg::I2C_FILTER_TOP_AVMM_BFM_AV_DATA_W-1:0] dut_i2c_filter_master_top_avmm_readdata;
wire [test_cfg_pkg::I2C_FILTER_TOP_AVMM_BFM_AV_DATA_W-1:0] dut_i2c_filter_master_top_avmm_writedata;
wire [test_cfg_pkg::I2C_FILTER_TOP_AVMM_BFM_AV_ADDRESS_W-1:0] dut_i2c_filter_master_top_avmm_address;
wire dut_i2c_filter_master_top_avmm_write;
wire dut_i2c_filter_master_top_avmm_read;

// Drive some value to avoid warning
assign dut_i2c_filter_master_top_avmm_readdata = {(test_cfg_pkg::I2C_FILTER_TOP_AVMM_BFM_AV_DATA_W){1'b0}};
/*//==================================================================================================
// Region Driver BFM
//==================================================================================================
// -------------------------------------------------------------------
// Instantiate avalon_mm master bfm
// -------------------------------------------------------------------
i2c_filter_top_avalon_mm_master_bfm i2c_filter_master_top_avmm_bfm
(
 .clk                      (dut_clk),
 .reset                    (dut_reset),
 .avm_address              (bfm_i2c_filter_master_top_avmm_address),
 .avm_readdata             (bfm_i2c_filter_master_top_avmm_readdata),
 .avm_writedata            (bfm_i2c_filter_master_top_avmm_writedata),
 .avm_write                (bfm_i2c_filter_master_top_avmm_write),
 .avm_read                 (bfm_i2c_filter_master_top_avmm_read)
 );


//==================================================================================================
// Region Monitor BFM
//==================================================================================================
// -------------------------------------------------------------------
// Instantiate avalon_mm monitor bfm
// -------------------------------------------------------------------
i2c_filter_top_avalon_mm_monitor_bfm i2c_filter_master_top_avmm_monitor
(
 .clk                      (dut_clk),
 .reset                    (dut_reset),

 .avs_address              (bfm_i2c_filter_master_top_avmm_address),
 .avs_readdata             (bfm_i2c_filter_master_top_avmm_readdata),
 .avs_writedata            (bfm_i2c_filter_master_top_avmm_writedata),
 .avs_write                (bfm_i2c_filter_master_top_avmm_write),
 .avs_read                 (bfm_i2c_filter_master_top_avmm_read),

 .avm_address              (dut_i2c_filter_master_top_avmm_address),
 .avm_readdata             (dut_i2c_filter_master_top_avmm_readdata),
 .avm_writedata            (dut_i2c_filter_master_top_avmm_writedata),
 .avm_write                (dut_i2c_filter_master_top_avmm_write),
 .avm_read                 (dut_i2c_filter_master_top_avmm_read)
 );*/

//==================================================================================================
// DUT
//==================================================================================================


    // logic to implement the open-drain pins for scl/sda on the slave and master busses
    logic dut_master_scl_in;
    logic dut_master_scl_oe;
    logic dut_master_sda_in;
    logic dut_master_sda_oe;
    logic dut_slave_scl_in ;
    logic dut_slave_scl_oe ;
    logic dut_slave_sda_in ;
    logic dut_slave_sda_oe ;
    logic dut_filter_disable;
    logic dut_block_disable;
    logic dut_relay_all_addresses;
    logic dut_swap_slave_to_master;
    
    logic dut_master_scl_in_2;
    logic dut_master_scl_oe_2;
    logic dut_master_sda_in_2;
    logic dut_master_sda_oe_2;
    logic dut_slave_scl_in_2 ;
    logic dut_slave_scl_oe_2 ;
    logic dut_slave_sda_in_2 ;
    logic dut_slave_sda_oe_2 ;

    logic dut_master1_lost;
    logic dut_master2_lost;
    
    //assign dut_master1_lost = relay_sideband_if_1.master1_lost;
    //assign dut_master2_lost = relay_sideband_if_1.master2_lost;
    //assign dut_swap_slave_to_master = relay_sideband_if_1.swap_slave_to_master;
    assign dut_master1_lost = 1'b0;
    assign dut_master2_lost = 1'b0;
    assign dut_swap_slave_to_master = 1'b0;
    assign dut_master_scl_in        = dut_swap_slave_to_master ? i2c_if_ctrl1.SCL : i2c_if_ctrl0.SCL;
    assign dut_master_sda_in        = dut_swap_slave_to_master ? i2c_if_ctrl1.SDA : i2c_if_ctrl0.SDA;
    assign dut_master_scl_in_2      = i2c_if_mstr2.SCL;
    assign dut_master_sda_in_2      = i2c_if_mstr2.SDA;
    assign dut_slave_scl_in         = dut_swap_slave_to_master ? i2c_if_ctrl0.SCL : i2c_if_ctrl1.SCL;
    assign dut_slave_sda_in         = dut_swap_slave_to_master ? i2c_if_ctrl0.SDA : i2c_if_ctrl1.SDA;
    assign dut_slave_scl_in_2       = i2c_if_ctrl1.SCL;
    assign dut_slave_sda_in_2       = i2c_if_ctrl1.SDA;
    assign i2c_if_ctrl0.SCL         = dut_swap_slave_to_master ? (dut_slave_scl_oe ? 1'b0 : 1'bz) : (dut_master_scl_oe ? 1'b0 : 1'bz);
    assign i2c_if_ctrl0.SDA         = dut_swap_slave_to_master ? (dut_slave_sda_oe ? 1'b0 : 1'bz) : (dut_master_sda_oe ? 1'b0 : 1'bz);
    assign i2c_if_mstr2.SCL         = dut_master_scl_oe_2 ? 1'b0 : 1'bz;
    assign i2c_if_mstr2.SDA         = dut_master_sda_oe_2 ? 1'b0 : 1'bz;
    assign i2c_if_ctrl1.SCL          = dut_swap_slave_to_master ? (dut_master_scl_oe ? 1'b0 : 1'bz) : (dut_slave_scl_oe  ? 1'b0 : 1'bz);
    assign i2c_if_ctrl1.SDA          = dut_swap_slave_to_master ? (dut_master_sda_oe ? 1'b0 : 1'bz) : (dut_slave_sda_oe  ? 1'b0 : 1'bz);
    assign i2c_if_ctrl1.SCL          = dut_slave_scl_oe_2  ? 1'b0 : 1'bz;
    assign i2c_if_ctrl1.SDA          = dut_slave_sda_oe_2  ? 1'b0 : 1'bz;
    //assign dut_filter_disable       = relay_sideband_if_1.filter_disable;
    //assign dut_block_disable        = relay_sideband_if_1.block_disable;
    //assign dut_relay_all_addresses  = relay_sideband_if_1.relay_all_addresses;
    assign dut_filter_disable       = 1'b0; 
    assign dut_block_disable        = 1'b0;
    assign dut_relay_all_addresses  = 1'b0;
    
    // Monitor master1 and master2 smbus transactions in relay1 and relay2 respectively. Monitor both smbus bus and perform SVA checkings
  /*  smbus_bus_monitor smbus_bus_check (
        .smbus_mon_clk                      (dut_clk),
        .smbus_mon_resetn                   (!dut_reset),
        .smbus_mon_master1_scl              (dut_master_scl_in),
        .smbus_mon_master1_sda              (dut_master_sda_in),
        .smbus_mon_master1_master_start     (u_smbus_filtered_relay_1.master_start),
        .smbus_mon_master1_master_stop      (u_smbus_filtered_relay_1.master_stop),
        .smbus_mon_master1_arbitration_lost (u_smbus_filtered_relay_1.arbitration_lost),
        .smbus_mon_master1_command_rd_wrn   (u_smbus_filtered_relay_1.command_rd_wrn),
        .smbus_mon_master1_lost             (dut_master1_lost),
        .smbus_mon_master2_scl              (dut_master_scl_in_2),
        .smbus_mon_master2_sda              (dut_master_sda_in_2),
        .smbus_mon_master2_master_start     (u_smbus_filtered_relay_2.master_start),
        .smbus_mon_master2_master_stop      (u_smbus_filtered_relay_2.master_stop),
        .smbus_mon_master2_arbitration_lost (u_smbus_filtered_relay_2.arbitration_lost),
        .smbus_mon_master2_command_rd_wrn   (u_smbus_filtered_relay_2.command_rd_wrn),
        .smbus_mon_master2_lost             (dut_master2_lost)
    );*/
    
    // Instantaite the relay block with no address or command filtering enabled
    smbus_filtered_relay #(
        .FILTER_ENABLE              ( FILTER_ENABLE                          ),         // do not perform command filtering
        .CLOCK_PERIOD_PS            ( CLOCK_PERIOD_PS                        ),
        .BUS_SPEED_KHZ              ( BUS_SPEED_KHZ                          ),
        .NUM_RELAY_ADDRESSES        ( NUM_RELAY_ADDRESSES                    ),         // since we are in permissive mode, set 1 address, and set it to a value of 0 (will be ignored anyway)
        .IGNORED_ADDR_BITS          ( IGNORED_ADDR_BITS                      ),
        .SMBUS_RELAY_ADDRESS        ( SMBUS_RELAY_ADDRESS                    ),
        .SCL_LOW_TIMEOUT_PERIOD_MS  ( SCL_LOW_TIMEOUT_PERIOD_MS              ),
        .MCTP_OUT_OF_BAND_ENABLE    ( MCTP_OUT_OF_BAND_ENABLE                )
    ) u_smbus_filtered_relay_1 (
        .clock              ( dut_clk            ),
        .i_resetn           ( !dut_reset         ),
        .i_block_disable    ( dut_block_disable  ),
        .i_filter_disable   ( dut_filter_disable ),
        .i_relay_all_addresses(dut_relay_all_addresses),
        .start2stop_gen     (1'b0),
        .rfnvram_sda_oe     (1'b0),
        .ia_master_scl      ( dut_master_scl_in  ),
        .o_master_scl_oe    ( dut_master_scl_oe  ),
        .ia_master_sda      ( dut_master_sda_in  ),
        .o_master_sda_oe    ( dut_master_sda_oe  ),
        .ia_slave_scl       ( dut_slave_scl_in   ),
        .o_slave_scl_oe     ( dut_slave_scl_oe   ),
        .ia_slave_sda       ( dut_slave_sda_in   ),
        .o_slave_sda_oe     ( dut_slave_sda_oe   ),
        .i_avmm_write       ( bfm_i2c_filter_master_top_avmm_write     ),
        .i_avmm_address     ( bfm_i2c_filter_master_top_avmm_address   ),
        .i_avmm_writedata   ( bfm_i2c_filter_master_top_avmm_writedata )
    );

    // Instantaite the relay block with no address or command filtering enabled
    smbus_filtered_relay #(
        .FILTER_ENABLE              ( FILTER_ENABLE                          ),         // do not perform command filtering
        .RELAY_ALL_ADDRESSES        ( RELAY_ALL_ADDRESSES                    ),         // allow all addresses to pass through the relay
        .CLOCK_PERIOD_PS            ( CLOCK_PERIOD_PS                        ),
        .BUS_SPEED_KHZ              ( BUS_SPEED_KHZ                          ),
        .NUM_RELAY_ADDRESSES        ( NUM_RELAY_ADDRESSES                    ),         // since we are in permissive mode, set 1 address, and set it to a value of 0 (will be ignored anyway)
        .IGNORED_ADDR_BITS          ( IGNORED_ADDR_BITS                      ),
        .SMBUS_RELAY_ADDRESS        ( SMBUS_RELAY_ADDRESS                    ),
        .SCL_LOW_TIMEOUT_PERIOD_MS  ( SCL_LOW_TIMEOUT_PERIOD_MS              ),
        .MCTP_OUT_OF_BAND_ENABLE    ( MCTP_OUT_OF_BAND_ENABLE                )
    ) u_smbus_filtered_relay_2 (
        .clock              ( dut_clk            ),
        .i_resetn           ( !dut_reset         ),
        .i_block_disable    ( dut_block_disable  ),
        .i_filter_disable   ( dut_filter_disable ),
        .i_relay_all_addresses(dut_relay_all_addresses),
        .start2stop_gen     (1'b0),
        .rfnvram_sda_oe     (1'b0),
        .ia_master_scl      ( dut_master_scl_in_2  ),
        .o_master_scl_oe    ( dut_master_scl_oe_2  ),
        .ia_master_sda      ( dut_master_sda_in_2  ),
        .o_master_sda_oe    ( dut_master_sda_oe_2  ),
        .ia_slave_scl       ( dut_slave_scl_in_2   ),
        .o_slave_scl_oe     ( dut_slave_scl_oe_2   ),
        .ia_slave_sda       ( dut_slave_sda_in_2   ),
        .o_slave_sda_oe     ( dut_slave_sda_oe_2   ),
        .i_avmm_write       ( bfm_i2c_filter_master_top_avmm_write     ),
        .i_avmm_address     ( bfm_i2c_filter_master_top_avmm_address   ),
        .i_avmm_writedata   ( bfm_i2c_filter_master_top_avmm_writedata )
    );

assign system_reset = i2c_reset_if.reset;

assign dut_reset = i2c_reset_if.reset;

assign i2c_reset_if.clk=system_clk;
//signal_watchdog_if system_reset_watchdog_if(system_clk);
//assign system_reset_watchdog_if.watched = !system_reset;
//
//signal_watchdog_if dut_reset_watchdog_if(dut_clk);
//assign dut_reset_watchdog_if.watched = !dut_reset;

//==================================================================================================
// clk and reset
//==================================================================================================


//Reset generation for reset_if

initial begin
  i2c_reset_if.reset = 1'b0;
  @(posedge i2c_reset_if.clk)
  i2c_reset_if.reset = 1'b1;
  @(posedge i2c_reset_if.clk)
  i2c_reset_if.reset = 1'b0;
  `uvm_info("TOP", "I2C_RESET_APPLIED ...",UVM_LOW);
end


// Clock generators
initial begin
    system_clk <= 1'b0;
    forever
        #500ps system_clk <= ~system_clk;     // The Synopsys IP requires a 1 GHz clock
end
initial begin
    time dut_clk_half_period;
    dut_clk_half_period = (CLOCK_PERIOD_PS/2) * 1ps;    // convert integer value to a time in ps
    dut_clk <= 1'b0;
    forever
        #dut_clk_half_period dut_clk <= ~dut_clk;
end

initial begin
`ifdef ENABLE_VCS_DEBUG
    // Enable debugging
    $vcdplusdeltacycleon();
    $vcdpluson();
`ifdef ENABLE_VCS_MEM_DEBUG
    $vcdplusmemon();
`endif
`endif
    // Register the interfaces to the BFMs
   // `altr_set_if(virtual reset_if, "testbench", "reset_bfm", reset_bfm)
   // `altr_set_if(virtual reset_if, "testbench", "dut_reset_bfm", dut_reset_bfm)
   // 
   // `altr_set_if(virtual signal_watchdog_if, "testbench", "system_reset_watchdog_if", system_reset_watchdog_if)
   // `altr_set_if(virtual signal_watchdog_if, "testbench", "dut_reset_watchdog_if", dut_reset_watchdog_if)
    
   // `altr_set_if(virtual svt_i2c_if, "testbench", "i2c_if_ctrl0", i2c_if_ctrl0)
   // `altr_set_if(virtual svt_i2c_if, "testbench", "i2c_if_mstr2", i2c_if_mstr2)
   // `altr_set_if(virtual svt_i2c_if, "testbench", "i2c_if_ctrl1", i2c_if_ctrl1)
   // `altr_set_if(virtual relay_sideband_if, "testbench", "relay_sideband_if_1", relay_sideband_if_1)
   // `altr_set_if(virtual i2c_filter_top_avalon_mm_master_bfm, "testbench", "i2c_filter_master_top_avmm_bfm", i2c_filter_master_top_avmm_bfm)
   // `altr_set_if(virtual i2c_filter_top_avalon_mm_monitor_bfm, "testbench", "i2c_filter_master_top_avmm_monitor", i2c_filter_master_top_avmm_monitor)
     //uvm_config_db#(virtual svt_i2c_if)::set(uvm_root::get(), "uvm_test_top.tb_env.i2c_system_env_slv1", "vif", i2c_if_ctrl1);
     //uvm_config_db#(virtual svt_i2c_if)::set(uvm_root::get(), "uvm_test_top.tb_env.i2c_system_env_mstr1", "vif", i2c_if_ctrl0);
      
    // Run the test
    //uvm_pkg::run_test("basic_test");
end

initial begin
     //uvm_config_db#(virtual svt_i2c_if)::set(uvm_root::get(), "uvm_test_top.tb_env0.i2c_system_env_slv1", "vif", i2c_if_ctrl1);
     uvm_config_db#(virtual svt_i2c_if)::set(uvm_root::get(), "uvm_test_top.tb_env0", "i2c_if_ctrl1", i2c_if_ctrl1);
     uvm_config_db#(virtual svt_i2c_if)::set(uvm_root::get(), "uvm_test_top.tb_env0", "i2c_if_ctrl0", i2c_if_ctrl0);
     //uvm_config_db#(virtual svt_i2c_if)::set(uvm_root::get(), "uvm_test_top.tb_env0.i2c_system_env_mstr1", "vif", i2c_if_ctrl0);
     uvm_config_db#(int)::set(uvm_root::get(), "*", "recording_detail", 1);

end

// Sample the input parameterization
initial begin
    input_parametrization = new();
    input_parametrization.sample();
end

initial begin
  run_test();
end
endmodule

