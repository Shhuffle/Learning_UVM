module hdl_top;
    `include "timescale.v"
    //PCLK and PRESETn
    logic PCLK;
    logic PRESETn;

    //Instantiate the pin interfaces
    apb_if APB(PCLK,PRESETn);
    spi_if SPI();
    intr_if INTR();

    // Instantiate the BFM interfaces: 
    // 
    apb_monitor_bfm APB_mon_bfm( 
    .PCLK (APB.PCLK), 
    .PRESETn (APB.PRESETn), 
    .PADDR (APB.PADDR), 
    .PRDATA (APB.PRDATA), 
    .PWDATA (APB.PWDATA), 
    .PSEL (APB.PSEL), 
    .PENABLE (APB.PENABLE), 
    .PWRITE (APB.PWRITE), 
    .PREADY (APB.PREADY) 
    ); 
    apb_driver_bfm APB_drv_bfm( 
    .PCLK (APB.PCLK), 
    .PRESETn (APB.PRESETn), 
    .PADDR (APB.PADDR), 
    .PRDATA (APB.PRDATA), 
    .PWDATA (APB.PWDATA), 
    .PSEL (APB.PSEL), 
    .PENABLE (APB.PENABLE), 
    .PWRITE (APB.PWRITE), 
    .PREADY (APB.PREADY) 
    ); 
    spi_monitor_bfm SPI_mon_bfm( 
    .clk (SPI.clk), 
    .cs (SPI.cs), 
    .miso (SPI.miso), 
    .mosi (SPI.mosi) 
    ); 
    spi_driver_bfm SPI_drv_bfm( 
    .clk (SPI.clk), 
    .cs (SPI.cs), 
    .miso (SPI.miso), 
    .mosi (SPI.mosi) 
    ); 
    intr_bfm INTR_bfm(
    .IRQ (INTR.IRQ), 
    .IREQ (INTR.IREQ) 
    ); 
    // DUT 
    spi_top DUT( 
    // APB Interface: 
    .PCLK(PCLK), 

    .PRESETN(PRESETn), 
    .PSEL(APB.PSEL[0]), 
    .PADDR(APB.PADDR[4:0]), 
    .PWDATA(APB.PWDATA), 
    .PRDATA(APB.PRDATA), 
    .PENABLE(APB.PENABLE), 
    .PREADY(APB.PREADY), 
    .PSLVERR(), 
    .PWRITE(APB.PWRITE), 
    // Interrupt output 
    .IRQ(INTR.IRQ), 
    // SPI signals 
    .ss_pad_o(SPI.cs), 
    .sclk_pad_o(SPI.clk), 
    .mosi_pad_o(SPI.mosi), 
    .miso_pad_i(SPI.miso) 
    ); 
    //Initial block for virtual interface wrapping
    initial begin
        import uvm_pkg::uvm_config_db;
        uvm_component_db #(virtual apb_monitor_bfm)::set(null,"uvm_test_top","APB_monintor_bfm",APB_mon_bfm);
        uvm_component_db #(virtual apb_driver_bfm)::set(null,"uvm_test_top","APB_driver_bfm",APB_driver_bfm);
        uvm_config_db #(virtual spi_monitor_bfm)::set(null, "uvm_test_top", "SPI_mon_bfm",SPI_mon_bfm); 
        uvm_config_db #(virtual spi_driver_bfm) ::set(null, "uvm_test_top", "SPI_drv_bfm",SPI_drv_bfm); 
        uvm_config_db #(virtual intr_bfm,null"INTR_bfm", INTR_bfm); 



    end

    //Initial block for clock and reset
    initial begin
        PCLK = 0
        forever #10ns PCLK = ~PCLK

    end
    initial begin
        PRESETn = 0;
        repeat(4) @(posedge PCLK);
        PRESETn = 1;
    end
endmodule: hdl_top


module hvl_top;
    `include "timescale.v"
    import uvm_pkg::*;
    import spi_test_lin_pkg::*//user-defined package. It holds the actual test classes
    //written by the user.(eg spi_random_test etc,spi_error_test)

    //UVM initial block 
    initial begin
        run_task();
    end
endmodule: hvl_top

    