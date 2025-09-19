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

