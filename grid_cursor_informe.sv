module grid_cursor(
	input clk, rst,
	input restriction,
	input dir_up, dir_down, dir_left, dir_right,
	output logic [2:0] pos_x,
	output logic [1:0] pos_y,
	output logic [4:0] val
	);
    
	logic [2:0]pos_x_next;
	logic [1:0]pos_y_next;

	//logic [1:0] ff;
	//logic [1:0]count_ne;
	//logic restriction_ne;
    
//definición de val
	always_comb
		case(pos_x)
			3'd0:
					case(pos_y)
						2'd0: val = 5'd0;
						2'd1: val = 5'd4;
						2'd2: val = 5'd8;
						2'd3: val = 5'hc;
					endcase
			3'd1:
					case(pos_y)
						2'd0: val = 5'd1;
						2'd1: val = 5'd5;
						2'd2: val = 5'd9;
						2'd3: val = 5'hd;
					endcase
		
			3'd2:
					case(pos_y)
						2'd0: val = 5'd2;
						2'd1: val = 5'd6;
						2'd2: val = 5'ha;
						2'd3: val = 5'he;
					endcase
			3'd3:
					case(pos_y)
						2'd0: val = 5'd3;
						2'd1: val = 5'd7;
						2'd2: val = 5'hb;
						2'd3: val = 5'hf;
					endcase
			3'd4:
					case(pos_y)
						2'd0: val = 5'b1_0000;//suma
						2'd1: val = 5'b1_0001;//mult
						2'd2: val = 5'b1_0010;//and
						2'd3: val = 5'b1_0011;//EXE
					endcase
			3'd5:
					case(pos_y)
						2'd0: val = 5'b1_0100;//resta
						2'd1: val = 5'b1_0101;//or
						2'd2: val = 5'b1_0110;//CE
						2'd3: val = 5'b1_0111;//CLR
					endcase
			default:
					val = 5'h1F;
		endcase

	//FILL HERE
	//movimiento de pos_x y pos_y.   

	logic [3:0] pb_buttons;
	assign pb_buttons = {dir_up,dir_down,dir_left,dir_right};
		
	always_comb  begin 
		pos_x_next = pos_x;
		pos_y_next = pos_y;
		case(pb_buttons)
			4'b1000: begin //arriba
				if (restriction) begin
					if (pos_y == 'd0) begin
						if (pos_x == 'd2 || pos_x == 'd3 )
							pos_y_next = 'd1;
						else if (pos_x == 'd0 || pos_x == 'd1)
							pos_y_next = 'd2;
						else
							pos_y_next = 'd3;
					end
					else
						pos_y_next = pos_y - 'd1;
				end	
				else begin
					if (pos_y == 'd0)
						pos_y_next = 'd3;
					else
						pos_y_next = pos_y - 'd1;
				end
			end
			
			4'b0100: begin //abajo
				if (restriction) begin
					if (pos_y == 'd1) begin
						if (pos_x == 'd2 || pos_x == 'd3 )
							pos_y_next = 'd0;
						else
							pos_y_next = pos_y + 'd1;
					end
					else if (pos_y == 'd2) begin
						if (pos_x == 'd0 || pos_x == 'd1)
							pos_y_next = 'd0;
						else
							pos_y_next = pos_y + 'd1;
					end
					else begin
						if ( pos_y == 'd3)
							pos_y_next = 'd0;
						else
							pos_y_next = pos_y + 'd1;
					end
				end	
				else begin
					if (pos_y == 'd3)
						pos_y_next = 'd0;
					else
						pos_y_next = pos_y + 'd1;
				end
			end
			4'b0010: begin //izquierda
				if (restriction) begin
					if ( pos_y == 'd2) begin
						if (pos_x == 'd4)
							pos_x_next = 'd1;
						else if (pos_x == 'd0)
							pos_x_next = 'd5;
						else
							pos_x_next = pos_x - 'd1;
					end
					else if (pos_y == 'd3) begin
						if (pos_x == 'd4)
							pos_x_next = 'd5;
						else
							pos_x_next = pos_x - 'd1;
					end
					else begin
						if (pos_x == 'd0)
							pos_x_next = 'd5;
						else
							pos_x_next = pos_x - 'd1;
					end
				end
				else begin
					if (pos_x == 'd0)
						pos_x_next = 'd5;
					else
						pos_x_next = pos_x - 'd1;
				end
			end
			4'b0001: begin // derecha
				if (restriction) begin
					if (pos_y == 'd2) begin
						if (pos_x == 'd1)
							pos_x_next = 'd4;
						else if (pos_x == 'd5)
							pos_x_next = 'd0;
						else
							pos_x_next = pos_x + 'd1;
					end
					else if (pos_y == 'd3) begin
						if (pos_x == 'd5)
							pos_x_next = 'd4;
						else
							pos_x_next = pos_x + 'd1;
					end
					else begin
						if (pos_x == 'd5)
							pos_x_next = 'd0;
						else
							pos_x_next = pos_x + 'd1;
					end
				end
				else begin
					if (pos_x == 'd5)
						pos_x_next = 'd0;
					else
						pos_x_next = pos_x + 'd1;
				end
			end
		endcase
	end				
	always_ff @(posedge clk) begin //Las posiciones se actualizan con los cantos del reloj
		if (rst) begin
			//se vuelve a la posicion inicial (0,0)
			pos_x	<=	3'd0;
			pos_y	<=	2'd0;
		end
		else begin
			if (restriction) begin
				if ( pos_y == 'd2 && (pos_x == 'd2 || pos_x == 'd3)) begin
					pos_y <= 'd1;
					pos_x <= pos_x;
				end
				else if (pos_y == 'd3) begin
					if (pos_x == 'd2 || pos_x == 'd3) begin
						pos_y <= 'd1;
						pos_x <= pos_x;
					end
					else if (pos_x == 'd0 || pos_x == 'd1) begin
						pos_y <= 'd2;
						pos_x <= pos_x;
					end
					else begin
						pos_y <= pos_y_next;
						pos_x <= pos_x_next;
					end
				end
				else begin
					pos_x <= pos_x_next;
					pos_y <= pos_y_next;
				end
			end
			else begin
				pos_x	<=	pos_x_next;
				pos_y	<=	pos_y_next;
			end
		end
	end
endmodule
