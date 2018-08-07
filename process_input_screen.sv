module procces_input_screen(
  input logic [4:0] val,
  input logic enter_button,
  input logic rst,
  input logic clk,
  output logic [15:0] op1, op2, output_number
);
  logic [15:0] resultado;
  logic overflow;
  
  ALU_generalizado #(.n_bits(16)) ALU1(
    .entrada_a(op1),
    .entrada_b(op2),
    .operacion(op),
    .resultado(resultado),
    .overflow(overflow)
  );
  enum logic [2;0] { OP1, RST1, OP2, RST2, ALU_CMD, SHOW_RESULT, RST3} state, next_state;
  always_comb begin
    //defaults
    next_state = state;
    
    case(state)
      OP1
