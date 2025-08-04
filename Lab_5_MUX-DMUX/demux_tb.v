module demux_tb;
    reg D;
    reg [1:0] S;
    wire [3:0] Y;

    demux_1to4 uut (.D(D), .S(S), .Y(Y));

    initial begin
        $display("D  S | Y");
        D = 1;

        S = 2'b00; #10;
        S = 2'b01; #10;
        S = 2'b10; #10;
        S = 2'b11; #10;

        $finish;
    end
endmodule
