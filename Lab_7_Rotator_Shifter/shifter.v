module shifter (
    input [3:0] data_in,
    input [1:0] sel, // 00: LSL, 01: LSR, 10: ASR
    output reg [3:0] data_out
);
    always @(*) begin
        case (sel)
            2'b00: data_out = data_in << 1;
            2'b01: data_out = data_in >> 1;
            2'b10: data_out = {data_in[3], data_in[3:1]};
            default: data_out = 4'b0000;
        endcase
    end
endmodule