module encoder_tb;
    reg [3:0] I;
    wire [1:0] Y;

    encoder_4to2_behavioral uut (.I(I), .Y(Y)); // or encoder_4to2_hierarchical

    initial begin
        $display("Input  | Output");
        $monitor("%b  |  %b", I, Y);
        I = 4'b0001; #10;
        I = 4'b0010; #10;
        I = 4'b0100; #10;
        I = 4'b1000; #10;
        $finish;
    end
endmodule
