if ![file exists work] {

    vlib work

}



vlog -f E:/UART_project/run_uart.f

vopt +acc top_hdl_test top_tb_test -o top_opt

vsim top_opt -c +UVM_TESTNAME=simple_test -do "run -all; quit" 
