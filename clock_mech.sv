module clock_mech(
	input logic clk,
	input logic reset,
	input logic buttons, //temporalmente 1 bit ->original: 3
	output logic [16:0] secs	
    );
	localparam cs_count_max = 999999; //1 centesima de segundo
	localparam n_cs = $clog2(cs_count_max);
	localparam ds_count_max = 9;
	localparam n_ds = $clog2(ds_count_max);
	localparam time_count_max = 59;
	localparam tc_s = $clog2(time_count_max);
	logic [n_cs -1 : 0] cs_count;
	logic [n_ds -1 : 0] ds_count;
	logic [tc_s -1 : 0] s_count;
	logic cs_flag, ds_flag, s_flag;
	always_ff @(posedge clk) begin
		if (reset) begin
			cs_count <= 'd0;
			cs_flag <= 'd0;
		end
		else if ( cs_count == cs_count_max) begin
			cs_count <= 'd0;
			cs_flag <= 'd1;
		end
		else begin
			cs_count <= cs_count + 'd1;
			cs_flag <= 'd0;
		end
	end
	//decima de segundo
	always_ff @(posedge clk) begin
		if (reset) begin
			ds_count <= 'd0;
			ds_flag <= 'd0;
		end
		else if ( ds_count == ds_count_max) begin
			ds_count <= 'd0;
			ds_flag <= 'd1;
		end
		else begin
			if (cs_flag) begin
				ds_count <= ds_count + 'd1;
			end
			else begin
				ds_flag <= ds_flag;
				ds_count <= ds_count;
			end
		end
	end
	//segundo
	always_ff @(posedge clk) begin
		if (reset) begin
			s_count <= 'd0;
			s_flag <= 'd0;
		end
		else if ( s_count == time_count_max) begin
			s_count <= 'd0;
			s_flag <= 'd1;
		end
		else begin
			if (s_flag) begin
				s_count <= s_count + 'd1;
			end
			else begin
				s_flag <= s_flag;
				s_count <= s_count;
			end
		end
	end
	//actualizacion hora
	always_ff @(posedge clk) begin
		if (reset) begin
			secs <= 'd0;
		end
		else if(s_flag) begin
			secs <= secs + 'd1;
		end
		else begin
			secs <= secs ;
		end
	end
	
    
endmodule
