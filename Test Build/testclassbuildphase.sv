/* 
 In this code I have implemeted base test class for a SPI master interface DUT, which contains
 two agents one for its APB bus interface and one for its SPI interface.

*/
//Class Description 
class spi_test_base extends uvm_test;
    `uvm_component_utils(spi_test_base)
    ........
    //Data members
    ........

    //Component Members
    //..............
    //The environment class
    spi_env m_env;

    //configuarion object
    spi_env_config m_env_cfg;
    apb_agent_config m_apb_cfg;
    spi_agent_config m_agent_cfg;

    //Methods
    //........

    //Standard UVM Methods
    extern function new(string name ="spi_test_base", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern virtual function void configure_apb_agent(apb_agent_config cfg);
    extern function void set_seqs(spi_vseq_base seq);
endclass: spi_test_base


    function spi_test_base:new(string name = "spi_test_base",uvm_component parent = null);
        super.new(name,parent)
    endfunction 

//Build the env, create the env configuraion 
//including any sub_configuration 


function void spi_test_base::build_phase(uvm_phase phase);
    //env configure
    m_env_cfg = spi_env::type_id::create("m_env_cfg");
    //apb configuration 
    m_apb_cfg = apb_agent::type_id::create("m_apb_cfg");
    configure_apb_agent(m_apb_cfg);
    m_env_cfg.m_apb_agent_cfg = m_apb_cfg;
    //The SPI is not configured with the help of helper function configure so
    m_spi.cfg.has_functional_coverage = 0;
    m_env_cfg.m_spi_agent_cfg = m_spi_cfg;
    uvm_config_db #(spi_env_config)::set(this,"*","my_env_config",m_env_cfg);
    m_env = spi_env::type_id::create("m_env",this);

    //Retrive the VI for the config database, which are added form the top level testbench.
    //add the APB driver BFM virutal interface
    if(!uvm_config_db #(virtual apb_driver_bfm)::get(this,"","APB_drv_bfm",m_apb_cfg.drv_bfm))
        `uvm_error(...)
    // Add the APB monitor BFM virtual interface 
    if ( !uvm_config_db #(virtual apb_monitor_bfm)::get(this, "", "APB_mon_bfm", 
    m_apb_cfg.mon_bfm ) ) `uvm_error(...) 


endfunction: build_phase

function void spi_test_base::set_seqs(spi_vseq_base seq);
    seq.m_cfg = m_env_cfg;
    seq.spi = m_env.m_spi_agent.m_sequencer;
endfunction
