//Driver parameterized with the same sequence_item for request and response
//response defaultsto requuest
function void connect_phase(uvm_phase phase);
    if(m.cfg.active == UVM_ACTIVE)begin
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);//TLM connection 
        m_driver.vif = cfg.vif//VI assignment
    end
endfunction: connect_phase 
