/*
 The Environment
 The next level in the SPI UVM environment is the spi_env. This class contains a 
 number of sub-components, namely the SPI and the APB agents, a scoreboard and a 
 functional coverage collector.

 First we create a env_configure clas
*/

class spi_env_config extends uvm_object;
    `uvm_object_utils(spi_env_config)

    const string s_my_config_id = "spi_env_config"
    const string s_no_config_id = "no config"
    const string s_my_config_type_error_id = "config type error";

    //interrupt Utility - used in the wait for interrupt task
    intr_util INTR;
    // data members

    bit has_functional_coverage = 0
    bit has_spi_scoreboard = 1;
    bit has_spi_functional_coverage = 1;
    bit has_reg_scoreboard = 1;
    //whether the various agents are used
    bit has_apb_agent =1;
    bit has_spi_agent=1;
    apb_agent_config m_apb_agent_cfg;
    spi_agent_config m_spi_agent_cfg;
    //SPI register model 
    uvm_register_map spi_rm;
    //Methods

    extern task wait_for_interrupt;
    extern function bit is_interrupt_cleared;
    extern function new(string name = "spi_env_config"); 
 
    endclass: spi_env_config 

function spi_env_config::new(string name = "spi_env_config"); 
    super.new(name); 
endfunction 

task spi_env_config::wait_for_interrupt;
    INTR.wait_for_interrup();
endtask: wait_for_interrupt

//check that interrupt has cleared
function bit spi_env_config::is_interrupt_cleared:
    return INTR.is_interrupt_cleared();
endfunction:is_interrupt_cleared



//Class description:
class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)
    apb_agent m_apb_agent;
    spi_agent m_spi_agent;
    spi_env_config m_cfg;
    spi_scoreboard m_scoreboard;

    //Register layer adapter
    reg2apb_adapter m_reg2apb;
    //Register predictor
    uvm_reg_predictor#(apb_seq_item) m_apd2reg_predictor;
    //constraints

    // Methods 
    //standard UVM methods

    extern function new(string name = "spi_env",uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass:spi_env 

function spi_env::new(string name = "spi_env",uvm_component parent = null)
    super.new(name,parent);
endfunction

function void spi_env::build_phase(uvm_phase phase);
    if(!uvm_config_db#(spi_env_config)::get(this,"","spi_env_config",m_cfg))
        `uvm_fatal("No config for environement");
    uvm_config_db #(apb_agent_config)::set(this, "m_apb_agent*", "apb_agent_config", m_cfg.m_apb_agent_cfg); 
    m_apb_agent = apb_agent::type_id::create("m_apb_agent",this)

    // Build the register model predictor 
    m_apb2reg_predictor = uvm_reg_predictor#(apb_seq_item)::type_id::create("m_apb2reg_predictor", this); 
    m_reg2apb = reg2apb_adapter::type_id::create("m_reg2apb"); 
    uvm_config_db #(spi_agent_config)::set(this, "m_spi_agent*", "spi_agent_config", m_cfg.m_spi_agent_cfg); 
    m_spi_agent = spi_agent::type_id::create("m_spi_agent", this); 

    if(m_cf.has_spi_scoreboard) begin
        m_scoreboard = spi_scoreboard::type_id::create("m_scoreboard",this);

    end
endfunction:build_phase

/*In UVM SPI environments, only the **top-level register block** sets up the **sequencer, predictor, and adapter** to avoid 
  duplication and maintain a single source of truth. `set_sequencer()` links the abstract register block to the APB sequencer 
  via an adapter, enabling register writes to generate real bus transactions, which the predictor observes and updates.
*/

function void spi_env::connect_phase(uvm_phase phase);
    // Only set up register sequencer layering if the spi_rb is the top block
    
    // If it isn't, then the top level environment will set up the correct sequencer and predictor
    if(m_cfg.spi_rb.get_parent() == null)
        if(m_cfg.m_apb_agent_cfg.active == UVM_ACTIVE) begin
            m_cfg.spi_rb.spi_reg_block_map.set_sequencer(m_apb_agent.m_sequencer, m_reg2apb);
        end

        m_apb2reg_predictor.map = m_cfg.spi_rb.spi_reg_block_map;
        //set the predictor adapter:
        m_apb2reg_predictor.adapter = m_reg2apb
        // Disable the register models auto-prediction 
        m_cfg.spi_rb.spi_reg_block_map.set_auto_predict(0); 
        // Connect the predictor to the bus agent monitor analysis port 
        m_apb_agent.ap.connect(m_apb2reg_predictor.bus_in); 
        
    if(m_cfg.has_spi_scoreboard) begin
        m_spi_agent.ap.connect(m_scoreboard.spi.analysis_export)
        m_scoreboard.spi_rb = m_cfg.spi_rb;
    end
endfunction: connect_phase

/*
 The APB agent drives transactions via its sequencer to write/read DUT internal registers,
 the monitor observes bus traffic, the predictor updates the UVM register model, and the 
 scoreboard compares predicted values vs DUT register contents for verification.
  
*/
    



