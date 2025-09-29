class env_config extends uvm_object;
`uvm_object_utils(env_config)

//data members    
bit has_functional_coverage, has_scoreboard;

//agent config handle
apb_agent_config m_apb_agent_cfg;

//standard uvm methods
function void new(string name="env_config")
    super.new(name)
endfunction
endclass: env_config

class apb_agent_config extends uvm_object;
    `uvm_object_utils(apb_agent_config)

    //data members
    bit has_monitor;
    bit has_driver;
    bit is_active;
    
    //virtual interfaces
    virtual apb_driver_bfm drv_bfm;
    virtual apb_monitor_bfm mon_bfm;

    function void new(string name = "apb_agent_config")
        super.new(name)
    endfunction
endclass : apb_agent_config

