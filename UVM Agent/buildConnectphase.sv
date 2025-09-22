class apb_agent extend uvm_component;
    `uvm_component_utils(apb_agent)
    apb_agent_config m_cfg;

    //Component Member
    uvm_analysis_port #(apb_seq_item) ap;
    apb_monitor m_monitor;
    apb_driver m_driver;
    apb_sequencer m_sequencer;
    apb_coverage_monitor m_fcov_monitor;

    //Methods
    //Standard UVM Methods
    function apb_agent::new(string name = "apb_agent", uvm_component parent = null);
        super.new(name,parent)
    endfunction
    function void apb_agent::build_phase(uvm_phase phase);
        if(m_cfg == null)
            if(!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",m_cfg))
                `uvm_fatal(...)
        //Monitor is always present
            m_monitor = apb_monitor::type_id::create("m_monitor",this);
            //Only build the driver and sequencer if active
            if(m_cfg.active == UVM_ACTIVE) begin
                m_driver = apb_driver::type_id::create("m_driver",this);
                m_sequencer = apb_sequencer::type_id::create("m_sequencer",this) 
            end
            if(m_cfg.has_functional_coverage) begin
                m_fcov_monitor = apb_coverage_monitor::type_id::create("m_fcov_monitor",this);

            end
        endfunction: build_phase

        function void apb_agent::connect_phase(uvm_phase phase);
            ap = m_monitor.ap;
            //Only connect the driver and the sequencer if active
            if(m_cfg.active == UVM_ACTIVE) begin
                m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
                    //port -> export
            end
            if(m_ccfg.has_functional_coverage) begin
                m_monitor.ap.connect(m_fcov_monitor.analysis_export);
            end
        endfunction: connect phase 
            
            
            
