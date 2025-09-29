module hdl_top;
    `include "timescale.v"

    logic clk; 
    logic reset;

    //Pin Interface Instantiation 
    apb_if APB(clk,reset);

    //BFM interface instantiation 
    apb_driver_bfm drv_bfm;
    apb_monitor_bfm mon_bfm;

    //DUT
    apb_counter DUT(.clk(clk),.reset(reset))

    //VIRTUAL INTERFACE Wrapping
    initial begin
        uvm_config_db #(virtual apb_driver_bfm)::set(null,"uvm_test_top","drv_bfm",drv_bfm);
        uvm_config_db #(virtual apb_monitor_bfm)::set(null,"uvm_test_top","mon_bfm",mon_bfm);
   
    end
    
    //clock generation 
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //reset logic
    initial begin
        reset = 0;
        #10 reset = 1;
    end
endmodule
