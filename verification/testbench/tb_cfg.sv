package test_cfg_pkg;

	//==================================================================================================
	// DUT parameters
	//==================================================================================================

	localparam I2C_FILTER_TOP_FILTER_ENABLE                 = 0;
	localparam I2C_FILTER_TOP_RELAY_ALL_ADDRESSES           = 1;
	localparam I2C_FILTER_TOP_CLOCK_PERIOD_PS               = 10000;
	localparam I2C_FILTER_TOP_BUS_SPEED_KHZ                 = 400;
	localparam I2C_FILTER_TOP_NUM_RELAY_ADDRESSES           = 1;
	localparam I2C_FILTER_TOP_NUM_MASTER                    = 2;
	localparam I2C_FILTER_TOP_IGNORED_ADDR_BITS             = 0;
	localparam I2C_FILTER_TOP_SCL_LOW_TIMEOUT_PERIOD_MS     = 40;
	localparam I2C_FILTER_TOP_MCTP_OUT_OF_BAND_ENABLE       = 0;
	localparam I2C_FILTER_TOP_SMBUS_RELAY_ADDRESS = {{7'h5a}};
	//==================================================================================================
	// Additional Control parameters
	//==================================================================================================

	localparam I2C_FILTER_MISSMATCH_SLAVE_AND_RELAY_ADDR   = 0;
	//==================================================================================================
	// BFM parameters
	//==================================================================================================

	localparam I2C_FILTER_TOP_AVMM_BFM_AV_DATA_W = 32;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_SYMBOL_W = 8;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_ADDRESS_W = 8;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_NUMSYMBOLS = 4;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_BURSTCOUNT_W = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_READRESPONSE_W = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_WRITERESPONSE_W = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_READ = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_WRITE = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_ADDRESS = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_BYTE_ENABLE = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_BURSTCOUNT = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_READ_DATA = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_READ_DATA_VALID = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_WRITE_DATA = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_BEGIN_TRANSFER = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_BEGIN_BURST_TRANSFER = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_WAIT_REQUEST = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_TRANSACTIONID = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_WRITERESPONSE = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_READRESPONSE = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_USE_CLKEN = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_CONSTANT_BURST_BEHAVIOR = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_BURST_LINEWRAP = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_BURST_BNDR_ONLY = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_PENDING_READS = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_PENDING_WRITES = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_FIX_READ_LATENCY = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_READ_WAIT_TIME = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_WRITE_WAIT_TIME = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_REGISTER_WAITREQUEST = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_REGISTERINCOMINGSIGNALS = 0;
	localparam I2C_FILTER_TOP_AVMM_BFM_VHDL_ID = 1;
	localparam I2C_FILTER_TOP_AVMM_BFM_SLAVE_ADDRESS_TYPE = "WORDS";
	localparam I2C_FILTER_TOP_AVMM_BFM_MASTER_ADDRESS_TYPE = "WORDS";
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_READ_TIMEOUT = 1024;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_WRITE_TIMEOUT = 1024;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_WAITREQUEST_TIMEOUT = 1024;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_READ_LATENCY = 100;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_WAITREQUESTED_READ = 100;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_WAITREQUESTED_WRITE = 100;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_CONTINUOUS_READ = 5;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_CONTINUOUS_WRITE = 5;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_CONTINUOUS_WAITREQUEST = 5;
	localparam I2C_FILTER_TOP_AVMM_BFM_AV_MAX_CONTINUOUS_READDATAVALID = 5;




endpackage
