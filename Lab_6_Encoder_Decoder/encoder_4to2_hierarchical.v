module encoder_4to2_hierarchical (
    input [3:0] I,
    output reg [1:0] Y
);
    always @(*) begin
        casez (I)
            4'b???1: Y = 2'b00;
            4'b??10: Y = 2'b01;
            4'b?100: Y = 2'b10;
            4'b1000: Y = 2'b11;
            default: Y = 2'b00;
        endcase
    end
endmodule
