module dithering #(parameter THOLD=8)(
    input logic [7:0] channel,
    input logic SW,
    output logic dithered
);
    always_comb begin
        dithered = channel;
        case(SW)
            1'b0:   dithered = channel;
            1'b1:   begin
                if (channel[7:4] >'d15 && channel[3:0] >= THOLD) begin
                    dithered = {channel[7:4] + 'd1, 'd0};
                end
                else begin
                    dithered = channel;
            end
        endcase
    end
    
