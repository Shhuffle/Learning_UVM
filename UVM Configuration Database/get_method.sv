/*
 The full signature of the get method is 
 bit uvm_config_db#(type T= int)::get(uvm_component cntxt,string inst_name,string field_name, ref T value);
 
 T is the type of the resource or element being retrieved- usually a virtual interface or a configuration object.
 cntxt and inst_name together form a scope that is used to loacate the resource within the database
 field_name is the name given to the resource
 value holds the actual value or the reference that is retrieved form the databse;
 the get() vall returns 1 if that retrieval succeeds or else 0 indicating that no resource of this
 type and with this context and name exists in the database.

 An example of getting virtual interfaces from the configuration database is as follows:
 
*/

class test extends uvm_test;
    ...
    function void build_phase(uvm_phase phase)
        if(!uvm.config_db #(virutal ahb_if)::get(this,"","data_port",m_cfg.m_data_port_config.m_ahb_if))
            begin
                `uvm_error("Config Error", "uvm_config_db #(virtual ahb_if)::get cannot find resource data_port")
            
            end
    endfunction
    ......
endclass
//An example of retrieving configuraion for a transactor is as follows:

class ahb_monitor extends uvm_monitor;
    ahb_agent_config m_cfg;

    function void build_phase(uvm_phase phase);
        .....
        if(!uvm_config_db #(ahb_agent_config)::get(this,"","ahb_agent_config",m_cfg)) begin
        `uvm_error("Config Error","failed to get resource ahb_agent_config")
        end

    endfunction
    ....
endclass


/*
Again, a few notes are in order: 
 • Use "this" as the context argument.
 • Use "" as the instance name.
 • Use the return value of the get() call to check whether it fails and a useful error message should be given.
*/