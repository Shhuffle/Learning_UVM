class seq_item extends uvm_seq_item;

    rand logic [15:0] load;
    rand bit en;

    logic [15:0]count;
    bit INTR_REQ;

    `uvm_objet_utils(seq_item)

    function new (string = "m_seq_item")
        super.new(string);
    endfunction

    //load value between 10 to 100.
    constraint validload {load inside {[10:100]} ; }
endclass
