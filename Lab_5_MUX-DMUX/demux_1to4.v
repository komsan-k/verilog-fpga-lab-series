module demux_1to4 (
    input D,
    input [1:0] S,
    output reg [3:0] Y
);
    always @(*) begin
        Y = 4'b0000;
        case (S)
            2'b00: Y = 4'b0001 & {4{D}};
            2'b01: Y = 4'b0010 & {4{D}};
            2'b10: Y = 4'b0100 & {4{D}};
            2'b11: Y = 4'b1000 & {4{D}};
        endcase
    end
endmodule
