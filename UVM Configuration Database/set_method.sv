/*
 The set methond
 The full signature of the set method is:
 void uvm_config_db #(type T =int)::set(uvm_component cntxt,string inst_name,string field_name,T value)
 T is the type of resource or element being added
 cntxt and inst_name together form a scope that is used to locate the resource within the database;
 field_name is the name given to the resource.
 value is the actual value or reference that is put into the database


 An example of putting virtual interfaces into the UVM configuarion database is as
 follows:
*/

interface ahb_if data_port_if(clk,reset);
..........
endinterface

interface ahb_if control_port_if(clk,reset);
.......
endinterface
...
uvm_config_db #(virtual ahb_if)::set(null,"uvm_test_top","data_port",data_port_if);
uvm_cofig_db #(virtual ahb_if)::set(null,"uvm_test_top","control_port",control_port_if);
....


//This code puts two AHB interfaces into the config db at the hierarchical location 
//"uvm_test_top", which is the default location for th top level test component.

//An example of configuring agents inside an env is as follow
class env extends uvm_env;
    ahb_agent_config m_ahb_agent_config;
    function void build_phase(uvm_phase phase);
        .....
        m_ahb_agent = ahb_agent::type_id::create("m_ahb_agent",this);
        ....
        uvm_config_db #(ahb_agent_config)::set(this,"m_ahb_agent*","ahb_agent_config",m_ahb_agent_config)
        .....
    endfunction
endclass
/*
This code sets the configuration for the AHB agent and all its child components. Two things to note: 
• Use "this" as the first argument to ensure that only this agent's configuration is set, and not of any other 
ahb_agent in the component hierarchy. 


• Use "m_ahb_agent*" to ensure that both the agent and its children are in the look-up scope. Without the '*' only 
the agent itself would be, and its driver, sequencer and monitor sub-components would be unable to access the 
configuration
*/