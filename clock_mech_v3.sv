module clock_mech(
	input logic clk, 
	input logic reset,
	output logic tiempo, //modificar tamaño
);
	//parametros:
	localparam count_max	=	999999;
	localparam c_n		=	$clog2(count_max);
	localparam cs_count_max	=	99;
	localparam cs_n		=	$clog2(cs_count_max);
	localparam s_count_max	=	59;
	localparam s_n		=	$clog2(s_count_max);
	localparam m_count_max	=	59;
	localparam m_n		=	$clog2(m_count_max);
	//logica auxiliar:
	logic [c_n-1:0] count;
	logic [cs_n -1:0] cs_count;
	logic [s_n- 1:0] s_count;
	logic [m_n -1:0] m_count;
	
	//asignaciones:
	
	//Mecanismo Reloj:
	always_ff @(posedge clk) begin
		if(reset) begin
			count <= 'd0;
			cs_count <= 'd0;
			s_count <= 'd0;
			m_count <= 'd0;
			
		end
		else if(count == count_max) begin
			if(cs_count == cs_count_max) begin
				cs_count <= 'd0;
				s_count <= s_count +'d1;
				
