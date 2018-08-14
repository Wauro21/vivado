module clock_mech (
    input logic clk,
    input logic reset,
		input logic [2:0] buttons,
    output logic [16:0] secs
    );
  localparam clock_f = 100; //clock frequency
	localparam counter_max=((100000000/(2*clock_f))-1);
	localparam n_bit = $clog2(counter_max);
	logic [n_bit-1:0] counter = 'd0;
	logic time_tic; //1 [s] clock
	always_ff @(posedge clk) begin
		if (reset) begin
			counter <= 'd0;
			time_tic <= 'd0;
		end
		else if ( counter == counter_max) begin
			counter <= 'd0;
			time_tic <= ~time_tic;
		end
		else begin
			counter <= counter + 'd1;
		end
	end
	
	always_comb begin
		
		case(buttons) //iz,cen,der
			3'b000:	begin // ningun boton presionado
				modifier = 'd0;
			end
			3'b100:	begin //boton izquierdo
endmodule
		
