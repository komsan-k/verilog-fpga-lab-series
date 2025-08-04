module mux_tb;
    reg [3:0] I;
    reg [1:0] S;
    wire Y;

    mux_4to1 uut (.I(I), .S(S), .Y(Y));

    initial begin
        $display(" I     S | Y");
        I = 4'b1010;

        S = 2'b00; #10;
        S = 2'b01; #10;
        S = 2'b10; #10;
        S = 2'b11; #10;

        $finish;
    end
endmodule
