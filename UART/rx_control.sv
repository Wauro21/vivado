//rx_control
//version: 0.1
module rx_control(
    input logic clk, reset, rx_ready //reloj de 100 [MHz] / Boton de reset / señal de envio desde UART_rx
    input logic [7:0] rx_data, //Data chunk
    output  logic enable_0, enable_1, enable_2, //Señales de activación para los retenedores/ LSB, MSB, CMD
  );
  //enum logic [3:0] {Wait_OP1_LSB, Store_OP1_LSB, Wait_OP1_MSB, Store_OP1_MSB, Wait_OP2_LSB, Store
  enum logic [3:0] {Wait_OP_LSB, Store_OP_LSB, Wait_OP_MSB, Store_OP_MSB, Wait_CMD, Store_CMD, Delay_1_cycle, Trigger_TX_result} state, next_state;
  logic op_counter; // 0 -> Primer operando ; 1 -> Segundo operando
  always_comb begin  //FSM
      //defaults
      next_state  = state;
      op_counter  = 1'd0;
        case(state)
            Wait_OP:  begin
                if (op_counter) begin
                  
      
