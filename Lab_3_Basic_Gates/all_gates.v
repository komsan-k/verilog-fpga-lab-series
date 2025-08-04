module all_gates (
    input A, input B,
    output AND_out, OR_out, NAND_out,
    output NOR_out, XOR_out, XNOR_out
);
    assign AND_out  = A & B;
    assign OR_out   = A | B;
    assign NAND_out = ~(A & B);
    assign NOR_out  = ~(A | B);
    assign XOR_out  = A ^ B;
    assign XNOR_out = ~(A ^ B);
endmodule