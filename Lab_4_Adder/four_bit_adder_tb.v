module four_bit_adder_tb;
    reg [3:0] A, B;
    reg Cin;
    wire [3:0] Sum;
    wire Cout;

    four_bit_adder uut(.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));

    initial begin
        $display("   A    B  Cin |  Sum Cout");
        $monitor("%b %b   %b   |  %b   %b", A, B, Cin, Sum, Cout);

        A = 4'b0001; B = 4'b0010; Cin = 0; #10;
        A = 4'b1111; B = 4'b0001; Cin = 0; #10;
        A = 4'b1010; B = 4'b0101; Cin = 1; #10;

        $finish;
    end
endmodule
