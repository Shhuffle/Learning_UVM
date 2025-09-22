class bus_seq_item extends uvm_sequence_item;
    rand logic[31:0] addr;
    rand logic[31:0] write_data;
    rand bit read_not_write;
    rand int delay;
    //Response data properties are NOT rand
    bit error;
    logic [31:0] read_data;
    `uvm_objet_utils(bus_seq_item)
    function new(string name = "bus_seq_item");
        super.new(name);
    endfunction

    constraint at_least_1 {delay inside {[1:20]} ; }

    constraint align_32 {addr[1:0] == 0;} //ensures the last 2 bit are always 0.

endclass: bus_seq_item
    
