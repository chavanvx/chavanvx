# Copyright (C) 2021 Intel Corporation
#//
#// $Id: Makefile_VCS.mk $
#////////////////////////////////////////////////////////////////////////////////////////////////


#ifndef ROOTDIR
ifndef ROOTDIR
    $(error undefined ROOTDIR)
endif
ifndef WORKDIR
    WORKDIR := $(ROOTDIR)
endif

#ifndef UVM_HOME
#    $(error undefined UVM_HOME)
#endif 

#ifndef TESTNAME
#    $(error undefined TESTNAME)
#endif    

#VERDIR = $(CURDIR)/../
VERIF_SCRIPTS_DIR = $(VERDIR)/scripts

TEST_DIR :=  $(shell $(VERIF_SCRIPTS_DIR)/create_dir.pl $(VERDIR)/sim/$(TESTNAME) )

VCDFILE = $(VERIF_SCRIPTS_DIR)/vpd_dump.key
FSDBFILE = $(VERIF_SCRIPTS_DIR)/fsdb_dump.tcl


export VIPDIR = $(VERDIR)
export RALDIR = $(VERDIR)/testbench/ral
VLOG_OPT = -kdb -full64 -error=noMPD -ntb_opts uvm-1.2 +vcs+initreg+random +vcs+lic+wait -ntb_opts dtm -sverilog -timescale=1ps/1ps +libext+.v+.sv -l vlog.log -assert enable_diag -ignore unique_checks
VLOG_OPT += -Mdir=./csrc +warn=noBCNACMBP -CFLAGS -notice  +incdir+./
VLOG_OPT += +incdir+$(WORKDIR)/src
VLOG_OPT += +incdir+$(WORKDIR)/src/common
VLOG_OPT += +incdir+$(ROOTDIR)/verification/tests
VLOG_OPT += +incdir+$(ROOTDIR)/verification/tests/sequences
VLOG_OPT += +define+UVM_PACKER_MAX_BYTES=1500000
VLOG_OPT += +define+SVT_UVM_TECHNOLOGY+define+UVM_DISABLE_AUTO_ITEM_RECORDING+define+SYNOPSYS_SV
VCS_OPT = -full64 -ntb_opts uvm-1.2 -licqueue  +vcs+lic+wait -l vcs.log -ignore initializer_driver_checks 
VCS_OPT +=-debug_access+f
SIMV_OPT = +UVM_TESTNAME=$(TESTNAME) +TIMEOUT=$(TIMEOUT)
SIMV_OPT += +ntb_disable_cnst_null_object_warning=1 -assert nopostproc +vcs+lic+wait +vcs+initreg+0 
SIMV_OPT +=  +vcs+lic+wait 
SIMV_OPT += +vcs+nospecify+notimingchecks +vip_verbosity=svt_pcie_pl:UVM_NONE,svt_pcie_dl:UVM_NONE,svt_pcie_tl:UVM_NONE  
SIMV_OPT += +UVM_CONFIG_DB_TRACE
ifndef SEED
    SIMV_OPT += +ntb_random_seed_automatic
else
    SIMV_OPT += +ntb_random_seed=$(SEED)
endif

ifndef MSG
    SIMV_OPT += +UVM_VERBOSITY=LOW
else
    SIMV_OPT += +UVM_VERBOSITY=$(MSG)
endif


ifdef DUMP
    #VLOG_OPT += -debug_all 
    #VCS_OPT += -debug_all 
    VLOG_OPT += -debug_access+f
    VLOG_OPT += +define+ENABLE_VCS_DEBUG
    #VCS_OPT += -debug_access+f
    #SIMV_OPT += -ucli -i $(VCDFILE)
endif


ifdef DUMP_FSDB
    #VLOG_OPT += -debug_all 
    #VCS_OPT += -debug_all 
    VLOG_OPT += -debug_access+f
    VCS_OPT += -debug_access+f
    SIMV_OPT += -ucli -i $(FSDBFILE)
endif

ifdef DEBUG
SIMV_OPT += -l runsim.log 
VLOG_OPT += +define+RUNSIM
endif



ifdef GUI
    VCS_OPT += -debug_all +memcbk
    SIMV_OPT += -gui
endif

ifdef QUIT
    SIMV_OPT_EXTRA = +UVM_MAX_QUIT_COUNT=1
else
   SIMV_OPT_EXTRA = ""
endif

ifdef COV 
    VLOG_OPT += -debug_all 
    VCS_OPT += -debug_all 
    VLOG_OPT += +define+COV -debug_all -cm line+cond+fsm+tgl+branch -cm_dir simv.vdb
    VCS_OPT  += -debug_all -cm line+cond+fsm+tgl+branch  -cm_dir simv.vdb 
    SIMV_OPT += -cm line+cond+fsm+tgl+branch -cm_name $(TESTNAME) -cm_dir ../regression.vdb
    #SIMV_OPT += -cm line+cond+fsm+tgl+branch -cm_name seed.1 -cm_dir regression.vdb
endif

ifdef COV_FUNCTIONAL
		COV_TST := $(shell basename $(TEST_DIR))
    VLOG_OPT += +define+ENABLE_AC_COVERAGE+define+ENABLE_COV_MSG+define+COV_FUNCTIONAL -cm line+cond+fsm+tgl+branch -cm_dir simv.vdb
    VCS_OPT  += -cm line+cond+fsm+tgl+branch+assert  -cm_dir simv.vdb
    SIMV_OPT += -cm line+cond+fsm+tgl+branch+assert+group -cm_name $(COV_TST) -cm_dir ../regression.vdb
    #SIMV_OPT += -cm line+cond+fsm+tgl+branch -cm_name seed.1 -cm_dir regression.vdb
endif

batch: vcs
	./simv $(SIMV_OPT) $(SIMV_OPT_EXTRA)

dump:
	make DUMP=1

clean:
	@if [ -d worklib ]; then rm -rf worklib; fi;
	@if [ -d libs ]; then rm -rf libs; fi;
	@rm -rf simv* csrc *.out* *.OUT *.log *.txt *.h *.setup *.vpd test_lib.svh .vlogansetup.* *.tr *.hex *.xml DVEfiles;
	@rm -rf $(VERDIR)/sim $(VERDIR)/ip_libraries $(VERDIR)/vip;

clean_dve:
	@if [ -d worklib ]; then rm -rf worklib; fi;
	@if [ -d libs ]; then rm -rf libs; fi;
	@rm -rf simv* csrc *.out* *.OUT *.log *.txt *.h *.setup *.vpd test_lib.svh .vlogansetup.* *.tr *.hex *.xml;

setup: clean_dve
	@echo WORK \> DEFAULT > synopsys_sim.setup
	@echo DEFAULT \: worklib >> synopsys_sim.setup              
	@mkdir worklib
	@echo VIPDIR  $(VIPDIR)              
	@echo \`include \"$(TESTNAME).svh\" > test_lib.svh                
	test -s $(VERDIR)/sim || mkdir $(VERDIR)/sim
	test -s $(VERDIR)/vip || mkdir $(VERDIR)/vip
	test -s $(VERDIR)/vip/axi_vip || mkdir $(VERDIR)/vip/axi_vip
	test -s $(VERDIR)/vip/i2c_vip || mkdir $(VERDIR)/vip/i2c_vip
	#rsync -avz --checksum --ignore-times --exclude pim_template ../ip_libraries/* $(VERDIR)/sim/
	@echo ''
	@echo VCS_HOME: $(VCS_HOME)
	@$(DESIGNWARE_HOME)/bin/dw_vip_setup -path ../vip/i2c_vip -add i2c_master_agent_svt -svlog
	@$(DESIGNWARE_HOME)/bin/dw_vip_setup -path ../vip/i2c_vip -add i2c_slave_agent_svt -svlog
	@echo ''  

cmplib_adp:


vlog_adp: setup 
	cd $(VERDIR)/sim && vlogan -ntb_opts uvm-1.2 -sverilog
	cd $(VERDIR)/sim && vlogan -full64 -ntb_opts uvm-1.2 -sverilog -timescale=1ns/1ns -l vlog_uvm.log
	cd $(VERDIR)/sim && vlogan $(VLOG_OPT) +define+SIM_VIP -F $(VERIF_SCRIPTS_DIR)/rtl_flist.f -F $(VERIF_SCRIPTS_DIR)/ver_list.f
	#cd $(VERDIR)/sim && vlogan $(VLOG_OPT) +define+SIM_VIP -F $(SCRIPTS_DIR)/rtl_flist.f -F $(VERIF_SCRIPTS_DIR)/svt_list.f -F $(VERIF_SCRIPTS_DIR)/ver_list.f $(AFU_FLIST_IMPORT)

build_adp: vlog_adp
	cd $(VERDIR)/sim && vcs $(VCS_OPT) top_tb 

build_gka:cmplib_adp vlog_adp
	cd $(VERDIR)/sim && vcs $(VCS_OPT) tb_top

view:
	dve -full64 -vpd inter.vpd&
run:    
ifndef TEST_DIR
	$(error undefined TESTNAME)
else
	cd $(VERDIR)/sim && mkdir $(TEST_DIR) && cd $(TEST_DIR) && ../simv $(SIMV_OPT) $(SIMV_OPT_EXTRA)
endif


rundb:    
ifndef TESTNAME
	$(error undefined TESTNAME)
else
	cd $(VERDIR)/sim && ./simv $(SIMV_OPT) $(SIMV_OPT_EXTRA)
endif

build_run: vcs run
build_all: cmplib vcs
do_it_all: cmplib vcs run


