module multiplier_tb;
    reg [3:0] A, B;
    wire [7:0] P;

    multiplier_4bit uut (.A(A), .B(B), .P(P));

    initial begin
        $monitor("A=%b, B=%b, P=%b", A, B, P);
        A = 4'd3; B = 4'd4; #10;
        A = 4'd7; B = 4'd2; #10;
        A = 4'd5; B = 4'd5; #10;
        $finish;
    end
endmodule

