# sim/Makefile
SHELL      := /bin/bash
TOP        := test_top
FLIST      := flist.f
TEST       ?= apb_master_base_test
SEED       ?= $(shell echo $$RANDOM)
VCS_OPTS   := -full64 -sverilog -timescale=1ns/1ps \
              +define+UVM_NO_DEPRECATED \
              -debug_access+all \
			  -debug_pp -kdb +fsdb+all=on +vpi +v2k

SIMV_OPTS  := +UVM_TESTNAME=$(TEST) \
              +UVM_VERBOSITY=UVM_MEDIUM \
              +ntb_random_seed=$(SEED) \
              -l $(TEST)_$(SEED).log

UVM_HOME = /home/ICer/uvm/1800.2-2020.3.1
UVM_OPTS = +incdir+$(UVM_HOME)/src \
                   $(UVM_HOME)/src/uvm.sv \
                   $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS

# ── Phony targets ────────────────────────────────────────────────
.PHONY: all compile sim clean waves regress

all: compile sim

# Compile (elaborate) into simv binary
compile:
	vcs $(VCS_OPTS) $(UVM_OPTS) -f $(FLIST) -top $(TOP) -o simv 2>&1 | tee compile.log

# Run a single test
sim: compile
	./simv $(SIMV_OPTS)

# Open DVE / Verdi waves
waves:
	verdi -ssf *.fsdb &

# Quick regression: run all tests, each with N seeds
TESTS  := smoke_test rand_test directed_test
SEEDS  := 1 2 3 4 5

regress: compile
	@for t in $(TESTS); do \
	  for s in $(SEEDS); do \
	    echo ">>> Running $$t seed=$$s"; \
	    ./simv +UVM_TESTNAME=$$t +ntb_random_seed=$$s \
	           -l $${t}_$${s}.log; \
	  done; \
	done

clean:
	rm -rf simv simv.daidir csrc *.log *.fsdb *.vpd ucdb \
	       DVEfiles inter.vpd novas.conf novas_dump.log

# ── Convenience overrides ────────────────────────────────────────
# make sim TEST=rand_test SEED=42
# make sim TEST=rand_test SEED=42 VCS_OPTS+="+define+DEBUG"