module tx_control(
    input logic clk, reset, tx_busy,
    input logic [1:0] stateID,
    input logic [15:0] raw_data,
    output logic tx_start,
    output logic [7:0] tx_data
    );
    enum logic [1:0] {IDLE, Wait_register, Send_0, Send_1} state, next_state;
    
    always_comb begin
      next_state  = state;
      next_1      = chunk_1;
      next_2      = chunk_2;
      tx_start    = 'd0;
      next_data   = temp_data;
      tx_next     = tx_data;
      
      case(state) begin
        IDLE: begin
          if (stateID ==  2'b11) begin
            next_state  = Wait_register;
          end
        end
        Wait_register:  begin
          if(stateID  ==  2'b00)  begin
            next_data = Send_0;
          end
          next_data = raw_data;
        end
        Send_0:  begin
          if(~tx_busy)begin
            
