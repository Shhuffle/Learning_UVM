//Configuration obect for the spi_env

//Class Description 
class spi_env_config extends uvm_object;
    //UVM factory Registration Macro
    `uvm_object_utils(spi_env_config)

    //Data Members
    bit has_functional_coverage = 0;
    bit has_spi_functional_coverage = 1;
    bit has_reg_scoreboard = 0;
    bit has_spi_scoreboard = 1;

    //configuration for the sub_componentes
    apb_config m_apb_agent_cfg;
    spi_config m_spi_agent_cfg;

    //methods

    extern function new(string name = "spi_env_config");
endclass: spi_env_config

function spi_env_config::new(string name = "spi_env_config");
    super.new(name)
endfunction

//Inside the spi_test_base class the agent config handles are assigned
//The build method form earlier, adding the apb agent virtual interface assigned

//Build the env, create the env configuration including any sub configurations and 
//assign virtual interfaces

function void spi_test_base::build_phase( uvm_phase phase ); 
// Create env configuration object 
m_env_cfg = spi_env_config::type_id::create("m_env_cfg"); 
// Call function to configure the env 
configure_env(m_env_cfg); 
// Create apb agent configuration object 
m_apb_cfg = apb_agent_config::type_id::create("m_apb_cfg"); 
// Call function to configure the apb_agent 
configure_apb_agent(m_apb_cfg); 
// Adding the APB monitor BFM virtual interface: 
if ( !uvm_config_db #(virtual apb_monitor_bfm)::get(this, "", "APB_mon_bfm", 
m_apb_cfg.mon_bfm ) ) `uvm_error(...) 
// Adding the APB driver BFM virtual interface: 
if ( !uvm_config_db #(virtual apb_driver_bfm)::get(this, "", "APB_drv_bfm", 
m_apb_cfg.drv_bfm ) ) `uvm_error(...) 
// Assign the apb_agent config handle inside the env_config: 
m_env_cfg.m_apb_agent_cfg = m_apb_cfg; 
// Repeated for the spi configuration object 
m_spi_cfg = spi_agent_config::type_id::create("m_spi_cfg"); 
configure_spi_agent(m_spi_cfg); 
// Adding the SPI driver BFM virtual interface 
if ( !uvm_config_db #(virtual spi_driver_bfm)::get(this, "", "SPI_drv_bfm", 
m_spi_cfg.drv_bfm ) ) `uvm_error(...) 
// Adding the SPI monitor BFM virtual interface 
if ( !uvm_config_db #(virtual spi_monitor_bfm)::get(this, "", "SPI_mon_bfm", 
m_spi_cfg.mon_bfm ) ) `uvm_error(...) 
m_env_cfg.m_spi_agent_cfg = m_spi_cfg; 
// Now env config is complete set it into config space 
uvm_config_db #( spi_env_config )::set( this , "*", "spi_env_config", m_env_cfg) ); 
// Now we are ready to build the spi_env 
m_env = spi_env::type_id::create("m_env", this); endfunction: 
build_phase