class apb_base_test extends uvm_test;
    `uvm_component_utils(apb_base_test)

    function void new(string name = "apb_base_test", uvm_component parent = null)
        super.new(name,parent)
    endfunction

    apb_counter_env m_env;


    env_config env_cfg;
    apb_agent_config m_apb_cfg;

    function void build_phase(uvm_phase phase)
        super.build_phase(phase);
        env_cfg = env_config::type_id::create("m_env_cfg");
        m_apb_cfg = apb_agent_config::type_id::create("m_apb_cfg");

        //configure agent
        m_apb_cfg.has_functional_coverage = 0;
        m_apb_cfg.has_scoreboard = 0;

        //get virtual bfm interfaces
        if(!uvm_config_db #(virtual apb_driver_bfm)::get(this,"","drv_bfm",m_apb_cfg.drv_bfm))
            `uvm_fatal("[TEST]","NO DRIVER BFM")
        if(!uvm_config_db #(virtual apb_monitor_bfm)::get(this,"","mon_bfm",m_apb_cfg.mon_bfm))
            `uvm_fatal("[TEST]","NO MONITOR BFM")

        //add agent config to the env config
        env_cfg.m_apb_agent_cfg = m_apb_cfg;
        env.has_functional_coverage = 0;
        env.has_scoreboard = 0;

        //create env config and env handler
        uvm_config_db #(env_config)::set(this,"*","env_cfg",env_cfg);
        m_env = apb_counter_env::type_id::create("m_env",this);
    endfunction
endclass