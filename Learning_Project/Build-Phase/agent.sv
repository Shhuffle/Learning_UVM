class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)

    //Instantiate monitor driver and agent config
    apb_agent_config agent_config;
    apb_monitor m_mon;
    apb_driver m_drv;

    function void build_phase(uvm_phase phase)
        super.build_phase(phase);

        if(!uvm_config_db #(apb_agent_config)::get(this,"","agent_config",agent_config))
            `uvm_fatal("AGENT","No agent config file.");
        
        if(agent_config.is_active) 
            m_drv = apb_driver::type_id::create("m_drv",this);
        m_mon = apb_monitor::type_id::create("m_mon",this);
    endfunction


    function void new(string name = "apb_agent", uvm_component parent =null)
        super.new(name,parent)
    endfunction
endclass: apb_agent

