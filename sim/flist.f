// --- RTL ---
+incdir+../design
../design/apb_design_pkg.sv
../design/apb_slave.sv

+incdir+../verification/interfaces
../verification/interfaces/apb_interface.sv

// shared
+incdir+../verification/shared
../verification/shared/apb_shared_pkg.sv

// uvc
+incdir+../verification/apb_master_agent
../verification/apb_master_agent/apb_master_agent_pkg.sv

// env
+incdir+../verification/env
../verification/env/apb_master_env_pkg.sv

// seq_lib
+incdir+../verification/seq_lib
../verification/seq_lib/apb_seq_lib_pkg.sv

// tests
+incdir+../verification/tests
../verification/tests/apb_tests_pkg.sv

// tb
+incdir+../verification/tb
../verification/tb/test_top.sv