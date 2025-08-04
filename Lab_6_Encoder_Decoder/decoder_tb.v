module decoder_tb;
    reg [1:0] A;
    wire [3:0] Y;

    decoder_2to4_behavioral uut (.A(A), .Y(Y)); // or decoder_2to4_hierarchical

    initial begin
        $display("Input | Output");
        $monitor("%b   | %b", A, Y);
        A = 2'b00; #10;
        A = 2'b01; #10;
        A = 2'b10; #10;
        A = 2'b11; #10;
        $finish;
    end
endmodule