// explain me the combinatinal part i mean does it mean it will run forever independent of 
// clock and logic and if i do sth like  load = apb.load 
// inside a alwyas comb does it mean it will load apb.load to load register just one time or everytime?

module dut(input logic clk, input logic reset,apb_if apb);
    //dut registers
    typedef enum [1:0]bit {
       RESET_st       =    2'b00,
       START       =    2'b01, 
       RUNNING     =    2'b10,
       STOP        =    2'b11
    } ctrl_state;
   

    //load the counter value form the interface
    logic [15:0] load;
    logic [15:0] count;
    bit INTR_REQ;
    bit en;
    assign en = apb.en;
    assign  apb.count    = count;
    assign  apb.INTR_REQ = INTR_REQ;

    ctrl_state curr_state,next_state;
    
    //Combinational Block 
    always_comb begin
              
               next_state = curr_state;
               case(curr_state)
                RESET_st: next_state = (en) ? START : RESET_st;
                START:    next_state = (en) ? RUNNING : STOP;
                RUNNING: next_state = (en && (count == 0)) ? STOP: RUNNING;
                STOP:   next_state = (en) ?  STOP: RESET_st;
               endcase
    end
    

    //Sequential block 
    always_ff @(posedge clk or negedge reset) begin
        if(!reset) 
            curr_state <= RESET_st;
        else if(!en)
            curr_state <= STOP;
        else 
            curr_state <= next_state;
        
        case(curr_state)
            RESET_st: begin  
                    load <= 16'd0;
                    count <= 16'd0;
                    INTR_REQ <= 1'b0;
            end
            START: begin
                   
                    count <= load;
            end
            RUNNING: begin 
                if(count > 0)
                    count <= count -1;
                else
                    INTR_REQ <= 1'b1;
            end
            STOP: begin

            end
        endcase
    end

   
endmodule
