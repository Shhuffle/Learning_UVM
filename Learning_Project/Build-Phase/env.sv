class apb_counter_env extends uvm_env;
    `uvm_component_utils(apb_counter_env)

    function void new(string name = "apb_counter_env", uvm_component parent)
        super.new(name,parent);
    endfunction

    env_config m_env_cfg;
    apb_agent m_apb_agent;

    function void build_phase(uvm_phase phase)
        super.build_phase(phase);

        //get env config which was set in the test

        if(!uvm_config_db #(env_config)::get(this,"","env_cfg",m_env_cfg))
            `uvm_fatal("ENV","No enviroment config foud!! ");

        //create agent
        m_apb_agent = apb_agent::type_id::create("m_apb_agent",this);

        //pass agent config down to the agent and its children
        uvm_config_db #(apb_agent_config)::set(this,"m_apb_agent*","agent_config",m_env_cfg.m_apb_agent_cfg);
    endfunction
endclass