`timescale 1ns / 1ps

module logic_gates_tb;
    reg A, B;
    wire AND_out, OR_out, NOT_A;

    logic_gates uut (
        .A(A),
        .B(B),
        .AND_out(AND_out),
        .OR_out(OR_out),
        .NOT_A(NOT_A)
    );

    initial begin
        $display("A B | AND OR NOT_A");
        A = 0; B = 0; #10;
        $display("%b %b |  %b   %b   %b", A, B, AND_out, OR_out, NOT_A);
        A = 0; B = 1; #10;
        $display("%b %b |  %b   %b   %b", A, B, AND_out, OR_out, NOT_A);
        A = 1; B = 0; #10;
        $display("%b %b |  %b   %b   %b", A, B, AND_out, OR_out, NOT_A);
        A = 1; B = 1; #10;
        $display("%b %b |  %b   %b   %b", A, B, AND_out, OR_out, NOT_A);
        $finish;
    end
endmodule