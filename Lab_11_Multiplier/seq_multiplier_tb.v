module seq_multiplier_tb;
    reg clk, rst, start;
    reg [3:0] A, B;
    wire [7:0] product;
    wire done;

    seq_multiplier_4bit uut (
        .clk(clk), .rst(rst), .start(start),
        .A(A), .B(B),
        .product(product), .done(done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; start = 0; A = 0; B = 0; #10;
        rst = 0;
        A = 4'd3; B = 4'd5; start = 1; #100;
        $display("Product = %d", product);
        $finish;
    end
endmodule
