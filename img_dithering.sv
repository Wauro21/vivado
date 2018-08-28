`timescale 1ns / 1ps

module img_dithering(
	input logic [7:0] R,
	input logic [7:0] G,
	input logic [7:0] B,
	input logic enable,
	output logic [3:0] R_out,
	output logic [3:0] G_out,
	output logic [3:0] B_out
);
	always_comb begin
		if(enable) begin
			if(R[3:0] >= 4'd8 && R[7:4] < 4'd15) begin
				R_out = R[7:4] + 4'd1;
			end else begin
				R_out = R[7:4];
			end

			if(G[3:0] >= 4'd8 && G[7:4] < 4'd15) begin
				G_out = G[7:4] + 4'd1;
			end else begin
				G_out = G[7:4];
			end

			if(B[3:0] >= 4'd8 && B[7:4] < 4'd15) begin
				B_out = B[7:4] + 4'd1;
			end else begin
				B_out = B[7:4];
			end
		end else begin
			R_out = R[7:4];
			G_out = G[7:4];
			B_out = B[7:4];
		end
	end
endmodule
