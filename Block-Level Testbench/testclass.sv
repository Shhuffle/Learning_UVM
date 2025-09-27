class spi_test_base extends uvm_test;
    //UVM Factory Registration Macro
    `uvm_component_utils(spi_test_base)
    //data members
    //............
    //Component Members
    //..........
    //The environement class
    spi_env m_env;
    spi_env_config m_env_cfg;
    apb_agent_config m_apb_cfg;
    spi_agent_config m_spi_cfg;

    //Register map 
    spi_register_map spi_rm;
    //Interrupt Utility
    intr_util INTR;

    //Methods 
    function new(string name = "spi_test_base",uvm_component parent = null)
        super.new(name,parent)
    endfunction 

    extern virtual function void configure_apb_agent(apb_agent_config cfg);
    extern function void build_phase(uvm_phase phase);
endclass:spi_test_base

//Build the env, create the env configuration 
function void spi_test_base::build_phase(uvm_phase phase);
    virtual intr_bfm temp_intr_bfm;
    //env configuration 
    m_env_cfg = spi_env_config::type_id::create("m_env_cfg");
    //Register map- Keep reg_map a generic name for vertical reuse reasons
    spi_rm = new("reg_map",null);
    m_env_cfg.spi_rm = spi_rm;
    m_apb_cfg = abp_agent_config::type_id::create("m_apb_cfg");
    configure_apb_agent(m_apb_cfg);
    if(!uvm_config_db #(virtual apb_monitor_bfm)::get(this,"","APB_monitor_bfm"m_apb_cfg.mon_bfm))
        `uvm_fatal(...);

    if(!uvm_config_db #(virtual apb_driver_bfm::get(this,"","APB_drv_bfm",m_apb_cfg.drv_cfg)))
        `uvm_fatal(...);

    m_env_cfg.m_apb_agent_cfg = m_apb_cfg;

    //SPI configuration 
    m_spi_cfg = spi_agent_config::type_id::create("m_spi_cfg");
    if (!uvm_config_db #(virtual spi_monitor_bfm)::get(this, "", "SPI_mon_bfm",m_spi_cfg.mon_bfm)) `uvm_fatal(...) 
    if (!uvm_config_db #(virtual spi_driver_bfm) ::get(this, "", "SPI_drv_bfm",m_spi_cfg.drv_bfm)) `uvm_fatal(...) 
    m_spi_cfg.has_functional_coverage =0;
    m_env_cfg.m_spi_agent_cfg = m_spi_cfg

    //Insert the interrupt virtual interface into the env_config:
    INTR = intr_util::type_id::create("INTR"); 
    if (!uvm_config_db #(virtual intr_bfm)::get(this, "", "INTR_bfm", temp_intr_bfm) )
        `uvm_fatal(...) 
    INTR.set_bfm(temp_intr_bfm); 
    m_env_cfg.INTR = INTR;

    uvm_config_db #(spi_env_config)::set(this,"*","spi_env_config",m_env_cfg);
    m_env = spi_env::type_id::create("m_env",this);//so that every component uses same environment handle

    //override for register adapter:
    register_adapter_base::type_id::set_inst_override(apb_register_adapter::get_type(),"spi_bus.adapter");
endfunction:build_phase

//Convenience function to configure the apb agent
function void spi_test_base::configure_apb_agent(apb_agent_config cfg);
    cfg.active = UVM_ACTIVE;
    cfg.has_functional_coverage = 0;
    cfg.has_scoreboard = 0;
    cfg.no_select_lines =1;
    cfg.start_address[0] = 32'h0;
    cfg.range[0] = 32'h18;
endfunction

/*To create a specific test case, the spi_test_base class is extended, and this allows the test writer to take advantage of 
the configuration and build process defined in the parent class. As a result, the test writer only needs to add a 
run_phase method.*/

class spi_poll_test extends spi_test_base;
    `uvm_component_utils(spi_poll_test)
    //Methods
    //Standarad UVM Methods:
    extern function new(string name = "spi_poll_test",uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase);
endclass: spi_poll_test

function spi_poll_test::new(string name = "spi_poll_test",uvm_component parent =null);
    super.new(name,parent);
endfunction


//Build the env, create the env configuration including any sub configuration 
//and assigning the virtual interface
function spi_poll_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction: build_phase

task spi_poll_test::run_phase(uvm_phase phase);
    config_polling_test t_seq= config_polling_test::type_id::create("t_seq");
    set_seqs(t_seq);

    phase.raise_objection(this,"Test Started");
    t_seq.start(null);
    #100;
    phase.drop_objection(this,"Test Finished");
endtask:run_phase