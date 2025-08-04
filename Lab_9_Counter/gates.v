module logic_gates (
    input wire A,
    input wire B,
    output wire AND_out,
    output wire OR_out,
    output wire NOT_A
);
    assign AND_out = A & B;
    assign OR_out = A | B;
    assign NOT_A = ~A;
endmodule