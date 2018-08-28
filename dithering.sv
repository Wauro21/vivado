module dithering(
	input logic [7:0] channel,
	input logic SW,
	output logic [7:0] d_channel
);
	//Menesteres
	logic [3:0] MSN;
	logic [1:0] MS2b;
	logic [7:0] dithered;
	//Control del Switch
	always_comb begin
		//defaults
		d_channel = channel;
		case(SW)
			1'b1:	d_channel = dithered;
			1'b0:	d_channel = channel;
		endcase
	end
	
	//Dithering
	always_comb begin
		MSN = channel[7:4];
		MS2b = channel [3:2];
		if ( MSN == 'hFF) begin
			dithered = MSN;
		end
		
