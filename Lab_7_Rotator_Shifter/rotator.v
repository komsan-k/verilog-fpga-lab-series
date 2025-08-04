module rotator (
    input [3:0] data_in,
    input [1:0] sel, // 00: ROL, 01: ROR
    output reg [3:0] data_out
);
    always @(*) begin
        case (sel)
            2'b00: data_out = {data_in[2:0], data_in[3]};
            2'b01: data_out = {data_in[0], data_in[3:1]};
            default: data_out = 4'b0000;
        endcase
    end
endmodule
