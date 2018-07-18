//rx_control
//version: 0.1
module rx_control(
    input logic clk, reset, rx_ready, //reloj de 100 [MHz] / Boton de reset / señal de envio desde UART_rx
    //input logic [7:0] rx_data, //Data chunk
    output  logic enable_0, enable_1, enable_2, enable_3, enable_4, tx_signal, //Señales de activación para los retenedores/ LSB{0,1}, MSB{2,3}, CMD{4}
    output  logic [2:0] led_signal
  );
enum logic [3:0] {Wait_OP1_LSB, Store_OP1_LSB, Wait_OP1_MSB, Store_OP1_MSB, Wait_OP2_LSB, Store_OP2_LSB, Wait_OP2_MSB, Store_OP2_MSB, Wait_CMD, Store_CMD, Delay_1_cycle, Trigger_TX_result} state, next_state;   
logic delay_signal,tx_flag;
logic [2:0] led_flag;
assign led_signal   =   led_flag;
assign tx_signal    =   tx_flag;
always_comb begin  
    //defaults
    tx_flag         =   1'd0;
    next_state      = state;
    enable_0        =   1'd0;
    enable_1        =   1'd0;
    enable_2        =   1'd0;
    enable_3        =   1'd0;
    enable_4        =   1'd0; 
      case(state)
          Wait_OP1_LSB:   begin
              tx_flag   =   1'd0;
              if  (rx_ready)  begin
                  next_state  =   Store_OP1_LSB;
              end
          end
          Store_OP1_LSB:  begin
              enable_0    =   1'd1;
              next_state  =   Wait_OP1_MSB;
          end
          Wait_OP1_MSB:   begin
              if(rx_ready)    begin
                  next_state  =   Store_OP1_MSB;
              end
          end
          Store_OP1_MSB:  begin
              enable_1    =   1'd1;
              next_state  =   Wait_OP2_LSB;
          end
          Wait_OP2_LSB:   begin
              if(rx_ready)    begin
                  next_state  =   Store_OP2_LSB;
              end
          end
          Store_OP2_LSB:  begin
              enable_2    =   1'd1;
              next_state =   Wait_OP2_MSB;
          end
          Wait_OP2_MSB:   begin
              if  (rx_ready)  begin
                  next_state  =   Store_OP2_MSB;
              end
          end
          Store_OP2_MSB:  begin
              enable_3    =   1'd1;
              next_state  =   Wait_CMD;
          end
          Wait_CMD:   begin
              if  (rx_ready)  begin
                  next_state  =   Store_CMD;
              end
          end
          Store_CMD:  begin
              enable_4    =   1'd1;
              next_state  =   Delay_1_cycle;
          end
          Delay_1_cycle:  begin
              if  (delay_signal)  begin
                  next_state  =   Trigger_TX_result;
              end
          end
          Trigger_TX_result:  begin
                tx_flag   =   1'd1;
                next_state  =   Wait_OP1_LSB;
          end
      endcase
end      
always_ff @(posedge clk)    begin
    if  (reset) begin
        state   <=   Wait_OP1_LSB;
    end
    else    begin
        state   <=  next_state;
    end
end
always @(*)    begin //revisar si funciona
    delay_signal    <=  1'd0;
    if  (state  ==  Delay_1_cycle)  begin
        delay_signal    <=  1'd1;
    end
end
always@(posedge clk)    begin
    if (state == Wait_OP1_LSB)  begin
        led_flag    <=  'd4;
    end
    else if(state   ==  Wait_OP2_LSB)   begin
        led_flag    <=  'd2;
    end
    else if(state   ==  Wait_CMD)   begin
        led_flag    <=  'd1;
    end
 end
    
endmodule 
