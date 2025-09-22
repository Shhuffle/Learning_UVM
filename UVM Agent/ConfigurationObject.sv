/*
 The agent has a configuraion object which defines:
 The topology of the agent's sub-components 
 (determies what gets constructed)
 The  handles for the BFM virtual interfaces used by the driver and monitor proxies
 The behavior of the Agent, whether the agent is active or passive.

Whether other sub-components are built or not is controlled by additional configuration data members which 
should have descriptive names.

The configuration object contains handles for the BFM virtual interfaces used by the driver proxy and the monitor 
proxy.

The agent configuration object may also contain other data members to control how the agent is configured or 
behaves. For instance, the configuration object for the APB agent has data members to set up the memory map and 
determine the APB PSEL lines that are activated with associated address map. 

What kind of things go inside?

Think of it as parameters for verification:
1.Protocol settings
Address width (e.g., 32-bit or 64-bit)
Data width (8/16/32 bits)
Number of slaves connected → so PSEL lines count
Clock period

2.Agent behavior control
Is this agent active (drives signals) or passive (only monitors)?
Enable/disable coverage collection
Whether to insert wait states or delays in the driver
Error injection enable

2.Sequencer/sequence defaults
Default read/write wait cycles
Default response behavior

*/

class apb_agent_config extends uvm_object;
    `uvm_objet_utils(apb_agent_config)

    //BFM virtual interfaces 
    virtual apb_monitor_bfm mon_bfm;
    virtual apb_driver_bfm drv_bfm;

    //..................
    //Data Members
    //..................

    //Is the agent active or passive
    uvm_active_passive_enum active = UVM_ACTIVE;
    //Include the APB functional coverage collector.
    bit has_functional_coverage =0;
    //Include the APB RAM based scoreboard.
    bit has_scoreboard =0;

    //Address deccode for the select lines:
    int no_select_lines = 1;
    int apb_index = 0; // Which PSEL, peripheral select is the monitor connected to.
    logic[31:0] start_address[15:0];
    logic[31:0] range [15:0];

    //........................
    //Methods
    //........................
    //Standard UVM Methods:
    extern function new(string name = "apb_agent_config");
endclass:apb_agent_config 


function apb_agent_config::new(string name = "apb_agent_config");
    super.new(name);
endfunction