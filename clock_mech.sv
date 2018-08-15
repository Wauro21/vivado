module clock_mech(
	input logic clk,
	input logic reset,
	input logic buttons, //temporalmente 1 bit ->original: 3
	output logic [16:0] secs	
    );
	localparam clock_f = 100; //clock frequency
	localparam counter_max = ((100000000/(2*clock_f))-1);
	localparam n_bits = $clog2(counter_max);
	localparam mod_bits = 6;
	logic [n_bits-1:0] counter = 'd0;
	logic time_tic;
	//clock divider
	always_ff @(posedge clk) begin
		if(reset) begin
			counter <= 'd0;
			time_tic <= 'd0;
		end
		else if (counter == counter_max) begin
			counter <= 'd0;
			time_tic <= ~time_tic;
		end
		else begin
			counter <= counter + 'd1;
		end
	end
	
	//aca ira un bloque case 
	//definicion temporal
	logic [mod_bits -1:0] modifier = 'd2; //logica del modificador para ff
	
	//ff
	logic [16:0] secs_pre;
	always @(posedge time_tic) begin
		//defaults
		secs_pre = secs;
		case(buttons)
			1'b0: secs_pre = secs + 'd100;
			1'b1: secs_pre = secs + 'd1;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			secs <= 'd0;
		end
		else begin
			secs <= secs_pre;
		end
	end
	
			
    
endmodule
