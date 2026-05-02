// --- RTL ---
+incdir+../design
../design/apb_design_pkg.sv
../design/apb_slave.sv

+incdir+../verification/interfaces
../verification/interfaces/apb_interface.sv

// uvc
//+incdir+../verification/uvc
//../verification/uvc/uvc_if.sv
//../verification/uvc/uvc_pkg.sv

// env
//+incdir+../verification/env
//../verification/env/env_pkg.sv

// seq_lib
//+incdir+../verification/seq_lib
//../verification/seq_lib/seq_lib_pkg.sv

// tests
//+incdir+../verification/tests
//../verification/tests/test_pkg.sv

// tb
+incdir+../verification/tb
../verification/tb/test_top.sv