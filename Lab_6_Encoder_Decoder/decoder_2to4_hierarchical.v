module decoder_2to4_hierarchical (
    input [1:0] A,
    output [3:0] Y
);
    wire [3:0] enable;
    assign enable = 4'b0001 << A;

    decoder_bit d0 (enable[0], Y[0]);
    decoder_bit d1 (enable[1], Y[1]);
    decoder_bit d2 (enable[2], Y[2]);
    decoder_bit d3 (enable[3], Y[3]);
endmodule
