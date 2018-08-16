module clock_mech(
	input logic clk,
	input logic reset,
	output logic [16:0] secs
);
	logic [31:0] counter;
	logic [16:0] mod;
	always_ff @(posedge clk) begin
		if (reset) begin
			counter <= 'd0;
			mod <= 'd0;
		end
		else if (counter == 'd99999999) begin
			counter <= 'd0;
			mod <= mod + 'd1;
		end
		else begin
			if(mod == 'd60) begin
				mod <= 'd0;
			end
			else begin
				counter <= counter + 'd1;
				mod <= mod;
			end
		end
	end
	
	always_ff @(posedge clk) begin
		if(reset) begin
			secs <= 'd0;
		end
		else begin
			secs <= mod;
		end
	end
endmodule
	
