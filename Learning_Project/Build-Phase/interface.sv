interface apb_if(input logic clk, input logic reset);
    logic        en;
    logic [15:0] load;
    //output
    logic        INTR_REQ;
    logic [15:0] count;
endinterface

class apb_driver_bfm extends uvm_component;
    virtual apb_if vif;

    `uvm_component_utils (apb_driver_bfm)

    function new (string name = "apb_driver_bfm",uvm_component parent = null)
        super.new(name,parent);
    endfunction

    function void  build_phase(uvm_phase phase)
        if(!uvm_config_db #(virtual apb_if)::get(this,"","driver_bfm",vif))
           uvm_fatal("BFM_IF_ERR", "Virtual interface not found");
    endfunction

    task write_load(seq_item seq);
         @(posedge vif.clk);
            vif.load <= seq.load;
            vif.en <= seq.en;
        
    endtask
    
    task read_count(ref seq_item seq);
        @(posedge vif.clk) ;
            seq.count <= vif.count;
            seq.INTR_REQ <= vif.INTR_REQ;
    endtask
endclass: apb_driver_bfm



class apb_monitor_bfm extends uvm_component;
    virtual apb_if vif;

    `uvm_component_utils(apb_monitor_bfm)

    function new (string name = "abp_monitor_bfm", uvm_component parent = null)
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase)
        if(!uvm_config_db #(virtual apb_if)::get(this,"","monitor_bfm",vif))
            uvm_fatal("BFM_IF_ERR", "Monitor bfm not found");
        
    endfunction

    task read(ref seq_item seq)
        @(posedge vif.clk);
        seq.count <= vif.count;
        seq.load <= vif.load;
        seq.en <= vif.en;
        seq.INTR_REQ <= vif.INTR_REQ;
    endtask
endclass : apb_monitor_bfm