/*
 * Coding Convention 1:
 A component or object must contain factory registration code comprised of the following elements: 
 • A uvm_component_registry wrapper, typedefed to type_id
 • A static function to get the type_id
 • A function to get the type name



*/





class my_component extends uvm_component;
    //Wrapper class around the component class
    typedef uvm_component_registry #(my_component, "my_component") type_id;

    static function type_id get_type();
        return type_id::get();
    endfunction 

    function string get_type_name();
        return "my_component";
    endfunction

    // ....
endclass: my_component


//The registration code has a regular pattern and can be safely generated with 
//one of a set of four factory registration macros: 

//For a component 
class my_component extends uvm_component;
    //Component factory registration maro
    `uvm_component_utils(my_component)
endclass
//For a parameterized component
class my_param_component #(int ADD_WIDTH = 20, int DATA_WIDTH = 23) extends uvm_component;
    typedef my_param_component #(ADD_WIDTH, DATA_WIDTH) this_t;

    //Macro used 
    `uvm_component_param_utils(this_t)

endclass 

//For a class derived from an object (i.e uvm_object,uvm_transaction, uvm_sequence_item etc)
class my_item extends uvm_sequence_item;
    `uvm_object_utils(my_item)
endclass

//For a parameterized object class
class my_item #(int ADD_WIDTH = 20, int DATA_WIDTH = 20) extends uvm_sequence_item
    typedef my_item #(ADD_WIDTH,DATA_WIDTH) this_t
    `uvm_object_param_utils(this_t)
endclass

/*
 Factory Coding Convention2: COnstructor Defaults 
 A default constructor is created, which can be overriden by the arguments 
 passed to the constructor. It’s not the constructor itself being overridden,
 it’s the arguments applied after construction.
  
  
*/

//for a component
class my_component extends uvm_component;
    function new(string name = "my_component", uvm_component parent = null);
        super.new(name,parent);//calls the constructor of the base class
    endfunction
endclass

//For an object 
class my_item extends uvm_sequence_item;
    function new(string name = "my_item")
        super.new(name);
    endfunction
endclass



/* Factory Coding Convention 3: Component and Object Creation 
    UVM testbench components are instantiated during the build phase 
    via `uvm_component_registry::create()`, which first constructs the class 
    and then assigns its handle with correct `name` and `parent`. 
    Component building is top-down, allowing higher-level control, 
    while UVM objects are created on demand using their `create()` method.
*/

class env extends uvm_env;
    my_component m_my_component;
    my_param_component #(.ADD_WIDTH(32),.DATA_WIDTH(32)) m_my_p_component;
    //Constructor and registration macro left out

    //Component and parameterized component create examples
    function void build_phase(uvm_phase phase);
        m_my_component = my_component::type_id::create("m_my_component", this);
        m_my_p_component = my_param_component #(32,32)::type_id::create("m_my_p_component",this);
    endfunction: build

    task run_phase(uvm_phase phase);
        my_seq test_seq:
        my_param_seq #(.ADDR_WIDTH(32), .DATA_WIDTH(32)) p_test_seq;
        // Object and parameterised object create examples 
        test_seq = my_seq::type_id::create("test_seq"); 
        p_test_seq = my_param_seq #(32,32)::type_id::create("p_test_seq"); 
// ... 
endtask: run 

    