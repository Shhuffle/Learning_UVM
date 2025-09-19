/*
 Monitors are composed of a proxy class which should extend from uvm_monitor and a BFM which is a 
SystemVerilog interface. The proxy should have one analysis port and a virtual interface handle that points to a BFM 
interface.
*/

//Construction

class wb_bus_monitor extends uvm_monitor;
    `uvm_component_utils(wb_bus_monitor)
    virtual wb_bus_monitor_bfm m_bfm;
    uvm_analysis_port #(wb_txn) wb_mon_ap; //holds the trasaction object returned form DUT
    wb_config m_config
    //Standard component constructor
    function new(string name, uvm_component parent);
        super.new(name,parent)
    endfunction

    function void build_phase(uvm_phase phase)
        wb_mon_ap = new("wb_mon_ap",this);
        m_config = wb_config::get_config(this)//get config object
        m_bfm = m_config.WB_mon_bfm; //set local virtual if property
        m_bfm.proxy = this; //Set BFM proxy handle
    endfunction

    task run_phase(uvm_phase phase)
        m_bfm.run(); //Dont start the BFM until we get to the run phase
    endtask

    function void notify_transaction(wb_txn item); 
        wb_mon_ap.write(item)
    endfunction : notify_transaction

endclass
/*
 Purpose of m_bfm.proxy = this;:

Links BFM to its monitor.
Allows BFM to call monitor methods, like notify_transaction().

Ensures observed bus transactions are forwarded to analysis ports or scoreboards.
*/


//Monitor run task example insdie m_bfm
task run();
    wb_txn txn;

    forever(@posedge wb_bus_if.clk)
    if(wb_bus_if.s_cyc) begin //Is there a valid wb cycle?
        txn = wb_txn::type_id::create("txn");
        txn.adr = wb_bus_if.s_adr;
        txn.count = 1;
        if(wb_bus_if.s_we) begin //if write enable is true
            txn.data[0] = wb_bus_if.s_wdata;
            txn.txn_type = WRITE; //set op type
            while(!(wb_bus_if.s_ack[0] | wb_bus_if.s_ack[1]|wb_bus_if.s_ack[2]))
                @(posedge wb_bus_if.clk); //wait for cycle to end
        end
        else begin
            txn.txn_type = READ; //set op type
            case(1)//Note its a read get data from correct slave
                wb_bus_if.s_stb[0]: begin
                    while (!(wb_bus_if.s_ack[0])) 
                        @(posedge wb_bus_if.clk);// wait for acknowlegement signal
                    txn.data[0] = wb_bus_if.s_rdata[0]; //get data
                end
                wb_bus_if.s_stb[1]: begin
                    while (!(wb_bus_if.s_ack[1])) @(posedge wb_bus_if.clk)
                    txn.data[0] = wb_bus_if.s_rdata[0]; //get data from slave 2

                end
            endcase
        end
        proxy.notify_transaction(txn)
    end
endtask
                


        
